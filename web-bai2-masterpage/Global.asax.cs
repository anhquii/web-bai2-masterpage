using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace web_bai2_masterpage
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            // Khởi tạo các biến toàn cục khi Website khởi động
            Application["TongTruyCap"] = 0; // Số khởi tạo ban đầu
            Application["DangOnline"] = 0;
        }

        protected void Session_Start(object sender, EventArgs e)
        {
            // Mỗi khi có một người dùng mới bắt đầu một phiên làm việc
            Application.Lock();
            Application["TongTruyCap"] = (int)Application["TongTruyCap"] + 1;
            Application["DangOnline"] = (int)Application["DangOnline"] + 1;
            Application.UnLock();
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
           
        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {
            // 3. Khách rời đi (hết phiên/timeout) -> Chỉ giảm người online trong Session_End
            Application.Lock();
            if ((int)Application["DangOnline"] > 0)
            {
                Application["DangOnline"] = (int)Application["DangOnline"] - 1;
            }
            Application.UnLock();
        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}