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
            // 1. Đọc bộ lọc trên URL (Hỗ trợ cả cat dạng số ?cat=1 lẫn dạng chữ ?cat=phone)
            int catId = ParseCategoryId(Request.QueryString["cat"]);
            int brandId;
            int.TryParse(Request.QueryString["brand"], out brandId);
            string price = (Request.QueryString["price"] ?? "").Trim().ToLower();

            using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
            {
                // 2. Bắt đầu từ tất cả sản phẩm, rồi CỘNG DỒN từng điều kiện lọc (Danh mục + Hãng + Mức giá)
                var query = db.Products.AsQueryable();
                if (catId > 0) query = query.Where(p => p.CategoryId == catId);
                if (brandId > 0) query = query.Where(p => p.BrandId == brandId);

                switch (price)
                {
                    case "under5":
                        query = query.Where(p => p.Price < 5000000);
                        break;
                    case "5to10":
                        query = query.Where(p => p.Price >= 5000000 && p.Price <= 10000000);
                        break;
                    case "10to20":
                        query = query.Where(p => p.Price >= 10000000 && p.Price <= 20000000);
                        break;
                    case "over20":
                        query = query.Where(p => p.Price > 20000000);
                        break;
                }

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
                litTitle.Text = BuildTitle(db, catId, brandId, price);
            }
        }

        private int ParseCategoryId(string catRaw)
        {
            if (string.IsNullOrWhiteSpace(catRaw)) return 0;

            int catId;
            if (int.TryParse(catRaw.Trim(), out catId)) return catId;

            switch (catRaw.Trim().ToLower())
            {
                case "phone": return 1;
                case "laptop": return 2;
                case "keyboard": return 3;
                default: return 0;
            }
        }

        private string BuildTitle(MyPhoneShopDataContext db, int catId, int brandId, string price)
        {
            var category = db.Categories.FirstOrDefault(c => c.CategoryId == catId);
            var brand = db.Brands.FirstOrDefault(b => b.BrandId == brandId);

            string baseTitle = "Tất cả sản phẩm";
            if (category != null && brand != null)
                baseTitle = category.CategoryName + " " + brand.BrandName;
            else if (category != null)
                baseTitle = category.CategoryName;
            else if (brand != null)
                baseTitle = "Sản phẩm " + brand.BrandName;

            string priceLabel = GetPriceLabel(price);
            if (!string.IsNullOrEmpty(priceLabel))
            {
                if (catId == 0 && brandId == 0)
                    return "Sản phẩm có giá: " + priceLabel;
                return baseTitle + " — Giá: " + priceLabel;
            }

            return baseTitle;
        }

        private string GetPriceLabel(string price)
        {
            switch (price)
            {
                case "under5": return "Dưới 5 Triệu";
                case "5to10": return "Từ 5 - 10 Triệu";
                case "10to20": return "Từ 10 - 20 Triệu";
                case "over20": return "Trên 20 Triệu";
                default: return "";
            }
        }
    }
}
