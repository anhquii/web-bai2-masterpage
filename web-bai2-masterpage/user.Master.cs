using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using web_bai2_masterpage.BLL;

namespace web_bai2_masterpage
{
    public partial class user : System.Web.UI.MasterPage
    {
        // Bộ nhớ đệm danh sách Menu đang kích hoạt trong 1 phiên request
        private List<Menu> _allActiveMenus = null;
        private readonly ICartService _cartService = new CartService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 1. Nạp Menu đa cấp từ CSDL (bảng dbo.Menus)
                LoadNavigationMenu();
            }

            // 2. Quản lý hiển thị trạng thái đăng nhập từ Session trên Header & Footer
            if (Session["Username"] != null)
            {
                string username = Session["Username"].ToString();
                string role = Session["Role"] != null ? Session["Role"].ToString() : "User";

                phAnonymous.Visible = false;
                phLoggedIn.Visible = true;
                litUsername.Text = Server.HtmlEncode(username);

                bool isAdmin = (role == "Admin");
                lnkAdmin.Visible = isAdmin;

                if (litFooterUser != null)
                {
                    litFooterUser.Text = Server.HtmlEncode(username + " (" + role + ")");
                }
            }
            else
            {
                phAnonymous.Visible = true;
                phLoggedIn.Visible = false;
                lnkAdmin.Visible = false;

                if (litFooterUser != null)
                {
                    litFooterUser.Text = "Khách vãng lai";
                }
            }

            // 3. Hiển thị thống kê phiên truy cập (Session_Start / Application) dưới Footer
            int onlineCount = (Application["DangOnline"] != null) ? Convert.ToInt32(Application["DangOnline"]) : 1;
            int totalVisits = (Application["TongTruyCap"] != null) ? Convert.ToInt32(Application["TongTruyCap"]) : 1;

            if (litOnlineCount != null)
                litOnlineCount.Text = onlineCount.ToString("N0") + " người";
            if (litTotalVisits != null)
                litTotalVisits.Text = totalVisits.ToString("N0") + " lượt";

            // 4. Cập nhật số lượng giỏ hàng trên Header
            UpdateCartBadge();
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // Cập nhật lại lần nữa ở PreRender để sau khi bấm "Thêm vào giỏ" ở trang con thì số trên Header tăng ngay lập tức
            UpdateCartBadge();
        }

        public void UpdateCartBadge()
        {
            if (litCartCount != null)
            {
                litCartCount.Text = _cartService.GetTotalQuantity().ToString();
            }
        }

        /// <summary>
        /// Tạo đường dẫn lọc theo mức giá đồng thời GIỮ NGUYÊN tham số cat và brand đang chọn trên URL
        /// </summary>
        public string GetPriceFilterUrl(string priceKey)
        {
            List<string> queryParts = new List<string>();

            string cat = Request.QueryString["cat"];
            string brand = Request.QueryString["brand"];

            if (!string.IsNullOrWhiteSpace(cat))
                queryParts.Add("cat=" + Server.UrlEncode(cat.Trim()));

            if (!string.IsNullOrWhiteSpace(brand))
                queryParts.Add("brand=" + Server.UrlEncode(brand.Trim()));

            if (!string.IsNullOrWhiteSpace(priceKey))
                queryParts.Add("price=" + Server.UrlEncode(priceKey.Trim()));

            string queryString = queryParts.Count > 0 ? ("?" + string.Join("&", queryParts)) : "";
            return ResolveUrl("~/Default.aspx" + queryString);
        }

        /// <summary>
        /// Trả về class CSS làm sáng (active) mục giá đang được người dùng chọn ở cột trái
        /// </summary>
        public string GetPriceActiveClass(string priceKey)
        {
            string currentPrice = (Request.QueryString["price"] ?? "").Trim().ToLower();
            string targetPrice = (priceKey ?? "").Trim().ToLower();

            return (currentPrice == targetPrice) ? "side-menu-item active" : "side-menu-item";
        }

        /// <summary>
        /// Nạp toàn bộ danh mục Menu đa cấp từ bảng dbo.Menus (LINQ to SQL)
        /// </summary>
        private void LoadNavigationMenu()
        {
            try
            {
                using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
                {
                    // Lấy toàn bộ Menu, sắp xếp theo OrderKey
                    _allActiveMenus = db.Menus
                                        .OrderBy(m => m.OrderKey)
                                        .ToList();

                    // Lọc ra các Menu Cha cấp 1 (Parent == 0)
                    var parentMenus = _allActiveMenus
                                        .Where(m => m.Parent == 0)
                                        .ToList();

                    // Đổ dữ liệu vào Repeater Menu Cha
                    rptParentMenus.DataSource = parentMenus;
                    rptParentMenus.DataBind();
                }
            }
            catch
            {
                // Bắt ngoại lệ để website không bị crash nếu kết nối DB gián đoạn
            }
        }

        /// <summary>
        /// Sự kiện xảy ra khi từng dòng Menu Cha được sinh ra: Nạp các Menu Con tương ứng
        /// </summary>
        protected void rptParentMenus_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var parentMenu = (Menu)e.Item.DataItem;
                Repeater rptChild = (Repeater)e.Item.FindControl("rptChildMenus");

                if (rptChild != null && parentMenu != null && _allActiveMenus != null)
                {
                    // Lấy các menu con có Parent == ID_MN của cha hiện tại
                    var childMenus = _allActiveMenus
                                       .Where(m => m.Parent == parentMenu.ID_MN)
                                       .ToList();

                    if (childMenus.Any())
                    {
                        rptChild.DataSource = childMenus;
                        rptChild.DataBind();
                    }
                    else
                    {
                        // Nếu menu cha này không có con -> Ẩn khung dropdown
                        var pnlDropdown = e.Item.FindControl("pnlDropdown");
                        if (pnlDropdown != null)
                        {
                            pnlDropdown.Visible = false;
                        }
                    }
                }
            }
        }
    }
}
