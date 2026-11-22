using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

namespace web_bai2_masterpage
{
    public partial class SearchAjax : System.Web.UI.Page
    {
        /// <summary>
        /// Đối tượng truyền tải dữ liệu (DTO) đóng gói dữ liệu nhẹ nhàng trả về dưới dạng JSON
        /// </summary>
        public class ProductDto
        {
            public int ProductId { get; set; }
            public string ProductName { get; set; }
            public decimal Price { get; set; }
            public string Image { get; set; }
            public string BrandName { get; set; }
            public int BrandId { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static List<ProductDto> SearchProducts(string keyword)
        {
            using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
            {
                // Truy vấn LINQ: Nối bảng Products với Brands để vừa tìm theo tên máy, vừa tìm theo tên hãng
                var query = from p in db.Products
                            join b in db.Brands on p.BrandId equals b.BrandId
                            where string.IsNullOrEmpty(keyword) ||
                                  p.ProductName.Contains(keyword) ||
                                  b.BrandName.Contains(keyword)
                            orderby p.ProductId descending
                            select new ProductDto
                            {
                                ProductId = p.ProductId,
                                ProductName = p.ProductName,
                                Price = p.Price,
                                Image = p.Image,
                                BrandName = b.BrandName,
                                BrandId = b.BrandId
                            };

                return query.ToList();
            }
        }
    }
}