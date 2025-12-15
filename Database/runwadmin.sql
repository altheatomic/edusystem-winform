--ALTER DATABASE OPEN;
alter session set container=ATBM;
-- Tạo CSDL --------------------------------------------------------------------
/* Xóa
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE DANGKY CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE MOMON CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE HOCPHAN CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE NHANVIEN CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE SINHVIEN CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE DONVI CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

-- Xóa dữ liệu
DELETE FROM DANGKY;
DELETE FROM MOMON;
DELETE FROM HOCPHAN;
DELETE FROM SINHVIEN;
DELETE FROM NHANVIEN;
UPDATE DONVI SET TRGDV = NULL;
DELETE FROM DONVI;

-- Xóa sequence
DROP SEQUENCE SEQ_IDNHANVIEN;
DROP SEQUENCE SEQ_IDSINHVIEN;
DROP SEQUENCE SEQ_IDHOCPHAN;
DROP SEQUENCE SEQ_IDMOMON;

-- Xóa function (nếu muốn reset)
DROP FUNCTION GET_MA_NV;
DROP FUNCTION GET_MA_SV;
DROP FUNCTION GET_MA_HP;
DROP FUNCTION GET_MA_MM;

COMMIT;
*/

CREATE TABLE DONVI (
    MADV VARCHAR2(10) PRIMARY KEY,
    TENDV VARCHAR2(50),
    LOAIDV VARCHAR2(10) CHECK (LOAIDV IN ('Khoa', 'Phòng')),
    TRGDV VARCHAR2(10)
);

CREATE TABLE NHANVIEN (
    MANV VARCHAR2(10) PRIMARY KEY,
    HOTEN VARCHAR2(50),
    PHAI CHAR(10) CHECK (PHAI IN ('Nam', 'Nữ')),
    NGSINH DATE NOT NULL,
    LUONG NUMBER(10, 2),
    PHUCAP NUMBER(10, 2),
    DT VARCHAR2(15),
    VAITRO VARCHAR2(10),
    MADV VARCHAR2(10)
);

CREATE TABLE SINHVIEN (
    MASV VARCHAR2(10) PRIMARY KEY,
    HOTEN VARCHAR2(50),
    PHAI CHAR(10) CHECK (PHAI IN ('Nam', 'Nữ')),
    NGSINH DATE NOT NULL,
    DCHI VARCHAR2(100),
    DT VARCHAR2(15),
    KHOA VARCHAR2(10),
    TINHTRANG VARCHAR2(20)
);

CREATE TABLE HOCPHAN (
    MAHP VARCHAR2(10) PRIMARY KEY,
    TENHP VARCHAR2(50),
    SOTC NUMBER(4),
    STLT NUMBER(4),
    STTH NUMBER(4),
    MADV VARCHAR2(10)
);

CREATE TABLE MOMON (
    MAMM VARCHAR2(10) PRIMARY KEY,
    MAHP VARCHAR2(10),
    MAGV VARCHAR2(10),
    HK NUMBER(1) CHECK (HK BETWEEN 1 AND 3),
    NAM NUMBER(4)
);

CREATE TABLE DANGKY (
    MASV VARCHAR2(10),
    MAMM VARCHAR2(10),
    DIEMTH NUMBER(5, 2),
    DIEMQT NUMBER(5, 2),
    DIEMCK NUMBER(5, 2),
    DIEMTK NUMBER(5, 2),
    PRIMARY KEY (MASV, MAMM)
);

ALTER TABLE DONVI ADD CONSTRAINT FDONVI_TRGDV FOREIGN KEY (TRGDV) REFERENCES NHANVIEN(MANV);
ALTER TABLE NHANVIEN ADD CONSTRAINT FNHANVIEN_MADV FOREIGN KEY (MADV) REFERENCES DONVI(MADV);
ALTER TABLE SINHVIEN ADD CONSTRAINT FSINHVIEN_KHOA FOREIGN KEY (KHOA) REFERENCES DONVI(MADV);
ALTER TABLE HOCPHAN ADD CONSTRAINT FHOCPHAN_MADV FOREIGN KEY (MADV) REFERENCES DONVI(MADV);
ALTER TABLE MOMON ADD CONSTRAINT FMOMON_MAHP FOREIGN KEY (MAHP) REFERENCES HOCPHAN(MAHP);
ALTER TABLE MOMON ADD CONSTRAINT FMOMON_MAGV FOREIGN KEY (MAGV) REFERENCES NHANVIEN(MANV);
ALTER TABLE DANGKY ADD CONSTRAINT FDANGKY_MASV FOREIGN KEY (MASV) REFERENCES SINHVIEN(MASV);
ALTER TABLE DANGKY ADD CONSTRAINT FDANGKY_MAMM FOREIGN KEY (MAMM) REFERENCES MOMON(MAMM);


-- Xóa dữ liệu nếu có trước đó -------------------------------------------------

DELETE FROM DANGKY;
DELETE FROM MOMON;
DELETE FROM HOCPHAN;
DELETE FROM SINHVIEN;

UPDATE DONVI SET TRGDV = NULL;
UPDATE NHANVIEN SET MADV = NULL;
DELETE FROM NHANVIEN;
DELETE FROM DONVI;


---- Thêm dữ liệu --------------------------------------------------------------

-- Thêm DONVI nhưng chưa có TRGDV (tham chiếu chéo) --
-- Khoa
INSERT INTO DONVI (MADV, TENDV, LOAIDV) VALUES ('TTHC', 'Khoa Toán - Tin học', 'Khoa');
INSERT INTO DONVI (MADV, TENDV, LOAIDV) VALUES ('CNTT', 'Khoa Công nghệ Thông tin', 'Khoa');
INSERT INTO DONVI (MADV, TENDV, LOAIDV) VALUES ('VLKT', 'Khoa Vật lý - Vật lý kỹ thuật', 'Khoa');
INSERT INTO DONVI (MADV, TENDV, LOAIDV) VALUES ('HOHC', 'Khoa Hóa học', 'Khoa');
INSERT INTO DONVI (MADV, TENDV, LOAIDV) VALUES ('SHCN', 'Khoa Sinh học - Công nghệ Sinh học', 'Khoa');
INSERT INTO DONVI (MADV, TENDV, LOAIDV) VALUES ('MTRG', 'Khoa Môi trường', 'Khoa');
INSERT INTO DONVI (MADV, TENDV, LOAIDV) VALUES ('DCHT', 'Khoa Địa chất', 'Khoa');
INSERT INTO DONVI (MADV, TENDV, LOAIDV) VALUES ('KCVL', 'Khoa Khoa học và Công nghệ Vật liệu', 'Khoa');
INSERT INTO DONVI (MADV, TENDV, LOAIDV) VALUES ('DTVT', 'Khoa Điện tử - Viễn thông', 'Khoa');
INSERT INTO DONVI (MADV, TENDV, LOAIDV) VALUES ('KHLN', 'Khoa Khoa học Liên ngành', 'Khoa');
INSERT INTO DONVI (MADV, TENDV, LOAIDV) VALUES ('QLCL', 'Khoa Quản lý chất lượng', 'Khoa');
-- Phòng
INSERT INTO DONVI (MADV, TENDV, LOAIDV) VALUES ('PDT', 'Phòng Đào tạo', 'Phòng');
INSERT INTO DONVI (MADV, TENDV, LOAIDV) VALUES ('PKT', 'Phòng Khảo thí', 'Phòng');
INSERT INTO DONVI (MADV, TENDV, LOAIDV) VALUES ('TCHC', 'Phòng Tổ chức hành chính', 'Phòng');
INSERT INTO DONVI (MADV, TENDV, LOAIDV) VALUES ('CTSV', 'Phòng Công tác sinh viên', 'Phòng');


-- Thêm nhân viên --
-- Tạo sequence để tạo mã nhân viên tự động
DROP SEQUENCE SEQ_IDNHANVIEN;
CREATE SEQUENCE SEQ_IDNHANVIEN
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9999
    NOCYCLE
    CACHE 20;
-- Tạo function để format mã nhân viên
CREATE OR REPLACE FUNCTION GET_MA_NV RETURN VARCHAR2 IS
    v_manv VARCHAR2(10);
BEGIN
    v_manv := 'NV' || LPAD(SEQ_IDNHANVIEN.NEXTVAL, 4, '0');
    RETURN v_manv;
END;
/

-- Thêm 15 trưởng đơn vị (TRGDV), 11 khoa và 4 phòng
BEGIN
    FOR i IN 1..15 LOOP
        INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, NGSINH, LUONG, PHUCAP, DT, VAITRO, MADV)
        VALUES (
            GET_MA_NV(),
            'Trưởng khoa ' || i,
            CASE WHEN MOD(i, 2) = 0 THEN 'Nam' ELSE 'Nữ' END,
            TO_DATE('01/01/' || (1965 + MOD(i, 10)), 'DD/MM/YYYY'),
            50000000 + (DBMS_RANDOM.VALUE * 5000000),
            5000000 + (DBMS_RANDOM.VALUE * 1000000),
            '09' || LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE * 100000000)), 8, '0'),
            'TRGDV',
            CASE i
                WHEN 1 THEN 'TTHC'
                WHEN 2 THEN 'CNTT'
                WHEN 3 THEN 'VLKT'
                WHEN 4 THEN 'HOHC'
                WHEN 5 THEN 'SHCN'
                WHEN 6 THEN 'MTRG'
                WHEN 7 THEN 'DCHT'
                WHEN 8 THEN 'KCVL'
                WHEN 9 THEN 'DTVT'
                WHEN 10 THEN 'KHLN'
                WHEN 11 THEN 'QLCL'
                WHEN 12 THEN 'PDT'
                WHEN 13 THEN 'PKT'
                WHEN 14 THEN 'TCHC'
                WHEN 15 THEN 'CTSV'
            END
        );
    END LOOP;
