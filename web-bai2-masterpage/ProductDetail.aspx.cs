using System;
using System.Linq;
using System.Web.UI;
using web_bai2_masterpage.BLL;

namespace web_bai2_masterpage
{
    public partial class ProductDetail : System.Web.UI.Page
    {
        private readonly ICartService _cartService = new CartService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int id = GetRequestedProductId();
                ShowProduct(id);
            }
        }

        private int GetRequestedProductId()
        {
            int id;
            int.TryParse(Request.QueryString["id"], out id);
            return id;
        }

        private int GetSelectedQuantity()
        {
            int quantity;
            if (!int.TryParse(txtQuantity.Text, out quantity) || quantity < 1)
            {
                quantity = 1;
            }
            else if (quantity > 99)
            {
                quantity = 99;
            }
            return quantity;
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
                    pnlDetail.Visible = false;
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

        /// <summary>
        /// Sự kiện bấm nút "Thêm Vào Giỏ Hàng" (Chuẩn Shopee):
        /// Thêm sản phẩm vào Session["Cart"], giữ nguyên người dùng ở trang chi tiết và hiện thông báo thành công.
        /// </summary>
        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            int productId = GetRequestedProductId();
            int quantity = GetSelectedQuantity();

            bool added = _cartService.AddToCart(productId, quantity);
            if (added)
            {
                lblCartSuccess.Text = string.Format(
                    "Đã thêm {0} sản phẩm \"{1}\" vào Giỏ hàng!",
                    quantity,
                    lblName.Text);
                lblCartSuccess.Visible = true;
            }
        }

        /// <summary>
        /// Sự kiện bấm nút "Mua Ngay" (Chuẩn Shopee):
        /// Thêm sản phẩm vào Session["Cart"] và chuyển hướng thẳng tới trang Thanh toán (Checkout.aspx).
        /// </summary>
        protected void btnBuyNow_Click(object sender, EventArgs e)
        {
            int productId = GetRequestedProductId();
            int quantity = GetSelectedQuantity();

            bool added = _cartService.AddToCart(productId, quantity);
            if (added)
            {
                Response.Redirect("~/Checkout.aspx");
            }
        }
    }
}
