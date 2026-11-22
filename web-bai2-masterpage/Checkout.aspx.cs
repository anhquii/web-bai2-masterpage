using System;
using System.Collections.Generic;
using System.Linq;
using web_bai2_masterpage.BLL;
using web_bai2_masterpage.Models;

namespace web_bai2_masterpage
{
    public partial class Checkout : System.Web.UI.Page
    {
        private readonly ICartService _cartService = new CartService();
        private readonly IOrderService _orderService = new OrderService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                List<CartItemDto> cartItems = _cartService.GetCart();
                if (cartItems == null || cartItems.Count == 0)
                {
                    // Nếu giỏ hàng trống thì chuyển về trang Giỏ hàng
                    Response.Redirect("~/Cart.aspx");
                    return;
                }

                // Tự động điền sẵn tên tài khoản nếu khách đã đăng nhập
                if (Session["Username"] != null && string.IsNullOrWhiteSpace(txtCustomerName.Text))
                {
                    txtCustomerName.Text = Session["Username"].ToString();
                }

                BindCheckoutSummary();
            }
        }

        /// <summary>
        /// Hiển thị tóm tắt đơn hàng, tính phí vận chuyển và sinh mã VietQR động thông qua Đa hình (IPaymentMethod).
        /// </summary>
        private void BindCheckoutSummary()
        {
            List<CartItemDto> cartItems = _cartService.GetCart();
            if (cartItems == null || cartItems.Count == 0)
            {
                Response.Redirect("~/Cart.aspx");
                return;
            }

            rptOrderItems.DataSource = cartItems;
            rptOrderItems.DataBind();

            litSummaryCount.Text = _cartService.GetTotalQuantity().ToString();

            decimal subTotal = _cartService.GetSubTotalAmount();
            string selectedMethodCode = rblPaymentMethod.SelectedValue;

            // Áp dụng Đa hình (Polymorphism): Lấy chiến lược thanh toán tương ứng
            IPaymentMethod paymentMethod = _orderService.GetPaymentMethod(selectedMethodCode);
            decimal shippingFee = paymentMethod.CalculateShippingFee(subTotal);
            decimal finalTotal = subTotal + shippingFee;

            litCheckoutSubTotal.Text = string.Format("{0:N0} đ", subTotal);
            litShippingFee.Text = shippingFee == 0m
                ? "Miễn phí (0 đ)"
                : string.Format("{0:N0} đ", shippingFee);
            litFinalTotal.Text = string.Format("{0:N0} đ", finalTotal);

            // Nếu chọn Chuyển khoản Ngân hàng (BANK_QR) -> Hiển thị hộp VietQR động
            string qrPreviewUrl = paymentMethod.GenerateQrImageUrl(finalTotal, "MPS THANH TOAN");
            if (!string.IsNullOrEmpty(qrPreviewUrl))
            {
                pnlBankQrPreview.Visible = true;
                imgVietQr.ImageUrl = qrPreviewUrl;
                litQrBankName.Text = paymentMethod.BankName;
                litQrAccountNo.Text = paymentMethod.AccountNumber;
                litQrAccountName.Text = paymentMethod.AccountName;
                litQrAmount.Text = string.Format("{0:N0} VNĐ", finalTotal);
                litQrTransferContent.Text = "MPS + Mã đơn (Tự động sau khi bấm Đặt hàng)";
            }
            else
            {
                pnlBankQrPreview.Visible = false;
            }
        }

        protected void rblPaymentMethod_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblCheckoutError.Visible = false;
            BindCheckoutSummary();
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            lblCheckoutError.Visible = false;

            List<CartItemDto> cartItems = _cartService.GetCart();
            if (cartItems == null || cartItems.Count == 0)
            {
                Response.Redirect("~/Cart.aspx");
                return;
            }

            try
            {
                int? currentUserId = null;
                if (Session["UserId"] != null)
                {
                    int parsedUserId;
                    if (int.TryParse(Session["UserId"].ToString(), out parsedUserId))
                    {
                        currentUserId = parsedUserId;
                    }
                }
                else if (Session["Username"] != null)
                {
                    string username = Session["Username"].ToString();
                    using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
                    {
                        User existingUser = db.Users.FirstOrDefault(u => u.Username == username);
                        if (existingUser != null)
                        {
                            currentUserId = existingUser.UserId;
                        }
                    }
                }

                CheckoutRequestDto request = new CheckoutRequestDto
                {
                    UserId = currentUserId,
                    CustomerName = txtCustomerName.Text,
                    Phone = txtPhone.Text,
                    Address = txtAddress.Text,
                    Note = txtNote.Text,
                    PaymentMethod = rblPaymentMethod.SelectedValue
                };

                // Gọi BLL lưu đơn hàng vào dbo.Orders và dbo.OrderDetails
                int createdOrderId = _orderService.PlaceOrder(request, cartItems);
                Order savedOrder = _orderService.GetOrderById(createdOrderId);

                IPaymentMethod paymentMethod = _orderService.GetPaymentMethod(request.PaymentMethod);
                decimal finalTotal = savedOrder != null ? savedOrder.TotalAmount : _cartService.GetSubTotalAmount();

                // Xóa giỏ hàng sau khi đặt hàng thành công
                _cartService.ClearCart();

                // Chuyển sang giao diện Hóa đơn xác nhận thành công
                pnlCheckoutForm.Visible = false;
                pnlOrderSuccess.Visible = true;

                litSuccessCustomer.Text = Server.HtmlEncode(request.CustomerName);
                litSuccessOrderId.Text = createdOrderId.ToString();
                litSuccessTotal.Text = string.Format("{0:N0} VNĐ", finalTotal);
                litSuccessInstruction.Text = Server.HtmlEncode(paymentMethod.GetPaymentInstruction(createdOrderId, finalTotal));

                string officialQrUrl = paymentMethod.GenerateQrImageUrl(finalTotal, "MPS" + createdOrderId);
                if (!string.IsNullOrEmpty(officialQrUrl))
                {
                    pnlSuccessQrBox.Visible = true;
                    imgSuccessQr.ImageUrl = officialQrUrl;
                }
                else
                {
                    pnlSuccessQrBox.Visible = false;
                }
            }
            catch (Exception ex)
            {
                lblCheckoutError.Text = "⚠ " + ex.Message;
                lblCheckoutError.Visible = true;
            }
        }
    }
}
