namespace web_bai2_masterpage.BLL
{
    /// <summary>
    /// Chiến lược Thanh toán khi nhận hàng (Ship COD).
    /// Thực thi đa hình (Polymorphism) từ giao diện IPaymentMethod:
    /// - Đơn hàng dưới 5.000.000đ: phí vận chuyển 30.000đ.
    /// - Đơn hàng từ 5.000.000đ trở lên: miễn phí vận chuyển (0đ).
    /// </summary>
    public class CodPaymentMethod : IPaymentMethod
    {
        private const decimal FreeShippingThreshold = 5000000m;
        private const decimal StandardCodShippingFee = 30000m;

        public string MethodCode
        {
            get { return "COD"; }
        }

        public string MethodName
        {
            get { return "Thanh toán tiền mặt khi nhận hàng (COD)"; }
        }

        public string BankName
        {
            get { return string.Empty; }
        }

        public string AccountNumber
        {
            get { return string.Empty; }
        }

        public string AccountName
        {
            get { return string.Empty; }
        }

        public decimal CalculateShippingFee(decimal subTotal)
        {
            if (subTotal <= 0)
                return 0m;

            return subTotal >= FreeShippingThreshold ? 0m : StandardCodShippingFee;
        }

        public string GenerateQrImageUrl(decimal finalAmount, string transferContent)
        {
            // Phương thức COD không sử dụng mã QR
            return string.Empty;
        }

        public string GetPaymentInstruction(int orderId, decimal finalAmount)
        {
            return string.Format(
                "Quý khách vui lòng chuẩn bị số tiền {0:N0} VNĐ để thanh toán trực tiếp cho nhân viên giao hàng khi nhận đơn #{1}.",
                finalAmount,
                orderId);
        }
    }
}
