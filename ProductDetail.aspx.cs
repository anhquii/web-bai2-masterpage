using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace web_bai2_masterpage
{
    public partial class ProductDetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) {
                int id;
                int.TryParse(Request.QueryString["id"], out id);
                ShowProduct(id);
                
            }

        }

        private void ShowProduct(int id)
        {
            using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
            {
                var sp = (from p in db.Products
                          join c in db.Categories on p.CategoryId equals c.CategoryId
                          join b in db.Brands on p.BrandId equals b.BrandId
                          
                          where p.ProductId == id
                          select new
                          {
                              p.ProductName,
                              p.Price,
                              p.Image,
                              p.Description,
                              c.CategoryName,
                              b.BrandName
                          }).SingleOrDefault();
                if (sp == null) 
                {
                    lblMessage.Text = "Không tìm thấy sản phẩm";
                    lblMessage.Visible = true;
                    pnlDetail.Visible =false;

                    return;
                }

                lblName.Text = sp.ProductName;
                lblCategory.Text = sp.CategoryName;
                lblBrand.Text = sp.BrandName;
                lblPrice.Text = string.Format("{0:N0} đ", sp.Price);

                imgProduct.ImageUrl = "~/Images/" + (sp.Image ?? "no-image.svg");

                imgProduct.AlternateText = sp.ProductName;

                if (string.IsNullOrEmpty(sp.Description))
                {
                    lblDescription.Text = "Đang cập nhật mô tả";
                }
                else
                {
                    lblDescription.Text = Server.HtmlEncode(sp.Description).Replace("\n", "<br />");
                }


            }
        }


    }
}