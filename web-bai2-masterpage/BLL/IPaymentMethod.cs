namespace web_bai2_masterpage.BLL
{
    /// <summary>
    /// Giao diện chiến lược thanh toán (Strategy Pattern).
    /// Áp dụng Tính Trừu Tượng (Abstraction), Tính Đa Hình (Polymorphism),
    /// Open/Closed Principle (OCP) và Liskov Substitution Principle (LSP).
    /// </summary>
    public interface IPaymentMethod
    {
        string MethodCode { get; }
        string MethodName { get; }
        string BankName { get; }
        string AccountNumber { get; }
        string AccountName { get; }

        /// <summary>
        /// Tính phí vận chuyển dựa trên tổng tiền hàng tạm tính.
        /// </summary>
        decimal CalculateShippingFee(decimal subTotal);

        /// <summary>
        /// Tạo đường dẫn ảnh mã QR thanh toán động (VietQR) nếu là chuyển khoản ngân hàng.
        /// </summary>
        string GenerateQrImageUrl(decimal finalAmount, string transferContent);

        /// <summary>
        /// Trả về thông điệp hướng dẫn thanh toán sau khi đặt hàng thành công.
        /// </summary>
        string GetPaymentInstruction(int orderId, decimal finalAmount);
    }
}
