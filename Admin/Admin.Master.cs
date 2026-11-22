using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace web_bai2_masterpage.Admin
{
    public partial class Admin : System.Web.UI.MasterPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            // --- CƠ CHẾ BẢO VỆ PHÂN QUYỀN (AUTHORIZATION GUARD) ---
            // 1. Kiểm tra: Chưa đăng nhập (Session null) HOẶC không phải quyền Admin
            if (Session["Username"] == null || Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                // Lưu lại URL hiện tại họ đang cố truy cập (ví dụ: /Admin/ProductList.aspx)
                string returnUrl = Request.RawUrl;
                // Đá văng ra trang Login kèm tham số ReturnUrl để sau khi đăng nhập xong tự quay lại
                Response.Redirect("~/Login.aspx?ReturnUrl=" + Server.UrlEncode(returnUrl));
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Hiển thị tên Admin lên thanh tiêu đề
            if (Session["Username"] != null)
            {
                litAdminName.Text = Session["Username"].ToString();
            }

        }
    }
}