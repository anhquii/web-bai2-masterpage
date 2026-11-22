using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace web_bai2_masterpage
{
    public partial class user : System.Web.UI.MasterPage
    {
        // Bộ nhớ đệm danh sách Menu đang kích hoạt trong 1 phiên request
        private List<Menu> _allActiveMenus = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 1. Nạp Menu đa cấp từ CSDL (bảng dbo.Menus)
                LoadNavigationMenu();
            }

            // 3. Quản lý hiển thị trạng thái đăng nhập từ Session
            if (Session["Username"] != null)
            {
                phAnonymous.Visible = false;
                phLoggedIn.Visible = true;
                litUsername.Text = Session["Username"].ToString();

                bool isAdmin = (Session["Role"] != null && Session["Role"].ToString() == "Admin");
                lnkAdmin.Visible = isAdmin;
            }
            else
            {
                phAnonymous.Visible = true;
                phLoggedIn.Visible = false;
                lnkAdmin.Visible = false;
            }
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