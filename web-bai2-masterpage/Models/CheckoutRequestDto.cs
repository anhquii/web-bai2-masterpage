using System;

namespace web_bai2_masterpage.Models
{
    /// <summary>
    /// DTO đóng gói thông tin người nhận và phương thức thanh toán từ trang Checkout.aspx gửi xuống tầng BLL.
    /// Áp dụng Tính Đóng Gói (Encapsulation) và Single Responsibility Principle (SRP).
    /// </summary>
    public class CheckoutRequestDto
    {
        private int? _userId;
        private string _customerName;
        private string _phone;
        private string _address;
        private string _note;
        private string _paymentMethod;

        public int? UserId
        {
            get { return _userId; }
            set { _userId = value; }
        }

        public string CustomerName
        {
            get { return _customerName; }
            set { _customerName = (value ?? string.Empty).Trim(); }
        }

        public string Phone
        {
            get { return _phone; }
            set { _phone = (value ?? string.Empty).Trim(); }
        }

        public string Address
        {
            get { return _address; }
            set { _address = (value ?? string.Empty).Trim(); }
        }

        public string Note
        {
            get { return _note; }
            set { _note = (value ?? string.Empty).Trim(); }
        }

        public string PaymentMethod
        {
            get { return _paymentMethod; }
            set { _paymentMethod = string.IsNullOrWhiteSpace(value) ? "COD" : value.Trim().ToUpperInvariant(); }
        }
    }
}
