using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace web_bai2_masterpage
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Xóa toàn bộ các giá trị đang lưu trong Session
            Session.Clear();
            // 2. Hủy phiên làm việc hiện tại của người dùng
            Session.Abandon();
            // 3. Xóa Cookie xác thực (nếu người dùng đăng xuất chủ động)
            if (Request.Cookies["RememberUser"] != null)
            {
                HttpCookie rememberCookie = new HttpCookie("RememberUser");
                rememberCookie.Expires = DateTime.Now.AddDays(-1); // Hết hạn ngay lập tức
                Response.Cookies.Add(rememberCookie);
            }
            // 4. Chuyển hướng người dùng về lại Trang chủ
            Response.Redirect("~/default.aspx");
        }
    }
}