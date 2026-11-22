<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="web_bai2_masterpage.Checkout" %>

<!DOCTYPE html>
<html lang="vi">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Thanh Toán Đơn Hàng | MyPhoneShop</title>

    <!-- Kiến trúc Đa File CSS (Modular CSS): Bootstrap 5 + Layout + Cart & Checkout -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="<%= ResolveUrl("~/Content/bootstrap.min.css") %>" rel="stylesheet" type="text/css" />
    <link href="<%= ResolveUrl("~/Content/layout.css") %>?v=3" rel="stylesheet" type="text/css" />
    <link href="<%= ResolveUrl("~/Content/cart-checkout.css") %>?v=1" rel="stylesheet" type="text/css" />
</head>
<body class="checkout-standalone-body">
    <form id="form1" runat="server" class="shopee-fullheight-form">

        <!-- ========================================================================= -->
        <!-- 1. HEADER TỐI GIẢN CHUẨN SHOPEE CHECKOUT (Logo | Thanh Toán)              -->
        <!-- ========================================================================= -->
        <header class="checkout-top-header">
            <div class="checkout-container checkout-header-inner">
                <div class="checkout-brand-group">
                    <a href="<%= ResolveUrl("~/Default.aspx") %>" class="checkout-brand-logo">
                        <span class="checkout-logo-icon">&#9776;</span>
                        <span class="checkout-logo-text">MyPhone<span>Shop</span></span>
                    </a>
                    <span class="checkout-header-divider"></span>
                    <h1 class="checkout-page-title">Thanh Toán</h1>
                </div>

                <div class="checkout-header-right">
                    <span class="checkout-secure-badge">Thanh toán bảo mật 100%</span>
                    <a href="<%= ResolveUrl("~/Cart.aspx") %>" class="checkout-back-cart-link">&larr; Quay lại Giỏ hàng</a>
                </div>
            </div>
        </header>

        <!-- ========================================================================= -->
        <!-- 2. KHUNG NỘI DUNG CHÍNH RỘNG 1180PX (2 CỘT NGANG SONG SONG 60% - 40%)     -->
        <!-- ========================================================================= -->
        <main class="checkout-container checkout-main-area">

            <!-- Thông báo lỗi nếu bỏ trống thông tin người nhận -->
            <asp:Label ID="lblCheckoutError" runat="server" CssClass="checkout-error-alert" Visible="false"></asp:Label>

            <!-- KHỐI 1: BIỂU MẪU ĐẶT HÀNG 2 CỘT NGANG -->
            <asp:Panel ID="pnlCheckoutForm" runat="server">
                <div class="checkout-two-col-layout">

                    <!-- CỘT TRÁI (60%): ĐỊA CHỈ NHẬN HÀNG & PHƯƠNG THỨC THANH TOÁN -->
                    <div class="checkout-left-column">

                        <!-- Thẻ 1: Địa chỉ nhận hàng (Có viền phong bì sọc đỏ-xanh chuẩn Shopee) -->
                        <section class="checkout-box-card address-card">
                            <div class="shopee-envelope-stripe"></div>
                            <div class="checkout-box-body">
                                <h2 class="checkout-section-title">
                                    Địa Chỉ Nhận Hàng
                                </h2>

                                <div class="form-row-two-cols">
                                    <div class="form-group-item">
                                        <label class="form-label">Họ và tên người nhận <span class="required-star">*</span></label>
                                        <asp:TextBox ID="txtCustomerName" runat="server" CssClass="form-control-input" placeholder="Nhập họ và tên (VD: Nguyễn Văn A)" />
                                    </div>

                                    <div class="form-group-item">
                                        <label class="form-label">Số điện thoại liên hệ <span class="required-star">*</span></label>
                                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control-input" placeholder="Nhập số điện thoại (VD: 0987654321)" />
                                    </div>
                                </div>

                                <div class="form-group-item">
                                    <label class="form-label">Địa chỉ nhận hàng chi tiết <span class="required-star">*</span></label>
                                    <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control-input" placeholder="Số nhà, tên đường, Phường/Xã, Quận/Huyện, Tỉnh/Thành phố" />
                                </div>

                                <div class="form-group-item" style="margin-bottom: 0;">
                                    <label class="form-label">Lời nhắn cho cửa hàng / Shipper (Tùy chọn)</label>
                                    <asp:TextBox ID="txtNote" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control-input" placeholder="Ví dụ: Giao trong giờ hành chính, gọi trước khi giao..." />
                                </div>
                            </div>
                        </section>

                        <!-- Thẻ 2: Phương thức thanh toán (Đa hình IPaymentMethod: COD / BANK_QR) -->
                        <section class="checkout-box-card" style="margin-top: 20px;">
                            <div class="checkout-box-body">
                                <h2 class="checkout-section-title">
                                    Phương Thức Thanh Toán
                                </h2>

                                <asp:RadioButtonList ID="rblPaymentMethod" runat="server"
                                    AutoPostBack="true"
                                    OnSelectedIndexChanged="rblPaymentMethod_SelectedIndexChanged"
                                    CssClass="shopee-payment-options"
                                    RepeatLayout="Flow">
                                    <asp:ListItem Value="COD" Selected="True">
                                        Thanh toán tiền mặt khi nhận hàng (Ship COD — Miễn phí vận chuyển cho đơn từ 5.000.000đ)
                                    </asp:ListItem>
                                    <asp:ListItem Value="BANK_QR">
                                        Chuyển khoản Ngân hàng qua mã VietQR (Ưu đãi Miễn phí vận chuyển 0đ cho mọi đơn hàng)
                                    </asp:ListItem>
                                </asp:RadioButtonList>

                                <!-- Hộp VietQR Napas247 động khi chọn BANK_QR -->
                                <asp:Panel ID="pnlBankQrPreview" runat="server" CssClass="vietqr-preview-box" Visible="false">
                                    <div class="vietqr-header-badge">CỔNG THANH TOÁN VIETQR NAPAS 247 — TỰ ĐỘNG ĐIỀN SỐ TIỀN &amp; NỘI DUNG</div>
                                    <div class="vietqr-body-grid">
                                        <div class="vietqr-img-col">
                                            <asp:Image ID="imgVietQr" runat="server" CssClass="vietqr-code-image" AlternateText="Mã VietQR Thanh Toán" />
                                        </div>
                                        <div class="vietqr-info-col">
                                            <div class="qr-info-row">
                                                <span>Ngân hàng thụ hưởng:</span>
                                                <strong><asp:Literal ID="litQrBankName" runat="server" /></strong>
                                            </div>
                                            <div class="qr-info-row">
                                                <span>Số tài khoản:</span>
                                                <strong class="qr-highlight-code"><asp:Literal ID="litQrAccountNo" runat="server" /></strong>
                                            </div>
                                            <div class="qr-info-row">
                                                <span>Chủ tài khoản:</span>
                                                <strong><asp:Literal ID="litQrAccountName" runat="server" /></strong>
                                            </div>
                                            <div class="qr-info-row">
                                                <span>Số tiền chuyển khoản:</span>
                                                <strong class="qr-highlight-amount"><asp:Literal ID="litQrAmount" runat="server" /></strong>
                                            </div>
                                            <div class="qr-info-row">
                                                <span>Nội dung chuyển khoản:</span>
                                                <strong class="qr-highlight-code"><asp:Literal ID="litQrTransferContent" runat="server" /></strong>
                                            </div>
                                            <p class="qr-note-text">
                                                * Mở ứng dụng Ngân hàng hoặc MoMo quét mã QR để tự động nhập đúng số tiền thanh toán.
                                            </p>
                                        </div>
                                    </div>
                                </asp:Panel>
                            </div>
                        </section>

                    </div>

                    <!-- CỘT PHẢI (40% - NEO CỐ ĐỊNH STICKY): TÓM TẮT ĐƠN HÀNG & NÚT ĐẶT HÀNG -->
                    <aside class="checkout-right-column">
                        <section class="checkout-box-card checkout-sticky-summary">
                            <div class="checkout-box-body">
                                <h2 class="checkout-section-title">
                                    Sản Phẩm Đặt Mua (<asp:Literal ID="litSummaryCount" runat="server" /> SP)
                                </h2>

                                <div class="checkout-items-scroll">
                                    <asp:Repeater ID="rptOrderItems" runat="server">
                                        <ItemTemplate>
                                            <div class="checkout-item-row">
                                                <img src='<%# ResolveUrl("~/Images/" + Eval("Image")) %>'
                                                     alt='<%# Eval("ProductName") %>'
                                                     class="checkout-item-thumb"
                                                     onerror="this.src='<%= ResolveUrl("~/Images/no-image.svg") %>';" />
                                                <div class="checkout-item-info">
                                                    <div class="checkout-item-name"><%# Eval("ProductName") %></div>
                                                    <div class="checkout-item-qty">Đơn giá: <%# string.Format("{0:N0} đ", Eval("UnitPrice")) %> &times; <strong><%# Eval("Quantity") %></strong></div>
                                                </div>
                                                <div class="checkout-item-subtotal">
                                                    <%# string.Format("{0:N0} đ", Eval("SubTotal")) %>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>

                                <div class="checkout-totals-box">
                                    <div class="summary-line">
                                        <span>Tổng tiền hàng:</span>
                                        <strong><asp:Literal ID="litCheckoutSubTotal" runat="server" /></strong>
                                    </div>
                                    <div class="summary-line">
                                        <span>Phí vận chuyển:</span>
                                        <strong class="shipping-fee-text"><asp:Literal ID="litShippingFee" runat="server" /></strong>
                                    </div>
                                    <div class="summary-line summary-grand-total">
                                        <span>Tổng thanh toán:</span>
                                        <strong class="final-total-price"><asp:Literal ID="litFinalTotal" runat="server" /></strong>
                                    </div>
                                </div>

                                <asp:Button ID="btnPlaceOrder" runat="server"
                                    Text="ĐẶT HÀNG NGAY"
                                    CssClass="btn-shopee-buy-now btn-place-order-full"
                                    OnClick="btnPlaceOrder_Click" />

                                <p class="checkout-terms-note">
                                    Nhấn "Đặt Hàng Ngay" đồng nghĩa với việc bạn đồng ý tuân theo Chính sách mua hàng của MyPhoneShop.
                                </p>
                            </div>
                        </section>
                    </aside>

                </div>
            </asp:Panel>

            <!-- KHỐI 2: HÓA ĐƠN XÁC NHẬN ĐẶT HÀNG THÀNH CÔNG -->
            <asp:Panel ID="pnlOrderSuccess" runat="server" CssClass="order-success-card" Visible="false">
                <div class="success-check-badge">&#10004;</div>
                <h2 class="success-heading">ĐẶT HÀNG THÀNH CÔNG!</h2>
                <p class="success-subtext">
                    Cảm ơn quý khách <strong><asp:Literal ID="litSuccessCustomer" runat="server" /></strong> đã tin tưởng mua sắm tại <strong>MyPhoneShop</strong>.
                </p>

                <div class="success-order-meta">
                    <div>Mã đơn hàng: <strong class="order-id-pill">#<asp:Literal ID="litSuccessOrderId" runat="server" /></strong></div>
                    <div>Tổng thanh toán: <strong class="final-total-price"><asp:Literal ID="litSuccessTotal" runat="server" /></strong></div>
                </div>

                <div class="success-instruction-box">
                    <asp:Literal ID="litSuccessInstruction" runat="server" />
                </div>

                <!-- Nếu khách chọn BANK_QR thì hiện mã VietQR với đúng mã đơn hàng #MPS{OrderId} -->
                <asp:Panel ID="pnlSuccessQrBox" runat="server" CssClass="success-qr-container" Visible="false">
                    <h4>Quét mã VietQR bên dưới để hoàn tất chuyển khoản cho đơn hàng:</h4>
                    <asp:Image ID="imgSuccessQr" runat="server" CssClass="vietqr-code-image" />
                </asp:Panel>
            </asp:Panel>

        </main>

        <!-- ========================================================================= -->
        <!-- 3. FOOTER TỐI GIẢN CHO TRANG THANH TOÁN                                   -->
        <!-- ========================================================================= -->
        <footer class="shopee-compact-footer">
            <div class="checkout-container">
                &copy; <%= DateTime.Now.Year %> <strong>MyPhoneShop</strong> — Hệ Thống Phân Phối Điện Thoại &amp; Laptop Chính Hãng | Hotline: <strong>1800.2097</strong>
            </div>
        </footer>

    </form>
</body>
</html>
