using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using web_bai2_masterpage.Helpers;


namespace web_bai2_masterpage
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;
            // 1. Kiểm tra rỗng
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(confirmPassword))
            {
                ShowAlert("Vui lòng điền đầy đủ tất cả các trường!", false);
                return;
            }
            // 2. Kiểm tra độ dài mật khẩu
            if (password.Length < 6)
            {
                ShowAlert("Mật khẩu phải có độ dài từ 6 ký tự trở lên!", false);
                return;
            }
            // 3. Kiểm tra mật khẩu nhập lại
            if (password != confirmPassword)
            {
                ShowAlert("Mật khẩu xác nhận không trùng khớp!", false);
                return;
            }
            using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
            {
                // 4. Kiểm tra tài khoản đã tồn tại chưa
                bool isExist = db.Users.Any(u => u.Username.ToLower() == username.ToLower());
                if (isExist)
                {
                    ShowAlert("Tên đăng nhập '" + username + "' đã được sử dụng. Vui lòng chọn tên khác!", false);
                    return;
                }
                // 5. Sinh chuỗi muối (Salt) ngẫu nhiên và băm mật khẩu chuẩn SHA-256
                string salt = SecurityHelper.GenerateSalt();
                string passwordHash = SecurityHelper.HashPassword(password, salt);
                // 6. Tạo đối tượng User mới (Mặc định Role là 'User')
                User newUser = new User();
                newUser.Username = username;
                newUser.PasswordHash = passwordHash;
                newUser.Salt = salt;
                newUser.Role = "User";
                // 7. Lưu vào SQL Server
                db.Users.InsertOnSubmit(newUser);
                db.SubmitChanges();
                // 8. Thông báo thành công và xóa trắng form
                ShowAlert("🎉 Đăng ký tài khoản thành công! Bạn có thể Đăng nhập ngay bây giờ.", true);
                txtUsername.Text = string.Empty;
                txtPassword.Text = string.Empty;
                txtConfirmPassword.Text = string.Empty;
            }
        }
        private void ShowAlert(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = isSuccess ? "msg-alert msg-success" : "msg-alert msg-error";
            lblMessage.Visible = true;
        }

    }
}