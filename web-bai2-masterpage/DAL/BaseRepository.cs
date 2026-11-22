using System.Configuration;

namespace web_bai2_masterpage.DAL
{
    /// <summary>
    /// Lớp cơ sở trừu tượng cho toàn bộ các Repository trong tầng DAL.
    /// Áp dụng Tính Kế Thừa (Inheritance): dùng chung phương thức khởi tạo LINQ to SQL DataContext
    /// từ chuỗi kết nối MyPhoneShopDBConnectionString trong Web.config.
    /// </summary>
    public abstract class BaseRepository
    {
        protected MyPhoneShopDataContext CreateContext()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyPhoneShopDBConnectionString"].ConnectionString;
            return new MyPhoneShopDataContext(connectionString);
        }
    }
}
