using System.Collections.Generic;
using web_bai2_masterpage.Models;

namespace web_bai2_masterpage.BLL
{
    /// <summary>
    /// Giao diện nghiệp vụ quản lý Giỏ hàng (Abstraction & Interface Segregation Principle).
    /// </summary>
    public interface ICartService
    {
        List<CartItemDto> GetCart();
        bool AddToCart(int productId, int quantity);
        void UpdateQuantity(int productId, int quantity);
        void RemoveFromCart(int productId);
        void ClearCart();
        int GetTotalQuantity();
        decimal GetSubTotalAmount();
    }
}
