using System.Linq;

namespace web_bai2_masterpage.DAL
{
    /// <summary>
    /// Lớp thực thi truy xuất dữ liệu Sản phẩm bằng LINQ to SQL.
    /// Kế thừa từ BaseRepository (Inheritance) và thực thi IProductRepository (Abstraction).
    /// </summary>
    public class ProductRepository : BaseRepository, IProductRepository
    {
        public Product GetProductById(int productId)
        {
            using (MyPhoneShopDataContext db = CreateContext())
            {
                return db.Products.FirstOrDefault(p => p.ProductId == productId);
            }
        }
    }
}
