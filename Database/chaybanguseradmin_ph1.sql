-- ============================
-- STORED PROCEDURES / FUNCTIONS for DatabaseHelper.cs
-- ============================

-- 1. GetApplicationRoles (return list)
CREATE OR REPLACE PROCEDURE get_application_roles(p_roles OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN p_roles FOR
    SELECT role FROM dba_roles
    WHERE role IN ('SV','NVCB','GV','NVPDT','NVPKT','NVTCHC','NVCTSV','TRGDV')
    ORDER BY role;
END;
/

CREATE OR REPLACE PROCEDURE get_all_roles(p_roles OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN p_roles FOR
    SELECT role
    FROM dba_roles
    WHERE role IN (
      SELECT role
      FROM dba_role_privs
      WHERE grantee = 'USER_ADMIN'
    )
    ORDER BY role;
END;
/


SELECT * FROM DBA_ROLES WHERE ROLE = 'TEST';
SELECT * FROM DBA_ROLES;



-- 2. GetUsersByRole (return list)
CREATE OR REPLACE PROCEDURE get_users_by_role (
  p_role IN VARCHAR2,
  p_users OUT SYS_REFCURSOR
)
IS
BEGIN
  OPEN p_users FOR
    SELECT GRANTEE FROM DBA_ROLE_PRIVS
    WHERE GRANTED_ROLE = UPPER(p_role)
    ORDER BY GRANTEE;
END;

-- 3. GetSystemPrivileges (return list)
CREATE OR REPLACE PROCEDURE get_system_privileges(p_privs OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN p_privs FOR
    SELECT DISTINCT PRIVILEGE
    FROM USER_SYS_PRIVS
    ORDER BY PRIVILEGE;
END;
/

-- 4. GetObjectPrivileges (return fixed values)
CREATE OR REPLACE FUNCTION get_object_privileges
RETURN SYS.ODCIVARCHAR2LIST
IS
BEGIN
  RETURN SYS.ODCIVARCHAR2LIST(
    'SELECT','INSERT','UPDATE','DELETE','REFERENCES','INDEX','EXECUTE'
  );
END;
/

-- 5. GetTables
CREATE OR REPLACE PROCEDURE get_user_tables(p_result OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN p_result FOR
    SELECT OBJECT_NAME FROM ALL_OBJECTS
    WHERE OBJECT_TYPE = 'TABLE'
    AND OWNER = USER
    ORDER BY OBJECT_NAME;
END;
/

-- 6. GetViews
CREATE OR REPLACE PROCEDURE get_user_views(p_result OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN p_result FOR
    SELECT OBJECT_NAME FROM ALL_OBJECTS
    WHERE OBJECT_TYPE = 'VIEW'
    AND OWNER = USER
    ORDER BY OBJECT_NAME;
END;
/

-- 7. GetProcedures
CREATE OR REPLACE PROCEDURE get_user_procedures(p_result OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN p_result FOR
    SELECT OBJECT_NAME FROM ALL_OBJECTS
    WHERE OBJECT_TYPE = 'PROCEDURE'
    AND OWNER = USER
    ORDER BY OBJECT_NAME;
END;
/

-- 8. GetFunctions
CREATE OR REPLACE PROCEDURE get_user_functions(p_result OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN p_result FOR
    SELECT OBJECT_NAME FROM ALL_OBJECTS
    WHERE OBJECT_TYPE = 'FUNCTION'
    AND OWNER = USER
    ORDER BY OBJECT_NAME;
END;
/

CREATE OR REPLACE PROCEDURE get_compatible_objects (
    p_privilege IN VARCHAR2,
    p_result OUT SYS_REFCURSOR
)
IS
BEGIN
  IF UPPER(p_privilege) IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE') THEN
    OPEN p_result FOR
      SELECT OBJECT_NAME FROM ALL_OBJECTS
      WHERE OBJECT_TYPE IN ('TABLE', 'VIEW') AND OWNER = USER;
  ELSIF UPPER(p_privilege) IN ('INDEX', 'REFERENCES') THEN
    OPEN p_result FOR
      SELECT OBJECT_NAME FROM ALL_OBJECTS
      WHERE OBJECT_TYPE = 'TABLE' AND OWNER = USER;
  ELSIF UPPER(p_privilege) = 'EXECUTE' THEN
    OPEN p_result FOR
      SELECT OBJECT_NAME FROM ALL_OBJECTS
      WHERE OBJECT_TYPE IN ('PROCEDURE', 'FUNCTION') AND OWNER = USER;
  ELSE
    OPEN p_result FOR SELECT 'NO_OBJECT' FROM DUAL;
  END IF;
END;
/
-------------------------------------------------------------------------------
-- PH1
-- ROLE
-- CHECK IF ROLE EXISTS
CREATE OR REPLACE PROCEDURE check_role_exists(
    p_role_name IN VARCHAR2,
    p_exists OUT NUMBER
) AS
BEGIN
    SELECT COUNT(*) INTO p_exists
    FROM dba_roles
    WHERE role = UPPER(TRIM(p_role_name));
END;
/

-- CREATE ROLE WITHOUT QUOTES
CREATE OR REPLACE PROCEDURE create_role(role_name IN VARCHAR2) AS
BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE ' || UPPER(role_name);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error creating role: ' || SQLERRM);
END;
/

-- REVOKE PRIVILEGES (INCLUDING COLUMN-BASED UPDATE/REFERENCE MAPPING)
CREATE OR REPLACE PROCEDURE revoke_priv_from_role (
    p_rolename     IN VARCHAR2,
    p_privilege    IN VARCHAR2,
    p_object_name  IN VARCHAR2
) AS
    v_sql           VARCHAR2(1000);
    v_schema        VARCHAR2(100);
    v_table         VARCHAR2(100);
    v_column        VARCHAR2(100);
    v_object_full   VARCHAR2(200);
BEGIN
    IF p_object_name IS NULL THEN
        -- System privilege
        v_sql := 'REVOKE ' || p_privilege || ' FROM ' || UPPER(p_rolename);

    ELSIF REGEXP_COUNT(p_object_name, '\.') = 2 THEN
    -- Object like USER_ADMIN.TABLE.COLUMN
    v_schema  := REGEXP_SUBSTR(p_object_name, '^[^.]+');
    v_table   := REGEXP_SUBSTR(p_object_name, '[^.]+', 1, 2);
    v_object_full := v_schema || '.' || v_table;

    IF UPPER(p_privilege) IN ('UPDATE', 'REFERENCES') THEN
        -- Chỉ được revoke toàn bảng
        v_sql := 'REVOKE ' || p_privilege || ' ON ' || v_object_full || ' FROM ' || UPPER(p_rolename);
    ELSE
        -- SELECT (column) thì không sao
        v_sql := 'REVOKE ' || p_privilege || ' ON ' || p_object_name || ' FROM ' || UPPER(p_rolename);
    END IF;

    ELSIF p_object_name IS NOT NULL THEN
        -- object level revoke bình thường
        v_sql := 'REVOKE ' || p_privilege || ' ON ' || p_object_name || ' FROM ' || UPPER(p_rolename);
    ELSE
        -- system privilege
        v_sql := 'REVOKE ' || p_privilege || ' FROM ' || UPPER(p_rolename);
    END IF;

    DBMS_OUTPUT.PUT_LINE('EXECUTE: ' || v_sql);
    EXECUTE IMMEDIATE v_sql;
END;
/

-- GET PRIVILEGES OF ROLE
CREATE OR REPLACE PROCEDURE get_privs_of_role (
    p_role_name IN VARCHAR2,
    p_privs     OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_privs FOR
        SELECT privilege || ' ON ' || owner || '.' || table_name || '.' || column_name AS priv_detail
        FROM dba_col_privs
        WHERE grantee = UPPER(p_role_name)

        UNION ALL

        SELECT privilege || ' ON ' || owner || '.' || table_name
        FROM dba_tab_privs
        WHERE grantee = UPPER(p_role_name)
          AND (owner, table_name) NOT IN (
                SELECT owner, table_name
                FROM dba_col_privs
                WHERE grantee = UPPER(p_role_name)
          )

        UNION ALL

        SELECT privilege
        FROM dba_sys_privs
        WHERE grantee = UPPER(p_role_name);
END;
/

-- Xóa Role
CREATE OR REPLACE PROCEDURE drop_role(role_name IN VARCHAR2) AS
BEGIN
    EXECUTE IMMEDIATE 'DROP ROLE ' || role_name;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error dropping role: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE grant_priv_to_role (
    p_role        IN VARCHAR2,
    p_priv        IN VARCHAR2,
    p_type        IN VARCHAR2,
    p_obj_name    IN VARCHAR2 DEFAULT NULL,
    p_column      IN VARCHAR2 DEFAULT NULL
)
IS
    v_sql        VARCHAR2(1000);
    v_view_name  VARCHAR2(200);
    v_obj_full   VARCHAR2(200);
BEGIN
    -- Bổ sung schema nếu thiếu
    IF p_obj_name IS NOT NULL AND INSTR(p_obj_name, '.') = 0 THEN
        v_obj_full := 'USER_ADMIN.' || p_obj_name;
    ELSE
        v_obj_full := p_obj_name;
    END IF;

    -- SYSTEM privilege
    IF UPPER(p_type) = 'SYSTEM' THEN
        v_sql := 'GRANT ' || p_priv || ' TO ' || p_role;

    -- OBJECT privilege
    ELSIF UPPER(p_type) = 'OBJECT' THEN
        -- Trường hợp đặc biệt: SELECT trên cột → tạo view
        IF p_column IS NOT NULL AND UPPER(p_priv) = 'SELECT' THEN
            -- Tạo tên view duy nhất
            v_view_name := 'v_' || LOWER(p_obj_name) || '_' || LOWER(p_column) || '_' || LOWER(p_role);

            -- Tạo VIEW chỉ chứa 1 cột
            v_sql := 'CREATE OR REPLACE VIEW ' || v_view_name ||
                     ' AS SELECT ' || p_column || ' FROM ' || v_obj_full;
            EXECUTE IMMEDIATE v_sql;

            -- Cấp quyền SELECT trên view
            v_sql := 'GRANT SELECT ON ' || v_view_name || ' TO ' || p_role;

        -- UPDATE trên cột
        ELSIF p_column IS NOT NULL AND UPPER(p_priv) = 'UPDATE' THEN
            v_sql := 'GRANT UPDATE (' || p_column || ') ON ' || v_obj_full || ' TO ' || p_role;

        -- Các quyền thông thường
        ELSE
            v_sql := 'GRANT ' || p_priv || ' ON ' || v_obj_full || ' TO ' || p_role;
        END IF;
    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Invalid type: ' || p_type);
    END IF;

    DBMS_OUTPUT.PUT_LINE('Executing: ' || v_sql); -- Debug
    EXECUTE IMMEDIATE v_sql;
END;
/


-- User
CREATE OR REPLACE PROCEDURE get_users_without_roles (
    p_users OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_users FOR
        SELECT username
        FROM dba_users
        WHERE username NOT IN (
            SELECT DISTINCT grantee FROM dba_role_privs
        )
        AND account_status = 'OPEN';
END;
/

-- Kiểm tra user tồn tại
CREATE OR REPLACE PROCEDURE check_user_exists(
    p_username IN VARCHAR2,
    p_exists OUT NUMBER
)
AS
BEGIN
    SELECT COUNT(*) INTO p_exists
    FROM dba_users
    WHERE username = UPPER(TRIM(p_username));
END;
/

-- Tạo User
CREATE OR REPLACE PROCEDURE create_user(username IN VARCHAR2, password IN VARCHAR2) AS
BEGIN
    EXECUTE IMMEDIATE 'CREATE USER ' || username || ' IDENTIFIED BY "' || password || '"';
    EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO ' || username;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error creating user: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE grant_role_to_user (
    p_username IN VARCHAR2,
    p_rolename IN VARCHAR2
) AS
BEGIN
    EXECUTE IMMEDIATE 'GRANT "' || p_rolename || '" TO "' || p_username || '"';
END;
/

-- Cấp quyền cho user
CREATE OR REPLACE PROCEDURE grant_priv_to_user (
    p_username     IN VARCHAR2,
    p_privilege    IN VARCHAR2,
    p_type         IN VARCHAR2,
    p_object_name  IN VARCHAR2 DEFAULT NULL,
    p_column_name  IN VARCHAR2 DEFAULT NULL,
    p_with_grant   IN BOOLEAN DEFAULT FALSE
)
AS
    v_sql           VARCHAR2(1000);
    v_obj_fullname  VARCHAR2(200);
    v_view_name     VARCHAR2(200);
BEGIN
    -- Bổ sung schema nếu thiếu
    IF p_object_name IS NOT NULL AND INSTR(p_object_name, '.') = 0 THEN
        v_obj_fullname := 'USER_ADMIN.' || p_object_name;
    ELSE
        v_obj_fullname := p_object_name;
    END IF;

    -- System privilege
    IF UPPER(p_type) = 'SYSTEM' THEN
        v_sql := 'GRANT ' || p_privilege || ' TO "' || p_username || '"';

    -- Object privilege
    ELSIF UPPER(p_type) = 'OBJECT' THEN
        -- Special case: SELECT on column
        IF p_column_name IS NOT NULL AND UPPER(p_privilege) = 'SELECT' THEN
            -- Generate view name
            v_view_name := 'v_' || LOWER(p_object_name) || '_' || LOWER(p_column_name) || '_' || LOWER(p_username);

            -- Create view
            v_sql := 'CREATE OR REPLACE VIEW ' || v_view_name ||
                     ' AS SELECT ' || p_column_name || ' FROM ' || v_obj_fullname;
            EXECUTE IMMEDIATE v_sql;

            -- Grant select on view
            v_sql := 'GRANT SELECT ON ' || v_view_name || ' TO "' || p_username || '"';

        -- Other privileges
        ELSIF p_column_name IS NOT NULL AND UPPER(p_privilege) = 'UPDATE' THEN
            v_sql := 'GRANT UPDATE (' || p_column_name || ') ON ' || v_obj_fullname || ' TO "' || p_username || '"';
        ELSE
            v_sql := 'GRANT ' || p_privilege || ' ON ' || v_obj_fullname || ' TO "' || p_username || '"';
        END IF;

    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Invalid privilege type: ' || p_type);
    END IF;

    -- WITH GRANT OPTION (chỉ áp dụng nếu không phải view)
    IF p_with_grant THEN
        v_sql := v_sql || ' WITH GRANT OPTION';
    END IF;

    DBMS_OUTPUT.PUT_LINE('EXECUTING: ' || v_sql);
    EXECUTE IMMEDIATE v_sql;
END;
/

-- Xóa User
CREATE OR REPLACE PROCEDURE drop_user(username IN VARCHAR2) AS
BEGIN
    EXECUTE IMMEDIATE 'DROP USER ' || username || ' CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error dropping user: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE get_privs_of_user (
    p_username IN VARCHAR2,
    p_privs    OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_privs FOR
        SELECT privilege, owner || '.' || table_name AS object_name, column_name,
               CASE WHEN grantable = 'YES' THEN 'Yes' ELSE 'No' END AS with_grant
        FROM dba_col_privs
        WHERE grantee = UPPER(p_username)

        UNION ALL

        SELECT privilege, owner || '.' || table_name, NULL,
               CASE WHEN grantable = 'YES' THEN 'Yes' ELSE 'No' END
        FROM dba_tab_privs
        WHERE grantee = UPPER(p_username)

        UNION ALL

        SELECT privilege, NULL, NULL, 'No'
        FROM dba_sys_privs
        WHERE grantee = UPPER(p_username);
END;
/

CREATE OR REPLACE PROCEDURE revoke_priv_from_user (
    p_username     IN VARCHAR2,
    p_privilege    IN VARCHAR2,
    p_object_name  IN VARCHAR2 DEFAULT NULL
)
AS
    v_sql VARCHAR2(1000);
BEGIN
    IF p_object_name IS NULL THEN
        -- Revoke system privilege
        v_sql := 'REVOKE ' || p_privilege || ' FROM "' || p_username || '"';
    ELSE
        -- Revoke object privilege
        v_sql := 'REVOKE ' || p_privilege || ' ON ' || p_object_name || ' FROM "' || p_username || '"';
    END IF;

    EXECUTE IMMEDIATE v_sql;
END;
/

-- Thu hồi role từ user
CREATE OR REPLACE PROCEDURE revoke_role_from_user(p_username IN VARCHAR2, p_rolename IN VARCHAR2) IS
BEGIN
    EXECUTE IMMEDIATE 'REVOKE ' || p_rolename || ' FROM ' || p_username;
    DBMS_OUTPUT.PUT_LINE('Đã thu hồi role ' || p_rolename || ' từ user ' || p_username);
END;
/

-----------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_vaitro RETURN VARCHAR2
--AUTHID CURRENT_USER 
IS
    v_role VARCHAR2(10);
BEGIN
    -- Lấy trong NHANVIEN
    BEGIN
        SELECT VAITRO INTO v_role
        FROM user_admin.NHANVIEN
        WHERE MANV = SYS_CONTEXT('USERENV', 'SESSION_USER');
        
        RETURN v_role;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL; -- Không tìm thấy trong NHANVIEN, thử tiếp ở SINHVIEN
    END;
    BEGIN
        SELECT 'SV' INTO v_role
        FROM user_admin.SINHVIEN
        WHERE MASV = SYS_CONTEXT('USERENV', 'SESSION_USER');

        RETURN v_role;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Không có trong cả NHANVIEN và SINHVIEN thì báo lỗi
            RAISE_APPLICATION_ERROR(-20001, 'Người dùng không phải nhân viên hoặc sinh viên.');
    END;
END;
/

GRANT EXECUTE ON get_vaitro TO PUBLIC;