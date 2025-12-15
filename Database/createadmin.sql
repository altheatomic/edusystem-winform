ALTER SESSION SET CONTAINER = CDB$ROOT;
--alter session set container=xepdb1;

--DROP USER user_admin CASCADE;
--CREATE USER user_admin IDENTIFIED BY user_admin;

CREATE PLUGGABLE DATABASE ATBM  
  ADMIN USER user_admin IDENTIFIED BY user_admin  
  FILE_NAME_CONVERT = ('D:\app\Admin\product\21c\oradata\XE\pdbseed', 
                    'D:\app\Admin\product\21c\oradata\XE\ATBM');
                       
ALTER PLUGGABLE DATABASE ATBM OPEN;
alter pluggable database ATBM save state;

ALTER SESSION SET CONTAINER = ATBM;
/* ALTER SYSTEM DISABLE RESTRICTED SESSION;

-- Xem có bị lỗi restrict k
SELECT NAME, OPEN_MODE, RESTRICTED FROM V$PDBS;

-- Restrict là do bị lỗi gì đó đó, giải quyết lỗi xong đóng r mở lại
SELECT * FROM PDB_PLUG_IN_VIOLATIONS WHERE STATUS != 'RESOLVED';
ALTER PLUGGABLE DATABASE ATBM CLOSE IMMEDIATE;
ALTER PLUGGABLE DATABASE ATBM OPEN;
*/

CREATE TABLESPACE USERS
  DATAFILE 'D:\app\Admin\product\21c\oradata\XE\ATBM\users01.dbf'
  SIZE 100M
  AUTOEXTEND ON
  NEXT 10M MAXSIZE UNLIMITED;
 
 -- Cấp quyền
GRANT CONNECT TO user_admin;
GRANT CREATE SESSION TO user_admin;
-- GRANT ALL PRIVILEGES TO user_admin with ADMIN OPTION;

-- Cho phép tạo và xóa user/role
GRANT CREATE USER, ALTER USER, DROP USER TO user_admin;
GRANT CREATE ROLE TO user_admin;

-- CHo phép admin cấp role hoặc quyền cho bất cứ user nào khác
GRANT GRANT ANY ROLE TO user_admin;
GRANT GRANT ANY PRIVILEGE TO user_admin;

-- CHo phép xem quyền của user khác
GRANT SELECT_CATALOG_ROLE TO user_admin;

-- Cấp quyền thao tác trên bảng, view, proc, func, seq, trig
GRANT CREATE TABLE, ALTER ANY TABLE, DROP ANY TABLE TO user_admin;
GRANT SELECT ANY TABLE, INSERT ANY TABLE, UPDATE ANY TABLE, DELETE ANY TABLE TO user_admin;
GRANT CREATE VIEW TO user_admin;
GRANT CREATE PROCEDURE TO user_admin;
GRANT EXECUTE ANY PROCEDURE TO user_admin;
GRANT CREATE TRIGGER TO user_admin;
GRANT CREATE SEQUENCE, DROP ANY SEQUENCE TO user_admin;
-- Giả sử bạn muốn dùng USERS (nên dùng thay vì SYSTEM):
ALTER USER user_admin DEFAULT TABLESPACE USERS;
ALTER USER user_admin QUOTA UNLIMITED ON USERS;

-- Cấp quyền cho phép user khác phân quyền
GRANT SELECT ON DBA_TAB_PRIVS TO user_admin WITH GRANT OPTION;
GRANT SELECT ON ROLE_TAB_PRIVS TO user_admin WITH GRANT OPTION;
GRANT SELECT ON USER_ROLE_PRIVS TO user_admin WITH GRANT OPTION;
GRANT SELECT ON DBA_SYS_PRIVS TO user_admin WITH GRANT OPTION;
GRANT SELECT ON DBA_ROLES TO user_admin WITH GRANT OPTION;
GRANT SELECT ON DBA_USERS TO user_admin WITH GRANT OPTION;
GRANT SELECT ON DBA_TABLES TO user_admin WITH GRANT OPTION;

-- Cấp quyền để dùng VPD / RLS
GRANT EXECUTE ON DBMS_RLS TO user_admin;

-- Cấp quyền audit
GRANT EXECUTE ON DBMS_FGA TO user_admin;
GRANT SELECT ON SYS.FGA_LOG$ TO user_admin;
GRANT SELECT ON DBA_AUDIT_TRAIL TO user_admin;

GRANT SELECT ON DBA_ROLE_PRIVS TO user_admin;
--CREATE ROLE ADMIN
/*
SELECT NAME, OPEN_MODE, RESTRICTED, CON_ID 
FROM V$PDBS;
*/
