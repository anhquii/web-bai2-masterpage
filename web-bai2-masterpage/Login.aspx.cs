using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using web_bai2_masterpage.Helpers;

namespace web_bai2_masterpage
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 1. Nếu đã đăng nhập rồi thì không cần ở lại trang Login nữa
                if (Session["Username"] != null)
                {
                    RedirectByRole(Session["Role"]?.ToString());
                    return;
                }
                // 2. Đọc Cookie ghi nhớ tên đăng nhập (nếu có)
                HttpCookie rememberCookie = Request.Cookies["RememberUser"];
                if (rememberCookie != null && !string.IsNullOrEmpty(rememberCookie.Value))
                {
                    txtUsername.Text = rememberCookie.Value;
                    chkRememberMe.Checked = true;
                }
            }



        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;
            // Kiểm tra rỗng
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                ShowError("Vui lòng nhập đầy đủ Tên đăng nhập và Mật khẩu!");
                return;
            }
            using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
            {
                // Tìm tài khoản trong CSDL
                var user = db.Users.FirstOrDefault(u => u.Username == username);
                // Nếu tài khoản không tồn tại hoặc mật khẩu băm không khớp
                if (user == null || !SecurityHelper.VerifyPassword(password, user.PasswordHash, user.Salt))
                {
                    ShowError("Tên đăng nhập hoặc mật khẩu không chính xác!");
                    return;
                }
                // --- XÁC THỰC THÀNH CÔNG ---
                // 1. Cấp phát phiên làm việc (Session)
                Session["UserId"] = user.UserId;
                Session["Username"] = user.Username;
                Session["Role"] = user.Role; // 'Admin' hoặc 'User'
                // 2. Xử lý Cookie "Ghi nhớ đăng nhập"
                HttpCookie rememberCookie = new HttpCookie("RememberUser");
                if (chkRememberMe.Checked)
                {
                    rememberCookie.Value = user.Username;
                    rememberCookie.Expires = DateTime.Now.AddDays(15); // Ghi nhớ trong 15 ngày
                }
                else
                {
                    rememberCookie.Expires = DateTime.Now.AddDays(-1); // Xóa cookie nếu bỏ chọn
                }
                Response.Cookies.Add(rememberCookie);
                // 3. Phân luồng điều hướng hợp lý theo Role
                RedirectByRole(user.Role);
            }

        }

        /// <summary>
        /// Điều hướng chuẩn xác: Admin vào trang Quản trị, Khách về trang Bán hàng
        /// </summary>
        private void RedirectByRole(string role)
        {
            // Nếu có tham số ReturnUrl (trường hợp bị chặn khi gõ link trực tiếp)
            string returnUrl = Request.QueryString["ReturnUrl"];
            if (!string.IsNullOrEmpty(returnUrl))
            {
                Response.Redirect(returnUrl);
                return;
            }
            if (string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("~/Admin/ProductList.aspx");
            }
            else
            {
                Response.Redirect("~/default.aspx");
            }
        }
        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;
        }


    }
}