END;
/

-- Thêm 200 giảng viên GV
BEGIN
    FOR i IN 1..200 LOOP
        INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, NGSINH, LUONG, PHUCAP, DT, VAITRO, MADV)
        VALUES (
            GET_MA_NV(),
            'Giảng viên ' || i,
            CASE WHEN MOD(i, 2) = 0 THEN 'Nam' ELSE 'Nữ' END,
            TO_DATE(
                LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(1, 28))), 2, '0') || '/' ||
                LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(1, 12))), 2, '0') || '/' ||
                TO_CHAR(FLOOR(1975 + DBMS_RANDOM.VALUE(0, 20))),
                'DD/MM/YYYY'
            ),
            10000000 + (DBMS_RANDOM.VALUE * 1000000),
            2000000 + (DBMS_RANDOM.VALUE * 1000000),
            '09' || LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE * 100000000)), 8, '0'),
            'GV',
            CASE FLOOR(DBMS_RANDOM.VALUE(1, 12))
                WHEN 1 THEN 'TTHC'
                WHEN 2 THEN 'CNTT'
                WHEN 3 THEN 'VLKT'
                WHEN 4 THEN 'HOHC'
                WHEN 5 THEN 'SHCN'
                WHEN 6 THEN 'MTRG'
                WHEN 7 THEN 'DCHT'
                WHEN 8 THEN 'KCVL'
                WHEN 9 THEN 'DTVT'
                WHEN 10 THEN 'KHLN'
                WHEN 11 THEN 'QLCL'
                ELSE NULL
            END
        );
    END LOOP;
END;
/


-- Thêm 20 NVPDT - Nhân viên phòng đào tạo
BEGIN
    FOR i IN 1..20 LOOP
        INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, NGSINH, LUONG, PHUCAP, DT, VAITRO, MADV)
        VALUES (
            GET_MA_NV(),
            'Nhân viên phòng đào tạo ' || i,
            CASE WHEN MOD(i, 2) = 0 THEN 'Nam' ELSE 'Nữ' END,
            TO_DATE(
                LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(1, 28))), 2, '0') || '/' ||
                LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(1, 12))), 2, '0') || '/' ||
                TO_CHAR(FLOOR(1980 + DBMS_RANDOM.VALUE(0, 20))),
                'DD/MM/YYYY'
            ),
            10000000 + (DBMS_RANDOM.VALUE * 1000000),
            1000000 + (DBMS_RANDOM.VALUE * 1000000),
            '09' || LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE * 100000000)), 8, '0'),
            'NVPDT',
            'PDT'
        );
    END LOOP;
END;
/

-- Thêm 10 NVPKT - Nhân viên phòng khảo thí
BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, NGSINH, LUONG, PHUCAP, DT, VAITRO, MADV)
        VALUES (
            GET_MA_NV(),
            'Nhân viên phòng khảo thí ' || i,
            CASE WHEN MOD(i, 2) = 0 THEN 'Nam' ELSE 'Nữ' END,
            TO_DATE(
                LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(1, 28))), 2, '0') || '/' ||
                LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(1, 12))), 2, '0') || '/' ||
                TO_CHAR(FLOOR(1980 + DBMS_RANDOM.VALUE(0, 20))),
                'DD/MM/YYYY'
            ),
            15000000 + (DBMS_RANDOM.VALUE * 1000000),
            1500000 + (DBMS_RANDOM.VALUE * 1000000),
            '09' || LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE * 100000000)), 8, '0'),
            'NVPKT',
            'PKT'
        );
    END LOOP;
END;
/

-- Thêm 15 NVTCHC - Nhân viên phòng tổ chức hành chính
BEGIN
    FOR i IN 1..15 LOOP
        INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, NGSINH, LUONG, PHUCAP, DT, VAITRO, MADV)
        VALUES (
            GET_MA_NV(),
            'Nhân viên phòng tổ chức hành chính ' || i,
            CASE WHEN MOD(i, 2) = 0 THEN 'Nam' ELSE 'Nữ' END,
            TO_DATE(
                LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(1, 28))), 2, '0') || '/' ||
                LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(1, 12))), 2, '0') || '/' ||
                TO_CHAR(FLOOR(1980 + DBMS_RANDOM.VALUE(0, 25))),
                'DD/MM/YYYY'
            ),
            12000000 + (DBMS_RANDOM.VALUE * 5000000),
            1200000 + (DBMS_RANDOM.VALUE * 1000000),
            '09' || LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE * 100000000)), 8, '0'),
            'NVTCHC',
            'TCHC'
        );
    END LOOP;
END;
/

-- Thêm 10 NVCTSV - Nhân viên cộng tác sinh viên
BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, NGSINH, LUONG, PHUCAP, DT, VAITRO, MADV)
        VALUES (
            GET_MA_NV(),
            'Nhân viên phòng cộng tác sinh viên  ' || i,
            CASE WHEN MOD(i, 2) = 0 THEN 'Nam' ELSE 'Nữ' END,
            TO_DATE(
                LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(1, 28))), 2, '0') || '/' ||
                LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(1, 12))), 2, '0') || '/' ||
                TO_CHAR(FLOOR(1980 + DBMS_RANDOM.VALUE(0, 20))),
                'DD/MM/YYYY'
            ),
            10000000 + (DBMS_RANDOM.VALUE * 2000000),
            1000000 + (DBMS_RANDOM.VALUE * 500000),
            '09' || LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE * 100000000)), 8, '0'),
            'NVCTSV',
            'CTSV'
        );
    END LOOP;
END;
/

-- Thêm 500 NVCB - Nhân viên cơ bản
BEGIN
    FOR i IN 1..500 LOOP
        INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, NGSINH, LUONG, PHUCAP, DT, VAITRO, MADV)
        VALUES (
            GET_MA_NV(),
            'Nhân viên cơ bản ' || i,
            CASE WHEN MOD(i, 2) = 0 THEN 'Nam' ELSE 'Nữ' END,
            TO_DATE(
                LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(1, 28))), 2, '0') || '/' ||
                LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(1, 12))), 2, '0') || '/' ||
                TO_CHAR(FLOOR(1985 + DBMS_RANDOM.VALUE(0, 15))),
                'DD/MM/YYYY'
            ),
            5000000 + (DBMS_RANDOM.VALUE * 500000),
            1000000 + (DBMS_RANDOM.VALUE * 100000),
            '09' || LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE * 100000000)), 8, '0'),
            'NVCB',
            CASE FLOOR(DBMS_RANDOM.VALUE(1, 16))
                WHEN 1 THEN 'TTHC'
                WHEN 2 THEN 'CNTT'
                WHEN 3 THEN 'VLKT'
                WHEN 4 THEN 'HOHC'
                WHEN 5 THEN 'SHCN'
                WHEN 6 THEN 'MTRG'
                WHEN 7 THEN 'DCHT'
                WHEN 8 THEN 'KCVL'
                WHEN 9 THEN 'DTVT'
                WHEN 10 THEN 'KHLN'
                WHEN 11 THEN 'QLCL'
                WHEN 12 THEN 'PDT'
                WHEN 13 THEN 'PKT'
                WHEN 14 THEN 'TCHC'
                WHEN 15 THEN 'CTSV'
                ELSE NULL
            END
        );
    END LOOP;
END;
/

-- Cập nhật trưởng đơn vị cho các đơn vị
BEGIN
    -- Lấy 11 MANV đầu tiên (trưởng khoa) để cập nhật cho các khoa
    FOR i IN 1..15 LOOP
        UPDATE DONVI SET TRGDV = (
            SELECT MANV FROM (
                SELECT MANV, ROWNUM AS RN FROM NHANVIEN 
                WHERE VAITRO = 'TRGDV' AND MADV IN ('TTHC', 'CNTT', 'VLKT', 'HOHC', 'SHCN', 'MTRG', 'DCHT', 'KCVL', 'DTVT', 'KHLN', 'QLCL', 'PDT', 'PKT', 'TCHC', 'CTSV')
                ORDER BY MANV
            ) WHERE RN = i
        )
        WHERE MADV = CASE i
            WHEN 1 THEN 'TTHC'
            WHEN 2 THEN 'CNTT'
            WHEN 3 THEN 'VLKT'
            WHEN 4 THEN 'HOHC'
            WHEN 5 THEN 'SHCN'
            WHEN 6 THEN 'MTRG'
            WHEN 7 THEN 'DCHT'
            WHEN 8 THEN 'KCVL'
            WHEN 9 THEN 'DTVT'
            WHEN 10 THEN 'KHLN'
            WHEN 11 THEN 'QLCL'
            WHEN 12 THEN 'PDT'
            WHEN 13 THEN 'PKT'
            WHEN 14 THEN 'TCHC'
            WHEN 15 THEN 'CTSV'
        END;
    END LOOP;
