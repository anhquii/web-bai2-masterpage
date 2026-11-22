<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="web_bai2_masterpage.Cart" %>

<!DOCTYPE html>
<html lang="vi">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Giỏ Hàng | MyPhoneShop</title>

    <!-- Kiến trúc Đa File CSS (Modular CSS): Bootstrap 5 + Layout + Cart & Checkout -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="<%= ResolveUrl("~/Content/bootstrap.min.css") %>" rel="stylesheet" type="text/css" />
    <link href="<%= ResolveUrl("~/Content/layout.css") %>?v=3" rel="stylesheet" type="text/css" />
    <link href="<%= ResolveUrl("~/Content/cart-checkout.css") %>?v=1" rel="stylesheet" type="text/css" />
</head>
<body class="shopee-cart-body">
    <form id="form1" runat="server" class="shopee-fullheight-form">

        <asp:ScriptManager ID="smCart" runat="server" />

        <!-- ========================================================================= -->
        <!-- 1. THANH TIỆN ÍCH MỎNG TRÊN CÙNG & HEADER GIỎ HÀNG KIỂU SHOPEE            -->
        <!-- ========================================================================= -->
        <div class="shopee-top-navbar">
            <div class="shopee-container shopee-top-navbar-inner">
                <div class="top-nav-left">
                    <a href="<%= ResolveUrl("~/Default.aspx") %>" class="top-nav-link">Trang Chủ MyPhoneShop</a>
                    <span class="top-nav-sep">|</span>
                    <span class="top-nav-text">Hệ thống bán lẻ Điện thoại &amp; Laptop chính hãng</span>
                </div>
                <div class="top-nav-right">
                    <span class="top-nav-text">Hotline: <strong>1800.2097</strong></span>
                    <span class="top-nav-sep">|</span>
                    <% if (Session["Username"] != null) { %>
                        <span class="top-nav-user"><%= Server.HtmlEncode(Session["Username"].ToString()) %></span>
                        <a href="<%= ResolveUrl("~/Logout.aspx") %>" class="top-nav-link">(Đăng xuất)</a>
                    <% } else { %>
                        <a href="<%= ResolveUrl("~/Register.aspx") %>" class="top-nav-link">Đăng Ký</a>
                        <span class="top-nav-sep">|</span>
                        <a href="<%= ResolveUrl("~/Login.aspx") %>" class="top-nav-link">Đăng Nhập</a>
                    <% } %>
                </div>
            </div>
        </div>

        <header class="shopee-cart-header">
            <div class="shopee-container shopee-cart-header-inner">
                <!-- Logo MyPhoneShop | Giỏ Hàng -->
                <div class="shopee-brand-block">
                    <a href="<%= ResolveUrl("~/Default.aspx") %>" class="shopee-logo-link">
                        <span class="shopee-logo-box">&#128722;</span>
                        <span class="shopee-logo-name">MyPhone<span>Shop</span></span>
                    </a>
                    <span class="shopee-brand-divider"></span>
                    <h1 class="shopee-cart-page-title">Giỏ Hàng</h1>
                </div>

                <!-- Thanh tìm kiếm viền đỏ chuẩn Shopee Cart Header -->
                <div class="shopee-header-search">
                    <input type="text" id="cartSearchInput" class="shopee-search-input" placeholder="Tìm sản phẩm, thương hiệu (iPhone, Samsung, Laptop...)" autocomplete="off" />
                    <button type="button" id="btnCartSearch" class="shopee-search-btn" title="Tìm kiếm">&#128269;</button>
                </div>
            </div>
        </header>

        <!-- ========================================================================= -->
        <!-- 2. NỘI DUNG GIỎ HÀNG FULL-WIDTH 1200PX THEO CẤU TRÚC SHOPEE              -->
        <!-- ========================================================================= -->
        <main class="shopee-container shopee-cart-main">
            <asp:UpdatePanel ID="upCart" runat="server" UpdateMode="Conditional">
                <ContentTemplate>

                    <!-- TRẠNG THÁI 1: KHI GIỎ HÀNG TRỐNG -->
                    <asp:Panel ID="pnlEmptyCart" runat="server" CssClass="shopee-empty-cart-card" Visible="false">
                        <div class="empty-cart-circle">&#128722;</div>
                        <h2 class="empty-cart-title">Giỏ hàng của bạn còn trống</h2>
                        <p class="empty-cart-desc">Hãy chọn các sản phẩm bên dưới hoặc quay lại trang chủ để mua sắm nhé!</p>
                        <a href="<%= ResolveUrl("~/Default.aspx") %>" class="shopee-checkout-btn" style="display: inline-flex; text-decoration: none;">
                            Mua Sắm Ngay
                        </a>
                    </asp:Panel>

                    <!-- TRẠNG THÁI 2: KHI GIỎ HÀNG CÓ SẢN PHẨM (BỐ CỤC NGANG ĐỒNG NHẤT SHOPEE) -->
                    <asp:Panel ID="pnlCartContent" runat="server">

                        <!-- KHỐI A: THANH TIÊU ĐỀ CỘT (Product | Unit Price | Quantity | Total Price | Actions) -->
                        <div class="shopee-cart-thead-bar">
                            <div class="col-sp-product">Sản Phẩm</div>
                            <div class="col-sp-price">Đơn Giá</div>
                            <div class="col-sp-qty">Số Lượng</div>
                            <div class="col-sp-total">Số Tiền</div>
                            <div class="col-sp-action">Thao Tác</div>
                        </div>

                        <!-- KHỐI B: THẺ CỬA HÀNG & DANH SÁCH SẢN PHẨM -->
                        <section class="shopee-shop-group-card">
                            <div class="shopee-shop-header">
                                <span class="shopee-mall-tag">Mall</span>
                                <strong class="shopee-shop-title">MyPhoneShop Official Store</strong>
                                <span class="shopee-shop-guarantee">Cam kết chính hãng VN/A | Bảo hành 12 tháng</span>
                            </div>

                            <div class="shopee-item-list">
                                <asp:Repeater ID="rptCart" runat="server" OnItemCommand="rptCart_ItemCommand">
                                    <ItemTemplate>
                                        <div class="shopee-cart-item-row">
                                            <!-- Cột 1: Ảnh + Tên + Nhãn khuyến mãi + Mã SP -->
                                            <div class="col-sp-product item-product-info">
                                                <a href='<%# ResolveUrl("~/ProductDetail.aspx?id=" + Eval("ProductId")) %>' class="item-thumb-link">
                                                    <img src='<%# ResolveUrl("~/Images/" + Eval("Image")) %>'
                                                         alt='<%# Eval("ProductName") %>'
                                                         class="item-thumb-img"
                                                         onerror="this.src='<%= ResolveUrl("~/Images/no-image.svg") %>';" />
                                                </a>
                                                <div class="item-text-wrap">
                                                    <a href='<%# ResolveUrl("~/ProductDetail.aspx?id=" + Eval("ProductId")) %>' class="item-name-link">
                                                        <%# Eval("ProductName") %>
                                                    </a>
                                                    <div class="item-promo-tags">
                                                        <span class="promo-tag-red">Chính hãng VN/A</span>
                                                        <span class="promo-tag-outline">Đổi mới 30 ngày</span>
                                                    </div>
                                                </div>
                                                <div class="item-variation-col">
                                                    <span class="variation-label">Phân loại hàng:</span>
                                                    <span class="variation-value">Mã SP #<%# Eval("ProductId") %></span>
                                                </div>
                                            </div>

                                            <!-- Cột 2: Đơn giá -->
                                            <div class="col-sp-price item-unit-price">
                                                <%# string.Format("{0:N0}₫", Eval("UnitPrice")) %>
                                            </div>

                                            <!-- Cột 3: Bộ tăng giảm số lượng [-][ 1 ][+] -->
                                            <div class="col-sp-qty item-qty-box">
                                                <div class="shopee-qty-control">
                                                    <asp:HiddenField ID="hfItemProductId" runat="server" Value='<%# Eval("ProductId") %>' />

                                                    <asp:LinkButton ID="btnDecreaseQty" runat="server"
                                                        CommandName="Decrease"
                                                        CommandArgument='<%# Eval("ProductId") %>'
                                                        CssClass="sp-qty-btn"
                                                        ToolTip="Giảm 1">&minus;</asp:LinkButton>

                                                    <asp:TextBox ID="txtItemQty" runat="server"
                                                        Text='<%# Eval("Quantity") %>'
                                                        CssClass="sp-qty-input"
                                                        AutoPostBack="true"
                                                        OnTextChanged="txtItemQty_TextChanged" />

                                                    <asp:LinkButton ID="btnIncreaseQty" runat="server"
                                                        CommandName="Increase"
                                                        CommandArgument='<%# Eval("ProductId") %>'
                                                        CssClass="sp-qty-btn"
                                                        ToolTip="Tăng 1">+</asp:LinkButton>
                                                </div>
                                            </div>

                                            <!-- Cột 4: Số tiền (Thành tiền) -->
                                            <div class="col-sp-total item-total-price">
                                                <%# string.Format("{0:N0}₫", Eval("SubTotal")) %>
                                            </div>

                                            <!-- Cột 5: Thao tác (Xóa / Xem chi tiết) -->
                                            <div class="col-sp-action item-action-links">
                                                <asp:LinkButton ID="btnRemoveItem" runat="server"
                                                    CommandName="Remove"
                                                    CommandArgument='<%# Eval("ProductId") %>'
                                                    CssClass="sp-delete-link">Xóa</asp:LinkButton>
                                                <a href='<%# ResolveUrl("~/ProductDetail.aspx?id=" + Eval("ProductId")) %>' class="sp-similar-link">
                                                    Xem chi tiết
                                                </a>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>

                            <div class="shopee-shop-footer-voucher">
                                <span class="voucher-truck-badge">Miễn phí vận chuyển:</span>
                                <span class="voucher-desc-text">Miễn phí giao hàng toàn quốc cho đơn từ <strong>5.000.000₫</strong> hoặc khi chọn thanh toán <strong>Chuyển khoản VietQR</strong></span>
                            </div>
                        </section>

                        <!-- KHỐI C: THANH TỔNG THANH TOÁN & NÚT MUA HÀNG NEO DƯỚI ĐÁY -->
                        <div class="shopee-sticky-checkout-bar">
                            <div class="sticky-bar-left">
                                <a href="<%= ResolveUrl("~/Default.aspx") %>" class="sp-bar-action-link">+ Chọn thêm sản phẩm khác</a>
                                <span class="sp-bar-sep">|</span>
                                <asp:LinkButton ID="btnClearCart" runat="server"
                                    CssClass="sp-bar-clear-link"
                                    OnClick="btnClearCart_Click"
                                    OnClientClick="return confirm('Bạn có chắc muốn xóa toàn bộ sản phẩm trong giỏ hàng không?');">
                                    Xóa tất cả giỏ hàng
                                </asp:LinkButton>
                            </div>

                            <div class="sticky-bar-right">
                                <div class="sp-total-summary">
                                    <span class="sp-total-label">Tổng thanh toán (<asp:Literal ID="litTotalQuantity" runat="server" Text="0" /> sản phẩm):</span>
                                    <strong class="sp-total-amount">
                                        <asp:Literal ID="litSubTotalAmount" runat="server" Text="0 đ" />
                                    </strong>
                                </div>

                                <asp:HyperLink ID="lnkProceedCheckout" runat="server"
                                    NavigateUrl="~/Checkout.aspx"
                                    CssClass="shopee-checkout-btn">
                                    Mua Hàng
                                </asp:HyperLink>
                            </div>
                        </div>

                    </asp:Panel>

                    <!-- KHỐI D: "CÓ THỂ BẠN CŨNG THÍCH" (GIỐNG SHOPEE CART - GIÚP TRANG LUÔN ĐẦY ĐẶN & MUA NHANH) -->
                    <section class="shopee-recommend-section">
                        <div class="recommend-header-line">
                            <h3 class="recommend-heading">CÓ THỂ BẠN CŨNG THÍCH</h3>
                            <a href="<%= ResolveUrl("~/Default.aspx") %>" class="recommend-view-all">Xem tất cả</a>
                        </div>

                        <div class="shopee-recommend-grid">
                            <asp:Repeater ID="rptSuggestedProducts" runat="server" OnItemCommand="rptSuggestedProducts_ItemCommand">
                                <ItemTemplate>
                                    <div class="sp-rec-card">
                                        <a href='<%# ResolveUrl("~/ProductDetail.aspx?id=" + Eval("ProductId")) %>' class="sp-rec-img-wrap">
                                            <span class="sp-rec-mall-badge">Mall</span>
                                            <img src='<%# ResolveUrl("~/Images/" + Eval("Image")) %>'
                                                 alt='<%#: Eval("ProductName") %>'
                                                 class="sp-rec-img"
                                                 onerror="this.src='<%= ResolveUrl("~/Images/no-image.svg") %>';" />
                                        </a>
                                        <div class="sp-rec-body">
                                            <a href='<%# ResolveUrl("~/ProductDetail.aspx?id=" + Eval("ProductId")) %>' class="sp-rec-name" title='<%#: Eval("ProductName") %>'>
                                                <%#: Eval("ProductName") %>
                                            </a>
                                            <div class="sp-rec-bottom">
                                                <span class="sp-rec-price"><%# string.Format("{0:N0}₫", Eval("Price")) %></span>
                                                <asp:LinkButton ID="btnQuickAdd" runat="server"
                                                    CommandName="QuickAdd"
                                                    CommandArgument='<%# Eval("ProductId") %>'
                                                    CssClass="sp-rec-add-btn"
                                                    ToolTip="Thêm nhanh vào giỏ hàng">+ Giỏ hàng</asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </section>

                </ContentTemplate>
            </asp:UpdatePanel>
        </main>

        <!-- ========================================================================= -->
        <!-- 3. FOOTER GỌN SÁT ĐÁY TRANG (KHÔNG DƯ KHOẢNG TRẮNG)                       -->
        <!-- ========================================================================= -->
        <footer class="shopee-compact-footer">
            <div class="shopee-container">
                &copy; <%= DateTime.Now.Year %> <strong>MyPhoneShop</strong> — Hệ Thống Phân Phối Điện Thoại &amp; Laptop Chính Hãng | Hotline: <strong>1800.2097</strong>
            </div>
        </footer>

        <script type="text/javascript">
            (function () {
                var input = document.getElementById('cartSearchInput');
                var btn = document.getElementById('btnCartSearch');
                var searchUrl = '<%= ResolveUrl("~/SearchAjax.aspx?q=") %>';

                function triggerSearch() {
                    if (!input) return;
                    var kw = input.value.trim();
                    window.location.href = kw ? (searchUrl + encodeURIComponent(kw)) : '<%= ResolveUrl("~/SearchAjax.aspx") %>';
                }

                if (btn) btn.addEventListener('click', triggerSearch);
                if (input) {
                    input.addEventListener('keydown', function (e) {
                        if (e.keyCode === 13) {
                            e.preventDefault();
                            triggerSearch();
                        }
                    });
                }
            })();
        </script>
    </form>
</body>
</html>
