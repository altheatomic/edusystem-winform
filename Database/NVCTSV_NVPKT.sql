-- SP cho màn hình NVCTSV và NVPKT
-- Cập nhật điểm 
CREATE OR REPLACE PROCEDURE sp_update_diem_dangky (
    p_masv   IN VARCHAR2,
    p_mamm   IN VARCHAR2,
    p_diemth IN NUMBER,
    p_diemqt IN NUMBER,
    p_diemck IN NUMBER,
    p_diemtk IN NUMBER
)
IS
BEGIN
    UPDATE DANGKY
    SET DIEMTH = p_diemth,
        DIEMQT = p_diemqt,
        DIEMCK = p_diemck,
        DIEMTK = p_diemtk
    WHERE MASV = p_masv AND MAMM = p_mamm;
END;
/

GRANT EXECUTE ON sp_update_diem_dangky TO NVPKT;


-- Get
CREATE OR REPLACE PROCEDURE sp_get_all_dangky (
    p_result OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_result FOR
        SELECT * FROM user_admin.DANGKY;
END;
/

GRANT EXECUTE ON sp_get_all_dangky TO NVPKT;

-- select sv
CREATE OR REPLACE PROCEDURE SP_GET_ALL_SINHVIEN_NVCTSV(p_result OUT SYS_REFCURSOR) AS
BEGIN
    OPEN p_result FOR
    SELECT MASV, HOTEN, PHAI, NGSINH, DCHI, DT, KHOA, TINHTRANG
    FROM user_admin.SINHVIEN;
END;
/
GRANT EXECUTE ON SP_GET_ALL_SINHVIEN_NVCTSV TO NVCTSV;


-- Stored Procedure: Insert SINHVIEN
CREATE OR REPLACE PROCEDURE SP_INSERT_SINHVIEN(
    p_masv      IN SINHVIEN.MASV%TYPE,
    p_hoten     IN SINHVIEN.HOTEN%TYPE,
    p_phai      IN SINHVIEN.PHAI%TYPE,
    p_ngsinh    IN SINHVIEN.NGSINH%TYPE,
    p_dchi      IN SINHVIEN.DCHI%TYPE,
    p_dt        IN SINHVIEN.DT%TYPE,
    p_khoa      IN SINHVIEN.KHOA%TYPE
)
IS
BEGIN
    INSERT INTO user_admin.SINHVIEN (MASV, HOTEN, PHAI, NGSINH, DCHI, DT, KHOA, TINHTRANG)
    VALUES (p_masv, p_hoten, p_phai, p_ngsinh, p_dchi, p_dt, p_khoa, NULL);
END;
/
GRANT EXECUTE ON SP_INSERT_SINHVIEN TO NVCTSV;


-- Stored Procedure: Update SINHVIEN (trừ TINHTRANG)
CREATE OR REPLACE PROCEDURE SP_UPDATE_SINHVIEN(
    p_masv      IN SINHVIEN.MASV%TYPE,
    p_hoten     IN SINHVIEN.HOTEN%TYPE,
    p_phai      IN SINHVIEN.PHAI%TYPE,
    p_ngsinh    IN SINHVIEN.NGSINH%TYPE,
    p_dchi      IN SINHVIEN.DCHI%TYPE,
    p_dt        IN SINHVIEN.DT%TYPE,
    p_khoa      IN SINHVIEN.KHOA%TYPE
)
IS
BEGIN
    UPDATE user_admin.SINHVIEN
    SET HOTEN  = p_hoten,
        PHAI   = p_phai,
        NGSINH = p_ngsinh,
        DCHI   = p_dchi,
        DT     = p_dt,
        KHOA   = p_khoa
    WHERE MASV = p_masv;
END;
/

GRANT EXECUTE ON SP_UPDATE_SINHVIEN TO NVCTSV;

-- Stored Procedure: Delete SINHVIEN
CREATE OR REPLACE PROCEDURE SP_DELETE_SINHVIEN(
    p_masv IN SINHVIEN.MASV%TYPE
)
IS
BEGIN
    DELETE FROM user_admin.SINHVIEN
    WHERE MASV = p_masv;
END;
/

GRANT EXECUTE ON SP_DELETE_SINHVIEN TO NVCTSV;
