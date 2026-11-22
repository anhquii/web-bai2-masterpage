using System;
using System.Web;

namespace web_bai2_masterpage.BLL
{
    /// <summary>
    /// Chiến lược Thanh toán Chuyển khoản Ngân hàng qua mã VietQR động.
    /// Thực thi đa hình (Polymorphism) từ giao diện IPaymentMethod:
    /// - Ưu đãi miễn phí vận chuyển (0đ) cho khách chuyển khoản.
    /// - Tự động sinh mã VietQR chuẩn Napas247 kèm số tiền và nội dung chuyển khoản.
    /// </summary>
    public class BankQrPaymentMethod : IPaymentMethod
    {
        public string MethodCode
        {
            get { return "BANK_QR"; }
        }

        public string MethodName
        {
            get { return "Chuyển khoản Ngân hàng (Quét mã VietQR)"; }
        }

        public string BankName
        {
            get { return "MB Bank (Ngân hàng Quân Đội)"; }
        }

        public string AccountNumber
        {
            get { return "0987654321"; }
        }

        public string AccountName
        {
            get { return "MY PHONE SHOP"; }
        }

        public decimal CalculateShippingFee(decimal subTotal)
        {
            // Ưu đãi miễn phí giao hàng khi thanh toán qua VietQR
            return 0m;
        }

        public string GenerateQrImageUrl(decimal finalAmount, string transferContent)
        {
            long amountInt = (long)Math.Round(finalAmount, 0);
            string safeContent = Uri.EscapeDataString(string.IsNullOrWhiteSpace(transferContent) ? "MPS THANH TOAN" : transferContent);
            string safeAccountName = Uri.EscapeDataString(AccountName);

            return string.Format(
                "https://img.vietqr.io/image/MB-{0}-compact2.png?amount={1}&addInfo={2}&accountName={3}",
                AccountNumber,
                amountInt,
                safeContent,
                safeAccountName);
        }

        public string GetPaymentInstruction(int orderId, decimal finalAmount)
        {
            return string.Format(
                "Quý khách đã chọn Chuyển khoản VietQR ({0} - STK: {1} - Chủ TK: {2}) với số tiền {3:N0} VNĐ và nội dung 'MPS{4}'. Hệ thống sẽ xác nhận đơn hàng ngay sau khi nhận được giao dịch.",
                BankName,
                AccountNumber,
                AccountName,
                finalAmount,
                orderId);
        }
    }
}
