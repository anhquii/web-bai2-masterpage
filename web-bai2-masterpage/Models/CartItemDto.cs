using System;

namespace web_bai2_masterpage.Models
{
    /// <summary>
    /// DTO đại diện cho 1 dòng sản phẩm trong Giỏ hàng (lưu trong Session["Cart"]).
    /// Áp dụng Tính Đóng Gói (Encapsulation): bảo vệ dữ liệu số lượng, đơn giá và tự động tính Thành tiền (SubTotal).
    /// </summary>
    [Serializable]
    public class CartItemDto
    {
        private int _productId;
        private string _productName;
        private string _image;
        private decimal _unitPrice;
        private int _quantity;

        public int ProductId
        {
            get { return _productId; }
            set
            {
                if (value <= 0)
                    throw new ArgumentException("Mã sản phẩm phải lớn hơn 0.");
                _productId = value;
            }
        }

        public string ProductName
        {
            get { return _productName; }
            set { _productName = value ?? string.Empty; }
        }

        public string Image
        {
            get { return _image; }
            set { _image = string.IsNullOrWhiteSpace(value) ? "no-image.svg" : value; }
        }

        public decimal UnitPrice
        {
            get { return _unitPrice; }
            set
            {
                if (value < 0)
                    throw new ArgumentException("Đơn giá sản phẩm không được âm.");
                _unitPrice = value;
            }
        }

        public int Quantity
        {
            get { return _quantity; }
            set
            {
                // Đảm bảo số lượng luôn nằm trong khoảng hợp lệ [1..99]
                if (value < 1)
                    _quantity = 1;
                else if (value > 99)
                    _quantity = 99;
                else
                    _quantity = value;
            }
        }

        /// <summary>
        /// Thành tiền của dòng sản phẩm = Đơn giá * Số lượng (Read-only Property).
        /// </summary>
        public decimal SubTotal
        {
            get { return _unitPrice * _quantity; }
        }
    }
}