END;
/


-- Thêm 4000 sinh viên SV --
DROP SEQUENCE SEQ_IDSINHVIEN;
-- Tạo sequence mới cho sinh viên
CREATE SEQUENCE SEQ_IDSINHVIEN
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9999
    NOCYCLE
    CACHE 20;    
-- Tạo function sinh mã sinh viên
CREATE OR REPLACE FUNCTION GET_MA_SV RETURN VARCHAR2 IS
    v_masv VARCHAR2(10);
BEGIN
    v_masv := 'SV' || LPAD(SEQ_IDSINHVIEN.NEXTVAL, 4, '0');
    RETURN v_masv;
END;
/

DECLARE
    v_khoa_arr  DBMS_SQL.VARCHAR2_TABLE; -- Danh sách các khoa
    v_tinhtrang VARCHAR2(20); -- Tình trạng sv
    v_phai      CHAR(10); -- Giới tính
    v_masv      VARCHAR2(10); -- Mã sv, dùng sequence   
    v_duong VARCHAR2(3);
    v_quan VARCHAR2(3);
    v_tinh VARCHAR2(3);
    v_diachi VARCHAR2(100);
    
    -- Hàm tạo chuỗi ngẫu nhiên 3 chữ cái để random địa chỉ
    FUNCTION random_3_char RETURN VARCHAR2 IS
        v_result VARCHAR2(3);
    BEGIN
        v_result := CHR(65 + DBMS_RANDOM.VALUE(0, 26)) || 
                   CHR(65 + DBMS_RANDOM.VALUE(0, 26)) || 
                   CHR(65 + DBMS_RANDOM.VALUE(0, 26));
        RETURN v_result;
    END; 
BEGIN
    -- Danh sách mã khoa
    v_khoa_arr(1) := 'TTHC'; v_khoa_arr(2) := 'CNTT'; v_khoa_arr(3) := 'VLKT';
    v_khoa_arr(4) := 'HOHC'; v_khoa_arr(5) := 'SHCN'; v_khoa_arr(6) := 'MTRG';
    v_khoa_arr(7) := 'DCHT'; v_khoa_arr(8) := 'KCVL'; v_khoa_arr(9) := 'DTVT';
    v_khoa_arr(10) := 'KHLN'; v_khoa_arr(11) := 'QLCL';

    FOR i IN 1..4000 LOOP
        -- Gán tình trạng học vụ
        IF i <= 3900 THEN
            v_tinhtrang := 'Đang học';
        ELSIF i <= 3970 THEN
            v_tinhtrang := 'Nghỉ học';
        ELSE
            v_tinhtrang := 'Bảo lưu';
        END IF;

        -- Giới tính ngẫu nhiên
        v_phai := CASE WHEN MOD(i, 2) = 0 THEN 'Nam' ELSE 'Nữ' END;

        -- Lấy mã sinh viên từ sequence
        v_masv := GET_MA_SV;
        
        v_duong := random_3_char();
        v_quan := random_3_char();
        v_tinh := random_3_char();        
        -- Tạo địa chỉ
        v_diachi := 'Số ' || i || ' Đường ' || v_duong || ', Quận ' || v_quan || ', Tỉnh ' || v_tinh;

        INSERT INTO SINHVIEN (MASV, HOTEN, PHAI, NGSINH, DCHI, DT, KHOA, TINHTRANG)
        VALUES (
            v_masv,
            'Sinh Viên ' || i,
            v_phai,
            TO_DATE(
                LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(1, 28))), 2, '0') || '/' ||
                LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(1, 12))), 2, '0') || '/' ||
                TO_CHAR(FLOOR(2000 + DBMS_RANDOM.VALUE(0, 5))),
                'DD/MM/YYYY'
            ),
            v_diachi,
            '09' || LPAD(TO_CHAR(FLOOR(DBMS_RANDOM.VALUE * 100000000)), 8, '0'),
            v_khoa_arr(TRUNC(DBMS_RANDOM.VALUE(1, 12))),
            v_tinhtrang
        );
    END LOOP;
END;
/

-- Thêm 100 học phần --
DROP SEQUENCE SEQ_IDHOCPHAN;
-- Tạo sequence mới cho học phần
CREATE SEQUENCE SEQ_IDHOCPHAN
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9999
    NOCYCLE
    CACHE 20;    
-- Tạo function sinh mã sinh viên
CREATE OR REPLACE FUNCTION GET_MA_HP RETURN VARCHAR2 IS
    v_mahp VARCHAR2(10);
BEGIN
    v_mahp := 'HP' || LPAD(SEQ_IDHOCPHAN.NEXTVAL, 4, '0');
    RETURN v_mahp;
END;
/
DECLARE
    v_khoa_arr DBMS_SQL.VARCHAR2_TABLE;
    v_mahp VARCHAR2(10);
    v_tenhp VARCHAR2(50);
    v_sotc NUMBER;
    v_stlt NUMBER;
    v_stth NUMBER;
    v_madv VARCHAR2(10);
BEGIN
    -- Danh sách mã khoa
    v_khoa_arr(1) := 'TTHC'; v_khoa_arr(2) := 'CNTT'; v_khoa_arr(3) := 'VLKT';
    v_khoa_arr(4) := 'HOHC'; v_khoa_arr(5) := 'SHCN'; v_khoa_arr(6) := 'MTRG';
    v_khoa_arr(7) := 'DCHT'; v_khoa_arr(8) := 'KCVL'; v_khoa_arr(9) := 'DTVT';
    v_khoa_arr(10) := 'KHLN'; v_khoa_arr(11) := 'QLCL';

    FOR i IN 1..100 LOOP
        -- Sinh mã học phần
        v_mahp := GET_MA_HP;

        -- Sinh tên học phần
        v_tenhp := 'Học phần số ' || i;

        -- Tín chỉ ngẫu nhiên: phổ biến là 2, 3, 4; đôi khi 6 hoặc 10
        v_sotc := CASE
                    WHEN i > 99 THEN 10 -- 1 khóa luận
                    WHEN i > 98 THEN 6  -- 1 đồ án
                    ELSE TRUNC(DBMS_RANDOM.VALUE(2, 5)) -- còn lại là 2–4
                 END;

        -- Nếu là khóa luận/đồ án thì không có lý thuyết
        IF v_sotc IN (6, 10) THEN
            v_stlt := 0;
            v_stth := v_sotc * 30;
        ELSE
            CASE v_sotc
                WHEN 2 THEN
                    v_stlt := 30;
                    v_stth := 0;
                WHEN 3 THEN
                    v_stlt := 15;
                    v_stth := 60;
                WHEN 4 THEN
                    v_stlt := 45;
                    v_stth := 30;
                ELSE
                    v_stlt := v_sotc * 15;
                    v_stth := v_sotc * 30;
            END CASE;
        END IF;

        -- MADV ngẫu nhiên từ 11 khoa
        v_madv := v_khoa_arr(TRUNC(DBMS_RANDOM.VALUE(1, 12)));

        -- Thêm vào bảng
        INSERT INTO HOCPHAN (MAHP, TENHP, SOTC, STLT, STTH, MADV)
        VALUES (v_mahp, v_tenhp, v_sotc, v_stlt, v_stth, v_madv);
    END LOOP;
END;
/


-- Thêm mở môn, kì 1 mở 80, kfi 2 mở 80, kì 3 mở 70 --
-- Xóa sequence nếu đã tồn tại
DROP SEQUENCE SEQ_IDMOMON;
-- Tạo sequence mới cho mã mở môn
CREATE SEQUENCE SEQ_IDMOMON
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9999
    NOCYCLE
    CACHE 20;
-- Tạo function để sinh mã mở môn
CREATE OR REPLACE FUNCTION GET_MA_MM RETURN VARCHAR2 IS
    v_mamm VARCHAR2(10);
BEGIN
    v_mamm := 'MM' || LPAD(SEQ_IDMOMON.NEXTVAL, 4, '0');
    RETURN v_mamm;
END;
/

DECLARE
    TYPE t_mahp_tab IS TABLE OF VARCHAR2(10);
    TYPE t_magv_tab IS TABLE OF VARCHAR2(10);

    v_mahp_tab t_mahp_tab;
    v_magv_tab t_magv_tab;

    v_mamm VARCHAR2(10);
    v_mahp VARCHAR2(10);
    v_magv VARCHAR2(10);
    v_hk NUMBER(1);
    v_nam NUMBER(4);
    v_count NUMBER := 0;
    v_total NUMBER := 230;
    v_used_mahp_tab t_mahp_tab := t_mahp_tab();
