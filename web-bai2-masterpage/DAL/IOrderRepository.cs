using System.Collections.Generic;

namespace web_bai2_masterpage.DAL
{
    /// <summary>
    /// Giao diện truy xuất dữ liệu Đơn hàng (Abstraction & Interface Segregation Principle).
    /// </summary>
    public interface IOrderRepository
    {
        int CreateOrder(Order order, List<OrderDetail> orderDetails);
        Order GetOrderById(int orderId);
    }
}
