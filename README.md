## Hướng dẫn chạy SQL (Phân hệ 1 & Phân hệ 2 – Yêu cầu 1)

Chạy theo **thứ tự từ trên xuống dưới**:

1. `createadmin.sql` *(chạy bằng `SYS AS SYSDBA`)*
2. `runwadmin.sql` *(chạy bằng tài khoản `user_admin` thuộc session `ATBM` được tạo sau khi chạy `createadmin.sql`)*
3. `chaybanguseradmin_ph1.sql` *(chạy bằng `user_admin`)*
4. `SV.sql` *(chạy bằng `user_admin`)*
5. `proc_GV.sql` *(chạy bằng `user_admin`)*
6. `NVCTSV_NVPKT.sql` *(chạy bằng `user_admin`)*

**Lưu ý:**
- **Giải nén source code trước khi dùng.**
- Khi chạy `createadmin.sql`, hãy **sửa đường dẫn tạo PDB mới** cho phù hợp với từng máy.

---

## Hướng dẫn chạy Phân hệ 2 – Yêu cầu 2 (Phát tán thông báo bằng OLS)

1. Đăng nhập user **`lbacsys`** và tạo **policy OLS** *(chú thích số 1 trong file SQL)*.
2. Đăng nhập user **`sys`** để cấp quyền cần thiết cho **`user_admin`** sử dụng các thủ tục OLS *(chú thích số 2)*.
3. Đăng nhập **`user_admin`** để tạo bảng **`THONGBAO`** *(chú thích số 3)*.
4. Chuyển về **`lbacsys`** để tiếp tục:
   - tạo policy, level, group, compartment
   - tạo label và gán label  
   *(chú thích từ 4 đến 13)*
5. Chuyển sang **`user_admin`** để insert dữ liệu thông báo **t1 → t9** vào bảng `THONGBAO` *(chú thích số 14)*.
6. Chuyển về **`sys`** để cấp quyền `CONNECT` cho các user **u1 → u8** *(chú thích số 15)*.
7. Tạo connection mới, đăng nhập từng user để xem thông báo tương ứng với **group/compartment/level** được gán.

---

## Hướng dẫn chạy `ATBM-07.exe`

1. Chuyển file `ATBM-07.exe` trong folder `02-exe` sang:
   `01-ATBM-07-SourceCode\ATBM-07\bin\Release\net8.0-windows`
2. Double-click để chạy.

## Demo

| Role / Scenario | Video |
|---|---|
| Admin | https://www.youtube.com/watch?v=YiuBG_kysks |
| Other users | https://www.youtube.com/watch?v=9wlTCezoeVA |