BEGIN
    -- Lấy danh sách mã học phần
    SELECT MAHP BULK COLLECT INTO v_mahp_tab FROM HOCPHAN;

    -- Lấy danh sách mã giảng viên
    SELECT MANV BULK COLLECT INTO v_magv_tab FROM NHANVIEN WHERE VAITRO = 'GV';

    -- Học kỳ 1 năm 2023: 80 học phần
    FOR i IN 1..80 LOOP
        v_mamm := GET_MA_MM;
        v_mahp := v_mahp_tab(DBMS_RANDOM.VALUE(1, v_mahp_tab.COUNT));
        v_magv := v_magv_tab(DBMS_RANDOM.VALUE(1, v_magv_tab.COUNT));
        v_hk := 1;
        v_nam := 2023;

        INSERT INTO MOMON (MAMM, MAHP, MAGV, HK, NAM)
        VALUES (v_mamm, v_mahp, v_magv, v_hk, v_nam);
    END LOOP;

    -- Học kỳ 2 năm 2024: 80 học phần
    FOR i IN 81..160 LOOP
        v_mamm := 'MM' || LPAD(i, 4, '0');
        v_mahp := v_mahp_tab(DBMS_RANDOM.VALUE(1, v_mahp_tab.COUNT));
        v_magv := v_magv_tab(DBMS_RANDOM.VALUE(1, v_magv_tab.COUNT));
        v_hk := 2;
        v_nam := 2024;

        INSERT INTO MOMON (MAMM, MAHP, MAGV, HK, NAM)
        VALUES (v_mamm, v_mahp, v_magv, v_hk, v_nam);
    END LOOP;

    -- Học kỳ 3 năm 2024: 70 học phần, bao gồm HP0099 và HP0100
    -- Thêm HP0099
    v_mamm := 'MM' || LPAD(161, 4, '0');
    v_magv := v_magv_tab(DBMS_RANDOM.VALUE(1, v_magv_tab.COUNT));
    INSERT INTO MOMON (MAMM, MAHP, MAGV, HK, NAM)
    VALUES (v_mamm, 'HP0099', v_magv, 3, 2024);

    -- Thêm HP0100
    v_mamm := 'MM' || LPAD(162, 4, '0');
    v_magv := v_magv_tab(DBMS_RANDOM.VALUE(1, v_magv_tab.COUNT));
    INSERT INTO MOMON (MAMM, MAHP, MAGV, HK, NAM)
    VALUES (v_mamm, 'HP0100', v_magv, 3, 2024);

    -- Thêm 68 học phần còn lại
    FOR i IN 163..230 LOOP
        v_mamm := 'MM' || LPAD(i, 4, '0');
        v_mahp := v_mahp_tab(DBMS_RANDOM.VALUE(1, v_mahp_tab.COUNT));
        v_magv := v_magv_tab(DBMS_RANDOM.VALUE(1, v_magv_tab.COUNT));
        v_hk := 3;
        v_nam := 2024;

        INSERT INTO MOMON (MAMM, MAHP, MAGV, HK, NAM)
        VALUES (v_mamm, v_mahp, v_magv, v_hk, v_nam);
    END LOOP;
END;
/


-- Thêm đăng kí cho mỗi sinh viên, kì 1 5 môn, kì 2 4 môn, kì 3 4 môn --
DECLARE
    CURSOR c_sinhvien IS
        SELECT MASV, KHOA FROM SINHVIEN /*WHERE TINHTRANG = 'Đang học'*/;

    TYPE t_mamon_tbl IS TABLE OF MOMON.MAMM%TYPE INDEX BY PLS_INTEGER;
    v_mon_hk1 t_mamon_tbl;
    v_mon_hk2 t_mamon_tbl;
    v_mon_hk3 t_mamon_tbl;

    v_count INTEGER;
    v_index INTEGER;
    v_diemth NUMBER(5,2);
    v_diemqt NUMBER(5,2);
    v_diemck NUMBER(5,2);
    v_diemtk NUMBER(5,2);

BEGIN
    -- Duyệt từng sinh viên
    FOR sv IN c_sinhvien LOOP
        -- HK1: chọn 5 môn của khoa sinh viên
        SELECT MAMM BULK COLLECT INTO v_mon_hk1
        FROM MOMON M
        JOIN HOCPHAN H ON M.MAHP = H.MAHP
        WHERE H.MADV = sv.KHOA AND M.HK = 1 AND M.NAM = 2023;

        v_count := v_mon_hk1.COUNT;
        IF v_count >= 5 THEN
            FOR i IN 1..5 LOOP
                v_index := TRUNC(DBMS_RANDOM.VALUE(1, v_count+1));
                v_diemth := ROUND(DBMS_RANDOM.VALUE(1, 10), 2);
                v_diemqt := ROUND(DBMS_RANDOM.VALUE(1, 10), 2);
                v_diemck := ROUND(DBMS_RANDOM.VALUE(0, 10), 2);
                v_diemtk := ROUND(v_diemth * 0.3 + v_diemqt * 0.2 + v_diemck * 0.5, 2);

                BEGIN
                    INSERT INTO DANGKY VALUES (sv.MASV, v_mon_hk1(v_index), v_diemth, v_diemqt, v_diemck, v_diemtk);
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN NULL;
                END;
            END LOOP;
        END IF;

        -- HK2: chọn 4 môn
        SELECT MAMM BULK COLLECT INTO v_mon_hk2
        FROM MOMON M
        JOIN HOCPHAN H ON M.MAHP = H.MAHP
        WHERE H.MADV = sv.KHOA AND M.HK = 2 AND M.NAM = 2024;

        v_count := v_mon_hk2.COUNT;
        IF v_count >= 4 THEN
            FOR i IN 1..4 LOOP
                v_index := TRUNC(DBMS_RANDOM.VALUE(1, v_count+1));
                v_diemth := ROUND(DBMS_RANDOM.VALUE(1, 10), 2);
                v_diemqt := ROUND(DBMS_RANDOM.VALUE(1, 10), 2);
                v_diemck := ROUND(DBMS_RANDOM.VALUE(0, 10), 2);
                v_diemtk := ROUND(v_diemth * 0.3 + v_diemqt * 0.2 + v_diemck * 0.5, 2);

                BEGIN
                    INSERT INTO DANGKY VALUES (sv.MASV, v_mon_hk2(v_index), v_diemth, v_diemqt, v_diemck, v_diemtk);
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN NULL;
                END;
            END LOOP;
        END IF;

        -- HK3: chọn 4 môn
        SELECT MAMM BULK COLLECT INTO v_mon_hk3
        FROM MOMON M
        JOIN HOCPHAN H ON M.MAHP = H.MAHP
        WHERE H.MADV = sv.KHOA AND M.HK = 3 AND M.NAM = 2024;

        v_count := v_mon_hk3.COUNT;
        IF v_count >= 4 THEN
            FOR i IN 1..4 LOOP
                v_index := TRUNC(DBMS_RANDOM.VALUE(1, v_count+1));
                v_diemth := ROUND(DBMS_RANDOM.VALUE(1, 10), 2);
                v_diemqt := ROUND(DBMS_RANDOM.VALUE(1, 10), 2);
                v_diemck := ROUND(DBMS_RANDOM.VALUE(0, 10), 2);
                v_diemtk := ROUND(v_diemth * 0.3 + v_diemqt * 0.2 + v_diemck * 0.5, 2);

                BEGIN
                    INSERT INTO DANGKY VALUES (sv.MASV, v_mon_hk3(v_index), v_diemth, v_diemqt, v_diemck, v_diemtk);
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN NULL;
                END;
            END LOOP;
        END IF;
    END LOOP;
END;
/
COMMIT;

--SELECT distinct HK, NAM FROM user_admin.MOMON;
UPDATE user_admin.MOMON SET NAM = NAM + 1;
ALTER TABLE user_admin.MOMON ADD NAM_NEW VARCHAR2(10);
UPDATE user_admin.MOMON
SET NAM_NEW =
CASE
    WHEN HK = 1 THEN TO_CHAR(NAM) || '-' || TO_CHAR(NAM + 1)
    WHEN HK IN (2, 3) THEN TO_CHAR(NAM - 1) || '-' || TO_CHAR(NAM)
END;
ALTER TABLE user_admin.MOMON DROP COLUMN NAM;
ALTER TABLE user_admin.MOMON RENAME COLUMN NAM_NEW TO NAM;

--------------------------------------------------------------------------------
--SELECT * FROM DANGKY;
--SELECT * FROM MOMON;
--SELECT * FROM HOCPHAN;
--SELECT * FROM NHANVIEN;
--SELECT * FROM SINHVIEN;
--SELECT * FROM DONVI;

--SELECT * FROM SYS.DANGKY;
--SELECT * FROM SYS.MOMON;
--SELECT * FROM SYS.HOCPHAN;
--SELECT * FROM SYS.NHANVIEN;
--SELECT * FROM SYS.SINHVIEN;
--SELECT * FROM SYS.DONVI;

--SELECT * FROM user_admin.DANGKY;
--SELECT * FROM user_admin.MOMON;
--SELECT distinct HK, NAM FROM user_admin.MOMON;
--SELECT * FROM user_admin.HOCPHAN;
--SELECT * FROM user_admin.NHANVIEN;
--SELECT * FROM user_admin.SINHVIEN;
--SELECT * FROM user_admin.DONVI;
--------------------------------------------------------------------------------
-- Tạo role và tài khoản -------------------------------------------------------

