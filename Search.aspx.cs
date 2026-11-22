using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace web_bai2_masterpage
{
    public partial class Search : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        private void ShowPage(int index, string key)
        {
            using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
            {
                var products = (from p in db.Products
                                where p.ProductName.Contains(key)      // tên có chứa từ khóa
                                orderby p.ProductName
                                select new
                                {
                                    p.ProductId,
                                    p.ProductName,
                                    p.Price,
                                    Image = p.Image ?? "no-image.svg"
                                }).ToList();

                gvResults.DataSource = products;
                gvResults.PageIndex = index;      // trang số mấy (0 = trang đầu)
                gvResults.DataBind();
            }
        }


        protected void btnSearch_Click(object sender, EventArgs e)
        {
            ShowPage(0, txtKeyword.Text.Trim());
        }

        protected void gvResults_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            ShowPage(e.NewPageIndex, txtKeyword.Text.Trim());
        }
    }
}