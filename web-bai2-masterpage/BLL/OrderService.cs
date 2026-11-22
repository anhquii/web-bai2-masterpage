using System;
using System.Collections.Generic;
using System.Linq;
using web_bai2_masterpage.DAL;
using web_bai2_masterpage.Models;

namespace web_bai2_masterpage.BLL
{
    /// <summary>
    /// Lớp thực thi nghiệp vụ Đặt hàng & Thanh toán.
    /// Kết hợp Đa hình (IPaymentMethod) để tính phí vận chuyển/tổng tiền và IOrderRepository để lưu đơn hàng.
    /// </summary>
    public class OrderService : IOrderService
    {
        private readonly IOrderRepository _orderRepository;

        public OrderService() : this(new OrderRepository())
        {
        }

        public OrderService(IOrderRepository orderRepository)
        {
            _orderRepository = orderRepository ?? throw new ArgumentNullException(nameof(orderRepository));
        }

        public IPaymentMethod GetPaymentMethod(string methodCode)
        {
            if (!string.IsNullOrWhiteSpace(methodCode) &&
                methodCode.Trim().Equals("BANK_QR", StringComparison.OrdinalIgnoreCase))
            {
                return new BankQrPaymentMethod();
            }

            return new CodPaymentMethod();
        }

        public int PlaceOrder(CheckoutRequestDto request, List<CartItemDto> cartItems)
        {
            if (request == null)
                throw new ArgumentNullException(nameof(request));

            if (cartItems == null || cartItems.Count == 0)
                throw new InvalidOperationException("Giỏ hàng đang trống, không thể đặt hàng.");

            if (string.IsNullOrWhiteSpace(request.CustomerName))
                throw new ArgumentException("Vui lòng nhập họ tên người nhận.");

            if (string.IsNullOrWhiteSpace(request.Phone))
                throw new ArgumentException("Vui lòng nhập số điện thoại liên hệ.");

            if (string.IsNullOrWhiteSpace(request.Address))
                throw new ArgumentException("Vui lòng nhập địa chỉ giao hàng.");

            // Áp dụng Đa hình (Polymorphism): gọi CalculateShippingFee qua giao diện IPaymentMethod
            IPaymentMethod paymentMethod = GetPaymentMethod(request.PaymentMethod);
            decimal subTotal = cartItems.Sum(x => x.SubTotal);
            decimal shippingFee = paymentMethod.CalculateShippingFee(subTotal);
            decimal finalTotal = subTotal + shippingFee;

            Order order = new Order
            {
                UserId = request.UserId,
                CustomerName = request.CustomerName,
                Phone = request.Phone,
                Address = request.Address,
                Note = string.IsNullOrWhiteSpace(request.Note) ? null : request.Note,
                PaymentMethod = paymentMethod.MethodCode,
                ShippingFee = shippingFee,
                TotalAmount = finalTotal,
                Status = paymentMethod.MethodCode == "BANK_QR"
                    ? "Chờ xác nhận chuyển khoản"
                    : "Chờ xác nhận",
                OrderDate = DateTime.Now
            };

            List<OrderDetail> orderDetails = cartItems.Select(item => new OrderDetail
            {
                ProductId = item.ProductId,
                Quantity = item.Quantity,
                UnitPrice = item.UnitPrice
            }).ToList();

            return _orderRepository.CreateOrder(order, orderDetails);
        }

        public Order GetOrderById(int orderId)
        {
            if (orderId <= 0)
                return null;

            return _orderRepository.GetOrderById(orderId);
        }
    }
}