-- Tạo role --
BEGIN
  FOR role_name IN (
    SELECT ROLE_NAME FROM (
      SELECT 'SV' AS ROLE_NAME FROM DUAL UNION ALL
      SELECT 'NVCB' FROM DUAL UNION ALL
      SELECT 'GV' FROM DUAL UNION ALL
      SELECT 'NVPDT' FROM DUAL UNION ALL
      SELECT 'NVPKT' FROM DUAL UNION ALL
      SELECT 'NVTCHC' FROM DUAL UNION ALL
      SELECT 'NVCTSV' FROM DUAL UNION ALL
      SELECT 'TRGDV' FROM DUAL
    )
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'DROP ROLE ' || role_name.ROLE_NAME;
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE != -01919 THEN -- ORA-01919: role does not exist
          DBMS_OUTPUT.PUT_LINE('Lỗi DROP ROLE ' || role_name.ROLE_NAME || ': ' || SQLERRM);
        END IF;
    END;

    BEGIN
      EXECUTE IMMEDIATE 'CREATE ROLE ' || role_name.ROLE_NAME;
      EXECUTE IMMEDIATE 'GRANT CONNECT TO ' || role_name.ROLE_NAME;
      EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO ' || role_name.ROLE_NAME;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi tạo ROLE ' || role_name.ROLE_NAME || ': ' || SQLERRM);
    END;
  END LOOP;
END;
/

-- Tạo các tài khoản SINHVIEN --
BEGIN
  FOR r IN (SELECT MASV FROM SINHVIEN) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'DROP USER ' || r.MASV || ' CASCADE';
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE != -01918 THEN
          DBMS_OUTPUT.PUT_LINE('Lỗi DROP sinh viên: ' || r.MASV || ' - ' || SQLERRM);
        END IF;
    END;

    BEGIN
      EXECUTE IMMEDIATE 'CREATE USER ' || r.MASV || ' IDENTIFIED BY ' || r.MASV;
      EXECUTE IMMEDIATE 'GRANT SV TO ' || r.MASV;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi tạo sinh viên: ' || r.MASV || ' - ' || SQLERRM);
    END;
  END LOOP;
END;
/


-- Tạo các tài khoản NHANVIEN --
BEGIN
  FOR r IN (SELECT MANV, VAITRO FROM NHANVIEN) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'DROP USER ' || r.MANV || ' CASCADE';
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE != -01918 THEN
          DBMS_OUTPUT.PUT_LINE('Lỗi DROP nhân viên: ' || r.MANV || ' - ' || SQLERRM);
        END IF;
    END;

    BEGIN
      EXECUTE IMMEDIATE 'CREATE USER ' || r.MANV || ' IDENTIFIED BY ' || r.MANV;
      EXECUTE IMMEDIATE 'GRANT ' || r.VAITRO || ' TO ' || r.MANV;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi tạo nhân viên: ' || r.MANV || ' - ' || SQLERRM);
    END;
  END LOOP;
END;
/

--SELECT * FROM DBA_ROLES;
--SELECT * FROM DBA_USERS;
-------------------------------------------------------------------------------
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

-- Tạo mới, xóa, sửa role. Tạo mới, xóa, sửa user.
-- Kiểm tra role tồn tại
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

-- Tạo Role
CREATE OR REPLACE PROCEDURE create_role(role_name IN VARCHAR2) AS
BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE ' || role_name;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error creating role: ' || SQLERRM);
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

-- Xóa User
CREATE OR REPLACE PROCEDURE drop_user(username IN VARCHAR2) AS
BEGIN
    EXECUTE IMMEDIATE 'DROP USER ' || username || ' CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error dropping user: ' || SQLERRM);
END;
/

-- Thu hồi full quyền của user
CREATE OR REPLACE PROCEDURE revoke_priv_from_user(
    p_username     IN VARCHAR2,
    p_privilege    IN VARCHAR2,
    p_object_name  IN VARCHAR2
) AS
    v_sql VARCHAR2(1000);
BEGIN
    v_sql := 'REVOKE ' || p_privilege || ' ON ' || p_object_name || ' FROM ' || p_username;
    EXECUTE IMMEDIATE v_sql;
END;
/

-- Thu hồi full quyền của role
CREATE OR REPLACE PROCEDURE revoke_priv_from_role (
    p_rolename     IN VARCHAR2,
    p_privilege    IN VARCHAR2,
    p_object_name  IN VARCHAR2
) AS
    v_sql VARCHAR2(1000);
BEGIN
    v_sql := 'REVOKE ' || p_privilege || ' ON ' || p_object_name || ' FROM ' || p_rolename;
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

-- Cấp quyền cho role
-- GRANT quyền hệ thống hoặc đối tượng cho ROLE
CREATE OR REPLACE PROCEDURE grant_priv_to_role (
    p_role IN VARCHAR2,
    p_priv IN VARCHAR2,
    p_type IN VARCHAR2,
    p_obj_name IN VARCHAR2 DEFAULT NULL,
    p_column IN VARCHAR2 DEFAULT NULL,
    p_with_grant IN BOOLEAN DEFAULT FALSE
)
IS
    v_sql VARCHAR2(1000);
BEGIN
    IF p_type = 'System' THEN
        v_sql := 'GRANT ' || p_priv || ' TO ' || p_role;
    ELSIF p_type = 'Object' THEN
        IF p_column IS NOT NULL THEN
            v_sql := 'GRANT ' || p_priv || '(' || p_column || ') ON ' || p_obj_name || ' TO ' || p_role;
        ELSE
            v_sql := 'GRANT ' || p_priv || ' ON ' || p_obj_name || ' TO ' || p_role;
        END IF;
    END IF;

    IF p_with_grant THEN
        v_sql := v_sql || ' WITH GRANT OPTION';
    END IF;

    EXECUTE IMMEDIATE v_sql;
END;
/

-- Cấp quyền cho user
CREATE OR REPLACE PROCEDURE grant_priv_to_user (
    p_username         IN VARCHAR2,
    p_privilege        IN VARCHAR2,
    p_object_name      IN VARCHAR2,
    p_column_name      IN VARCHAR2 DEFAULT NULL,
    p_with_grant       IN BOOLEAN DEFAULT FALSE
) AS
    v_sql VARCHAR2(1000);
BEGIN
    -- Quyền select, update phải cho phép phân quyền tính đến mức cột;
    -- quyền insert, delete thì không.
    IF p_column_name IS NOT NULL AND p_privilege IN ('SELECT', 'UPDATE') THEN
        v_sql := 'GRANT ' || p_privilege || '(' || p_column_name || ') ON ' || p_object_name || ' TO ' || p_username;
    ELSE
        v_sql := 'GRANT ' || p_privilege || ' ON ' || p_object_name || ' TO ' || p_username;
    END IF;

    -- With grant option
    IF p_with_grant THEN
        v_sql := v_sql || ' WITH GRANT OPTION';
    END IF;

    EXECUTE IMMEDIATE v_sql;
END;
/

-- Cấp role cho user
CREATE OR REPLACE PROCEDURE grant_role_to_user (
    p_username  IN VARCHAR2,
    p_rolename  IN VARCHAR2
) AS
BEGIN
    EXECUTE IMMEDIATE 'GRANT ' || p_rolename || ' TO ' || p_username;
END;
/
-- YC1
-- Câu 1: RBAC NHANVIEN

-- Tạo view --

-- Tạo view NHANVIEN NVCB
-- NVCB xem đc dòng dữ liệu chính mình và có thể sửa SDT chính mình
CREATE OR REPLACE VIEW V_NHANVIEN_NVCB AS
SELECT MANV, HOTEN, PHAI, NGSINH, LUONG, PHUCAP, DT, VAITRO, MADV
FROM user_admin.NHANVIEN
WHERE MANV = SYS_CONTEXT('USERENV', 'SESSION_USER');

-- Các nv còn lại có full quyền của NVCB
-- View NHANVIEN TRGDV
-- TRGDV đc xem các dòng của các nv thuộc đơn vị mình làm trưởng trừ LUONG và PHUCAP
CREATE OR REPLACE VIEW V_NHANVIEN_TRGDV AS
SELECT MANV, HOTEN, PHAI, NGSINH, DT, VAITRO, MADV
FROM user_admin.NHANVIEN
WHERE MADV = (
    SELECT MADV FROM DONVI WHERE TRGDV = SYS_CONTEXT('USERENV', 'SESSION_USER')
);

-- View NHANVIEN NVTCHC
-- NVTCHC đc S/I/U/D full trên NHANVIEN
CREATE OR REPLACE VIEW V_NHANVIEN_NVTCHC AS
SELECT * FROM user_admin.NHANVIEN;

-- Cấp quyền cho role --
-- Role NVCB
GRANT SELECT, UPDATE (DT) ON V_NHANVIEN_NVCB TO NVCB;

-- Role TRGDV
GRANT SELECT ON V_NHANVIEN_TRGDV TO TRGDV;

-- Role TCHC
GRANT SELECT, INSERT, UPDATE, DELETE ON V_NHANVIEN_NVTCHC TO NVTCHC;

GRANT NVCB TO NVTCHC;

GRANT NVCB TO TRGDV;

