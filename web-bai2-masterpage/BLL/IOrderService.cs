using System.Collections.Generic;
using web_bai2_masterpage.Models;

namespace web_bai2_masterpage.BLL
{
    /// <summary>
    /// Giao diện nghiệp vụ Đặt hàng & Thanh toán (Abstraction & Dependency Inversion Principle).
    /// </summary>
    public interface IOrderService
    {
        IPaymentMethod GetPaymentMethod(string methodCode);
        int PlaceOrder(CheckoutRequestDto request, List<CartItemDto> cartItems);
        Order GetOrderById(int orderId);
    }
}
