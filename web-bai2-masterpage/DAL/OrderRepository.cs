using System.Collections.Generic;
using System.Data.Linq;
using System.Linq;

namespace web_bai2_masterpage.DAL
{
    /// <summary>
    /// Lớp thực thi lưu trữ Đơn hàng (dbo.Orders) và Chi tiết đơn hàng (dbo.OrderDetails) bằng LINQ to SQL.
    /// Kế thừa từ BaseRepository (Inheritance) và thực thi IOrderRepository (Abstraction).
    /// </summary>
    public class OrderRepository : BaseRepository, IOrderRepository
    {
        public int CreateOrder(Order order, List<OrderDetail> orderDetails)
        {
            using (MyPhoneShopDataContext db = CreateContext())
            {
                // 1. Thêm hóa đơn chính vào bảng Orders và lưu để lấy OrderId tự tăng (IDENTITY)
                db.Orders.InsertOnSubmit(order);
                db.SubmitChanges();

                // 2. Gán OrderId vừa sinh ra cho từng dòng chi tiết đơn hàng (OrderDetails)
                foreach (OrderDetail detail in orderDetails)
                {
                    detail.OrderId = order.OrderId;
                    db.OrderDetails.InsertOnSubmit(detail);
                }

                // 3. Lưu toàn bộ chi tiết đơn hàng xuống CSDL
                db.SubmitChanges();

                return order.OrderId;
            }
        }

        public Order GetOrderById(int orderId)
        {
            using (MyPhoneShopDataContext db = CreateContext())
            {
                DataLoadOptions loadOptions = new DataLoadOptions();
                loadOptions.LoadWith<Order>(o => o.OrderDetails);
                db.LoadOptions = loadOptions;

                return db.Orders.FirstOrDefault(o => o.OrderId == orderId);
            }
        }
    }
}