-- Cấp role cho NHANVIEN có sẵn trong hệ thống --
BEGIN
    FOR rec IN (
        SELECT MANV, VAITRO FROM user_admin.NHANVIEN
        WHERE MANV IS NOT NULL
    ) LOOP
        BEGIN
            -- Cấp role NVCB cho tất cả nhân viên
            EXECUTE IMMEDIATE 'GRANT NVCB TO ' || rec.MANV;

            -- Cấp thêm role tương ứng theo giá trị cột VAITRO của nhân viên
            IF rec.VAITRO IS NOT NULL AND rec.VAITRO != 'NVCB' THEN
                EXECUTE IMMEDIATE 'GRANT ' || rec.VAITRO || ' TO ' || rec.MANV;
            END IF;

        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Lỗi khi gán role cho ' || rec.MANV || ': ' || SQLERRM);
        END;
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE proc_xet_role_nv(
    p_manv    IN  VARCHAR2,
    p_cursor  OUT SYS_REFCURSOR
)
IS
    v_role  VARCHAR2(10);
BEGIN
    -- Lấy vai trò của nhân viên
    SELECT VAITRO INTO v_role
    FROM user_admin.NHANVIEN
    WHERE MANV = p_manv;

    -- Mở cursor tương ứng với role
    IF v_role = 'NVCB' THEN
        OPEN p_cursor FOR
        SELECT * FROM V_NHANVIEN_NVCB WHERE MANV = p_manv;
    ELSIF v_role = 'TRGDV' THEN
        OPEN p_cursor FOR
        SELECT * FROM V_NHANVIEN_TRGDV WHERE MADV = (
            SELECT MADV FROM user_admin.DONVI WHERE TRGDV = p_manv
        );
    ELSIF v_role = 'NVTCHC' THEN
        OPEN p_cursor FOR
        SELECT * FROM V_NHANVIEN_NVTCHC;
    ELSE
        -- Nếu role không hợp lệ
        RAISE_APPLICATION_ERROR(-20001, 'Vai trò không hợp lệ: ' || v_role);
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Không tìm thấy nhân viên với mã: ' || p_manv);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'Lỗi xử lý: ' || SQLERRM);
END;
/

ALTER PROCEDURE proc_xet_role_nv COMPILE;

-- Thêm nhân viên
CREATE OR REPLACE PROCEDURE sp_insert_nhanvien (
    p_manv    OUT VARCHAR2,
    p_hoten   IN VARCHAR2,
    p_phai    IN CHAR,
    p_ngsinh  IN DATE,
    p_luong   IN NUMBER,
    p_phucap  IN NUMBER,
    p_dt      IN VARCHAR2,
    p_vaitro  IN VARCHAR2,
    p_madv    IN VARCHAR2
) AS
BEGIN
    p_manv := GET_MA_NV();
    INSERT INTO user_admin.NHANVIEN (MANV, HOTEN, PHAI, NGSINH, LUONG, PHUCAP, DT, VAITRO, MADV)
    VALUES (p_manv, p_hoten, p_phai, p_ngsinh, p_luong, p_phucap, p_dt, p_vaitro, p_madv);
END;
/

-- Cập nhật nhân viên
CREATE OR REPLACE PROCEDURE sp_update_nhanvien (
    p_manv    IN VARCHAR2,
    p_hoten   IN VARCHAR2,
    p_phai    IN CHAR,
    p_ngsinh  IN DATE,
    p_luong   IN NUMBER,
    p_phucap  IN NUMBER,
    p_dt      IN VARCHAR2,
    p_vaitro  IN VARCHAR2,
    p_madv    IN VARCHAR2,
    p_rows_updated OUT NUMBER  -- Thêm output parameter
) AS
BEGIN
    -- Kiểm tra tồn tại nhân viên trước khi update
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count 
        FROM user_admin.NHANVIEN 
        WHERE MANV = p_manv;
        
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Không tìm thấy nhân viên với mã: ' || p_manv);
        END IF;
    END;

    -- Thực hiện update
    UPDATE user_admin.NHANVIEN
    SET HOTEN = p_hoten,
        PHAI = p_phai,
        NGSINH = p_ngsinh,
        LUONG = p_luong,
        PHUCAP = p_phucap,
        DT = p_dt,
        VAITRO = p_vaitro,
        MADV = p_madv
    WHERE MANV = p_manv;
    
    -- Trả về số dòng được cập nhật
    p_rows_updated := SQL%ROWCOUNT;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;  -- Đẩy lỗi về client
END;
/

-- Xoá nhân viên
CREATE OR REPLACE PROCEDURE sp_delete_nhanvien (
    p_manv IN VARCHAR2
) AS
BEGIN
    DELETE FROM user_admin.NHANVIEN WHERE MANV = p_manv;
END;
/

ALTER PROCEDURE sp_insert_nhanvien COMPILE;
ALTER PROCEDURE sp_update_nhanvien COMPILE;
ALTER PROCEDURE sp_delete_nhanvien COMPILE;

GRANT EXECUTE ON user_admin.proc_xet_role_nv TO NVCB;
GRANT EXECUTE ON user_admin.proc_xet_role_nv TO TRGDV;
GRANT EXECUTE ON user_admin.proc_xet_role_nv TO NVTCHC;
GRANT EXECUTE ON user_admin.sp_insert_nhanvien TO NVTCHC;
GRANT EXECUTE ON user_admin.sp_update_nhanvien TO NVTCHC;
GRANT EXECUTE ON user_admin.sp_delete_nhanvien TO NVTCHC;
GRANT SELECT ON DONVI TO NVTCHC;
GRANT EXECUTE ON user_admin.get_application_roles TO NVTCHC;

Commit;

--------------------------------------------------------------------------------
-- YC1
-- Câu 2: RBAC MOMON

-- Tạo view --

-- Tạo view MOMON GV
-- GV select được dòng phân công giảng dạy liên quan chính mình
CREATE OR REPLACE VIEW V_MOMON_GV AS
SELECT MAMM, MAHP, MAGV, HK, NAM
FROM user_admin.MOMON
WHERE MAGV = SYS_CONTEXT('USERENV', 'SESSION_USER');

-- NVPDT được select, insert, update, delete trong MOMON liên quan học kỳ hiện tại
CREATE OR REPLACE VIEW V_MOMON_NVPDT AS
SELECT MAMM, MAHP, MAGV, HK, NAM
FROM user_admin.MOMON
WHERE 
(
    (TO_CHAR(SYSDATE, 'MMDD') BETWEEN '0901' AND '1231' 
        AND HK = 1 
        AND SUBSTR(NAM, 1, 4) = TO_CHAR(EXTRACT(YEAR FROM SYSDATE))
    )
    OR
    (TO_CHAR(SYSDATE, 'MMDD') BETWEEN '0101' AND '0430' 
        AND HK = 2 
        AND SUBSTR(NAM, -4) = TO_CHAR(EXTRACT(YEAR FROM SYSDATE))
    )
    OR
    (TO_CHAR(SYSDATE, 'MMDD') BETWEEN '0501' AND '0831' 
        AND HK = 3 
        AND SUBSTR(NAM, -4) = TO_CHAR(EXTRACT(YEAR FROM SYSDATE))
    )
)
WITH CHECK OPTION CONSTRAINT V_MOMON_NVPDT_CHECK;

-- TRGDV được select các dòng phân công giảng dạy của các giảng viên thuộc đơn vị mình làm trưởng
CREATE OR REPLACE VIEW V_MOMON_TRGDV AS
SELECT MAMM, MAHP, MAGV, HK, NAM
FROM user_admin.MOMON
WHERE MAGV IN (
    SELECT nv.MANV
    FROM NHANVIEN nv
    JOIN DONVI dnv ON nv.MADV = dnv.MADV
    WHERE dnv.TRGDV = SYS_CONTEXT('USERENV', 'SESSION_USER')
);

-- SV được select các dòng phân MOMON liên quan các dòng mở các học phần thuộc quyền phụ trách chuyên môn bởi Khoa của SV 
CREATE OR REPLACE VIEW V_MOMON_SV AS
SELECT MAMM, MAHP, MAGV, HK, NAM
FROM user_admin.MOMON
WHERE MAHP IN (
    SELECT hp.MAHP
    FROM HOCPHAN hp
    JOIN SINHVIEN sv ON hp.MADV = sv.KHOA
    WHERE sv.MASV = SYS_CONTEXT('USERENV', 'SESSION_USER')
);

-- Cấp quyền
-- Role GV
GRANT SELECT ON V_MOMON_GV TO GV;
/*
select * from user_admin.V_MOMON_GV;
*/

-- Role NVPDT
GRANT SELECT, INSERT, UPDATE, DELETE ON V_MOMON_NVPDT TO NVPDT;
/*
select * from user_admin.V_MOMON_NVPDT;
INSERT INTO user_admin.V_MOMON_NVPDT (MAMM, MAHP, MAGV, HK, NAM) VALUES ('MM0231', 'HP0001', 'NV0040', 2, '2024-2025');
COMMIT;
DELETE FROM user_admin.V_MOMON_NVPDT WHERE MAMM = 'MM0231';
COMMIT;
*/

-- Role TRGDV
GRANT SELECT ON V_MOMON_TRGDV TO TRGDV;
/*
select * from user_admin.V_MOMON_TRGDV;
*/

-- Role SV
GRANT SELECT ON V_MOMON_SV TO SV;
/*
select * from user_admin.V_MOMON_SV;
*/
--------------------------------------------------------------------------------
-- YC1
-- Câu 3: VPD SINHVIEN

