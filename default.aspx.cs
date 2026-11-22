using System;
using System.Linq;

namespace web_bai2_masterpage
{
    public partial class _default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Chỉ nạp dữ liệu ở lần mở trang đầu tiên, không nạp lại khi bấm nút trên trang
            if (!IsPostBack)
            {
                LoadProducts();
            }
        }

        private void LoadProducts()
        {
            // 1. Đọc bộ lọc trên URL. Không có hoặc gõ bậy (?cat=abc) thì = 0, nghĩa là không lọc
            int catId, brandId;
            int.TryParse(Request.QueryString["cat"], out catId); //?TryParse
            int.TryParse(Request.QueryString["brand"], out brandId);

            using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
            {
                // 2. Bắt đầu từ tất cả sản phẩm, rồi CỘNG DỒN từng điều kiện lọc
                var query = db.Products.AsQueryable();
                if (catId > 0) query = query.Where(p => p.CategoryId == catId);
                if (brandId > 0) query = query.Where(p => p.BrandId == brandId);

                // 3. Nối với bảng Brands để lấy tên hãng; sản phẩm mới nhất lên đầu
                var products = (from p in query
                                join b in db.Brands on p.BrandId equals b.BrandId
                                orderby p.ProductId descending
                                select new
                                {
                                    p.ProductId,
                                    p.ProductName,
                                    p.Price,
                                    Image = p.Image ?? "no-image.svg",   // chưa có ảnh thì dùng ảnh dự phòng
                                    b.BrandName
                                }).ToList();

                // 4. Đổ dữ liệu vào Repeater; không có sản phẩm nào thì hiện thông báo
                rptProducts.DataSource = products;
                rptProducts.DataBind();
                lblEmpty.Visible = (products.Count == 0);

                // 5. Tiêu đề theo bộ lọc đang chọn
                litTitle.Text = BuildTitle(db, catId, brandId);
            }
        }

        private string BuildTitle(MyPhoneShopDataContext db, int catId, int brandId)
        {
            var category = db.Categories.FirstOrDefault(c => c.CategoryId == catId);
            var brand = db.Brands.FirstOrDefault(b => b.BrandId == brandId);

            if (category != null && brand != null) return category.CategoryName + " " + brand.BrandName;
            if (category != null) return category.CategoryName;
            if (brand != null) return "Sản phẩm " + brand.BrandName;
            return "Tất cả sản phẩm";
        }
    }
}