-- Sinh viên có thể xem dữ liệu chính mình, đc sửa DCHI, SDT của chính mình
-- Ng có role NVCTSV có thể I/U/D trên SINHVIEN.
-- Trường TINHTRANG của bảng này mang GT NULL
-- cho đến khi có ng dùng có role NVPDT cập nhật thành giá trị mới.
-- GV đc xem ds sinh viên thuọc đơn vị (khoa) mà giảng viên trực thuộc

DROP FUNCTION select_sinhvien;
-- Xoá Policy Update
BEGIN 
    DBMS_RLS.drop_policy (
        object_schema => 'user_admin',
        object_name => 'SINHVIEN',
        policy_name => 'SINHVIEN_Control_Select'
    );
END;
/

CREATE OR REPLACE FUNCTION select_sinhvien (
    schema_name VARCHAR2,
    table_name VARCHAR2
)
RETURN VARCHAR2
AS
    v_user   VARCHAR2(50);
    v_role   VARCHAR2(20);
    v_manv   VARCHAR2(10);
    v_khoa   VARCHAR2(10);
BEGIN
    -- Lấy tên người dùng hiện tại
    v_user := SYS_CONTEXT('USERENV', 'SESSION_USER');

    -- Truy ngược vai trò và thông tin người dùng
    BEGIN
        SELECT VAITRO, MANV, MADV INTO v_role, v_manv, v_khoa
        FROM user_admin.NHANVIEN
        WHERE MANV = v_user;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_role := 'SV';
    END;

    -- Sinh viên có thể xem dữ liệu chính mình
    IF v_role = 'SV' THEN
        RETURN 'MASV = ''' || v_user || '''';
    -- GV đc xem ds sinh viên thuọc đơn vị (khoa) mà giảng viên trực thuộc
    ELSIF v_role = 'GV' THEN
        RETURN 'KHOA = (SELECT MADV FROM user_admin.NHANVIEN WHERE MANV = ''' || v_user || ''')';
    -- Ng có role NVCTSV có thể S/I/U/D trên SINHVIEN nhưng trừ TINHTRANG
    ELSIF v_role = 'NVCTSV' THEN
        RETURN '1 = 1'; -- full access, bị hạn chế ở trigger
    ELSIF v_role = 'NVPDT' THEN
        RETURN '1 = 1'; -- NVPD có thể update TINHTRANG
    ELSE
        RETURN '1 = 0'; -- không được xem gì
    END IF;
END;
/

-- Đăng ký policy
BEGIN
    DBMS_RLS.ADD_POLICY (
        object_schema   => 'USER_ADMIN',
        object_name     => 'SINHVIEN',
        policy_name     => 'SINHVIEN_Control_Select',
        function_schema => 'USER_ADMIN',
        policy_function => 'select_sinhvien',
        statement_types => 'SELECT, INSERT, UPDATE, DELETE',
        update_check    => TRUE
    );
END;
/


REATE OR REPLACE FUNCTION get_vaitro RETURN VARCHAR2
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

-- Trigger cho trường TINHTRANG để chỉ ng dùng có role NVPDT cập nhật thành giá trị mới.
CREATE OR REPLACE TRIGGER trg_restrict_tinhtrang
BEFORE UPDATE ON user_admin.SINHVIEN
FOR EACH ROW
DECLARE
    v_role VARCHAR2(20);
BEGIN
    v_role := get_vaitro;

    IF :OLD.TINHTRANG IS NOT NULL AND :NEW.TINHTRANG != :OLD.TINHTRANG AND :NEW.TINHTRANG IS NOT NULL THEN
        IF v_role != 'NVPDT' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Chỉ NVPDT được cập nhật tình trạng học vụ');
        END IF;
    END IF;
END;
/

-- Trigger để sinh viên chỉ đc sửa DCHI, SDT của chính mình
CREATE OR REPLACE TRIGGER trg_sv_update
BEFORE UPDATE ON user_admin.SINHVIEN
FOR EACH ROW
DECLARE
    v_user VARCHAR2(30);
BEGIN
    v_user := SYS_CONTEXT('USERENV', 'SESSION_USER');

    IF v_user = :OLD.MASV THEN
        IF :NEW.DCHI != :OLD.DCHI OR :NEW.DT != :OLD.DT THEN
            NULL; -- Cho phép
        ELSE
            IF :NEW.HOTEN != :OLD.HOTEN OR
               :NEW.PHAI != :OLD.PHAI OR
               :NEW.NGSINH != :OLD.NGSINH OR
               :NEW.KHOA != :OLD.KHOA OR
               :NEW.TINHTRANG != :OLD.TINHTRANG THEN
                RAISE_APPLICATION_ERROR(-20002, 'Sinh viên chỉ được cập nhật địa chỉ và số điện thoại của chính mình');
            END IF;
        END IF;
    END IF;
END;
/

-- Cho SV có thể SELECT bảng SINHVIEN (bản thân mình, theo VPD)
GRANT SELECT, UPDATE(DCHI, DT) ON user_admin.SINHVIEN TO SV;

-- Cho GV có thể xem danh sách SV trong khoa
GRANT SELECT ON user_admin.SINHVIEN TO GV;
GRANT SELECT ON user_admin.NHANVIEN TO GV;

-- Cho NVCTSV có thể toàn quyền (được kiểm soát bằng trigger)
GRANT SELECT, INSERT, UPDATE, DELETE ON user_admin.SINHVIEN TO NVCTSV;

-- Cho NVPDT có quyền cập nhật TINHTRANG
GRANT SELECT, UPDATE (TINHTRANG) ON user_admin.SINHVIEN TO NVPDT;
--------------------------------------------------------------------------------
-- YC1
-- Câu 4: VPD DANGKY
-- chạy bằng user_admin
--alter session set container=xepdb1;
-- SV có thể xem dữ liệu chính mình
-- SV I/U/D liên quan chính mình trong 14 ngày đầu HK,  DIEM__ là NULL
-- NVPDT S/I/U/D trên DANGKY trong 14 ngày đầu HK, DIEM__ là NULL
-- NVPKT S/U trên DANGKY những cột DIEM__
-- GV đc xem danh sách lớp, bảng điểm các lớp học phần mà giảng viên đó phụ trách giảng dạy

DROP FUNCTION SELECT_DANGKY;
CREATE OR REPLACE FUNCTION SELECT_DANGKY (
    schema_name VARCHAR2,
    table_name VARCHAR2
)
RETURN VARCHAR2
AS
    v_user   VARCHAR2(50);
    v_role   VARCHAR2(20);
    v_manv   VARCHAR2(10);
    v_khoa   VARCHAR2(10);
    v_hk     NUMBER;
    v_nam    VARCHAR2(10);
BEGIN
    -- Lấy tên người dùng hiện tại
    v_user := SYS_CONTEXT('USERENV', 'SESSION_USER');

    -- Truy ngược vai trò và thông tin người dùng
    BEGIN
        SELECT VAITRO, MANV, MADV INTO v_role, v_manv, v_khoa
        FROM user_admin.NHANVIEN
        WHERE MANV = v_user;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_role := '';
            v_manv := '';
            v_khoa := '';
    END;
    
    -- Xác định học kỳ và năm học hiện tại dựa vào SYSDATE
    IF TO_CHAR(SYSDATE, 'MMDD') BETWEEN '0901' AND '0914' THEN
        v_hk := 1;
        v_nam := TO_CHAR(EXTRACT(YEAR FROM SYSDATE)) || '-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE) + 1);
    ELSIF TO_CHAR(SYSDATE, 'MMDD') BETWEEN '0101' AND '0114' THEN -- chuyển 0114 thành 0430 để test
        v_hk := 2;
        v_nam := TO_CHAR(EXTRACT(YEAR FROM SYSDATE) - 1) || '-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE));
    ELSIF TO_CHAR(SYSDATE, 'MMDD') BETWEEN '0501' AND '0514' THEN
        v_hk := 3;
        v_nam := TO_CHAR(EXTRACT(YEAR FROM SYSDATE) - 1) || '-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE));
    ELSE
        v_hk := 0;
        v_nam := '';
    END IF;
    
    -- SV có thể xem dữ liệu chính mình
    IF v_user LIKE 'SV____' THEN
        RETURN 'MASV = ''' || v_user || '''';
    -- GV đc xem danh sách lớp, bảng điểm các lớp học phần mà giảng viên đó phụ trách giảng dạy
    ELSIF v_role = 'GV' THEN
        RETURN 'MAMM IN (
            SELECT mm.MAMM
            FROM NHANVIEN nv
            JOIN HOCPHAN hp ON nv.MADV = hp.MADV
            JOIN MOMON mm ON hp.MAHP = mm.MAHP
            WHERE nv.MANV = ''' || v_user || '''
        )';
    -- NVPKT S/U trên DANGKY những cột DIEM__
    ELSIF v_role = 'NVPKT' THEN
        RETURN '1 = 1';
    -- NVPDT S/I/U/D trên DANGKY trong 14 ngày đầu HK, DIEM__ là NULL
    ELSIF v_role = 'NVPDT' THEN
        RETURN 'MAMM IN (
            SELECT mm.MAMM
            FROM MOMON mm
            WHERE mm.HK = ''' || v_hk || '''
            AND mm.NAM = ''' || v_nam || '''
        )';
    ELSE
        RETURN '1 = 0';
    END IF;
END;
/

-- Xoá Policy DANGKY_SELECT_CONTROL
BEGIN 
    DBMS_RLS.drop_policy (
        object_schema => 'user_admin',
        object_name => 'DANGKY',
        policy_name => 'DANGKY_SELECT_CONTROL'
    );
END;
/
-- Đăng ký policy
BEGIN
    DBMS_RLS.ADD_POLICY (
        object_schema   => 'USER_ADMIN',
        object_name     => 'DANGKY',
        policy_name     => 'DANGKY_SELECT_CONTROL',
        function_schema => 'USER_ADMIN',
        policy_function => 'SELECT_DANGKY',
--        statement_types => 'SELECT',
e        update_check    => TRUE
    );
END;
/

DROP FUNCTION IUD_DANGKY_14;
CREATE OR REPLACE FUNCTION IUD_DANGKY_14 (
    schema_name VARCHAR2,
    table_name VARCHAR2
)
RETURN VARCHAR2
AS
    v_user   VARCHAR2(50);
    v_role   VARCHAR2(20);
    v_manv   VARCHAR2(10);
    v_hk     NUMBER;
    v_nam    VARCHAR2(10);
BEGIN
    -- Lấy tên người dùng hiện tại
    v_user := SYS_CONTEXT('USERENV', 'SESSION_USER');

    -- Truy thông tin nhân viên từ bảng NHANVIEN
    BEGIN
        SELECT VAITRO, MANV 
        INTO v_role, v_manv
        FROM user_admin.NHANVIEN
        WHERE MANV = v_user;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_role := '';
            v_manv := '';
    END;

    -- Xác định học kỳ và năm học hiện tại dựa vào SYSDATE
    IF TO_CHAR(SYSDATE, 'MMDD') BETWEEN '0901' AND '0914' THEN
        v_hk := 1;
        v_nam := TO_CHAR(EXTRACT(YEAR FROM SYSDATE)) || '-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE) + 1);
    ELSIF TO_CHAR(SYSDATE, 'MMDD') BETWEEN '0101' AND '0114' THEN -- chuyển 0114 thành 0430 để test
        v_hk := 2;
        v_nam := TO_CHAR(EXTRACT(YEAR FROM SYSDATE) - 1) || '-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE));
    ELSIF TO_CHAR(SYSDATE, 'MMDD') BETWEEN '0501' AND '0514' THEN
        v_hk := 3;
        v_nam := TO_CHAR(EXTRACT(YEAR FROM SYSDATE) - 1) || '-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE));
    ELSE
        v_hk := 0;
        v_nam := '';
    END IF;

    -- Xác định học kỳ hiện tại trong năm học
    -- SV I/U/D liên quan chính mình trong 14 ngày đầu HK,  DIEM__ là NULL
    -- NVPDT S/I/U/D trên DANGKY trong 14 ngày đầu HK, DIEM__ là NULL
    IF v_user LIKE 'SV____' THEN
        RETURN 'MASV = ''' || v_user || ''' AND MAMM IN (
            SELECT mm.MAMM
            FROM MOMON mm
            WHERE mm.HK = ''' || v_hk || '''
            AND mm.NAM = ''' || v_nam || '''
        )';
    ELSIF v_role = 'NVPDT' THEN
        RETURN 'MAMM IN (
            SELECT mm.MAMM
            FROM MOMON mm
            WHERE mm.HK = ''' || v_hk || '''
            AND mm.NAM = ''' || v_nam || '''
        )';
    -- NVPKT S/U trên DANGKY những cột DIEM__
    ELSIF v_role = 'NVPKT' THEN
        RETURN '1 = 1';
    ELSE
        RETURN '1 = 0';
    END IF;
END;
/

-- Xoá Policy IUD_DANGKY_14_CONTROL
BEGIN 
    DBMS_RLS.drop_policy (
        object_schema => 'user_admin',
        object_name => 'DANGKY',
        policy_name => 'IUD_DANGKY_14_CONTROL'
    );
END;
/
-- Đăng ký policy
BEGIN
    DBMS_RLS.ADD_POLICY (
        object_schema   => 'USER_ADMIN',
        object_name     => 'DANGKY',
        policy_name     => 'IUD_DANGKY_14_CONTROL',
        function_schema => 'USER_ADMIN',
        policy_function => 'IUD_DANGKY_14',
        statement_types => 'INSERT, UPDATE, DELETE',
        update_check    => TRUE
    );
END;
/

--
CREATE OR REPLACE FUNCTION get_vaitro_cau_4 RETURN VARCHAR2
AUTHID CURRENT_USER IS
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

-- Câu 4

-- Trigger cho SV NVPDT khi insert DANGKY
CREATE OR REPLACE TRIGGER trg_VPD_Cau_4_SV_NVPDT_INSERT
BEFORE INSERT ON user_admin.DANGKY
FOR EACH ROW
DECLARE
    v_user VARCHAR2(10);
    v_role VARCHAR2(20);
BEGIN
    v_user := SYS_CONTEXT('USERENV', 'SESSION_USER');
    v_role := get_vaitro_cau_4;
    
    IF v_role = 'SV' OR v_role = 'NVPDT' THEN
        :NEW.DIEMTH := NULL;
        :NEW.DIEMQT := NULL;
        :NEW.DIEMCK := NULL;
        :NEW.DIEMTK := NULL;
    END IF;
END;
/


-- Trigger cho SV NVPDT khi update DANGKY
CREATE OR REPLACE TRIGGER trg_VPD_Cau_4_SV_NVPDT_UPDATE
BEFORE UPDATE ON user_admin.DANGKY
FOR EACH ROW
DECLARE
    v_user VARCHAR2(10);
    v_role VARCHAR2(20);
BEGIN
    v_user := SYS_CONTEXT('USERENV', 'SESSION_USER');
    v_role := get_vaitro_cau_4;
    
    IF v_role = 'SV' OR v_role = 'NVPDT' THEN
        IF :NEW.DIEMTH != :OLD.DIEMTH OR
           :NEW.DIEMQT != :OLD.DIEMQT OR
           :NEW.DIEMCK != :OLD.DIEMCK OR
           :NEW.DIEMTK != :OLD.DIEMTK THEN
                RAISE_APPLICATION_ERROR(-20002, 'Bạn không được cập nhật điểm');
        END IF;
    END IF;
END;
/

-- Trigger cho SV khi I/U/D DANGKY
/*
CREATE OR REPLACE TRIGGER trg_VPD_Cau_4_SV_14
BEFORE INSERT OR UPDATE OR DELETE ON user_admin.DANGKY
FOR EACH ROW
DECLARE
    v_user VARCHAR2(10);
    v_role VARCHAR2(20);
BEGIN
    v_user := SYS_CONTEXT('USERENV', 'SESSION_USER');
    v_role := get_vaitro_cau_4;
    
    IF v_role = 'SV' THEN
        IF
        END IF;
    END IF;
END;
/
*/
-- SV có thể xem dữ liệu chính mình
-- SV I/U/D liên quan chính mình trong 14 ngày đầu HK, DIEM__ là NULL
GRANT SELECT ON user_admin.DANGKY TO SV;
GRANT INSERT, DELETE ON user_admin.DANGKY TO SV;
GRANT UPDATE (MAMM) ON user_admin.DANGKY TO SV;
/*
SELECT * FROM user_admin.DANGKY;
INSERT INTO user_admin.DANGKY (MASV,MAMM,DIEMCK) VALUES ('SV0001','MM0100',10);
COMMIT;
DELETE FROM user_admin.DANGKY WHERE MASV = 'SV0001' AND MAMM = 'MM0100';
COMMIT;
*/

-- NVPDT S/I/U/D trên DANGKY trong 14 ngày đầu HK, DIEM__ là NULL
GRANT SELECT ON user_admin.DANGKY TO NVPDT;
GRANT INSERT, DELETE ON user_admin.DANGKY TO NVPDT;
GRANT UPDATE (MAMM) ON user_admin.DANGKY TO NVPDT;
/*
SELECT * FROM user_admin.DANGKY WHERE MASV = 'SV0001';
INSERT INTO user_admin.DANGKY (MASV,MAMM,DIEMCK) VALUES ('SV0001','MM0100',10);
COMMIT;
DELETE FROM user_admin.DANGKY WHERE MASV = 'SV0001' AND MAMM = 'MM0100';
COMMIT;
*/

-- NVPKT S/U trên DANGKY những cột DIEM__
GRANT SELECT ON user_admin.DANGKY TO NVPKT;
GRANT UPDATE (DIEMTH, DIEMQT, DIEMCK, DIEMTK) ON user_admin.DANGKY TO NVPKT;
/*
SELECT * FROM user_admin.DANGKY WHERE MASV = 'SV0001' AND MAMM = 'MM0100';
UPDATE user_admin.DANGKY SET DIEMCK = 9.5 WHERE MASV = 'SV0001' AND MAMM = 'MM0100';
COMMIT;
*/

-- GV đc xem danh sách lớp, bảng điểm các lớp học phần mà giảng viên đó phụ trách giảng dạy
GRANT SELECT ON user_admin.DANGKY TO GV;
/*
SELECT * FROM user_admin.DANGKY;
*/
