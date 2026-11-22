<%@ Page Title="Chi Tiết Sản Phẩm - MyPhoneShop" Language="C#" MasterPageFile="~/user.Master" AutoEventWireup="true" CodeBehind="ProductDetail.aspx.cs" Inherits="web_bai2_masterpage.ProductDetail" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Nạp module CSS riêng cho Trang chi tiết sản phẩm & cụm nút mua hàng Shopee -->
    <link href="<%= ResolveUrl("~/Content/product.css") %>?v=3" rel="stylesheet" type="text/css" />
    <link href="<%= ResolveUrl("~/Content/cart-checkout.css") %>?v=1" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Label ID="lblMessage" runat="server" CssClass="empty-message" Visible="false"></asp:Label>
    <asp:Label ID="lblCartSuccess" runat="server" CssClass="cart-toast-success" Visible="false"></asp:Label>

    <asp:Panel ID="pnlDetail" runat="server" CssClass="detail-card-wrapper">
        <div class="detail-layout-grid">
            <!-- Cột trái: Ảnh sản phẩm lớn -->
            <div class="detail-image-box">
                <asp:Image ID="imgProduct" runat="server" CssClass="detail-main-img" />
            </div>

            <!-- Cột phải: Khối thông tin chi tiết & Nút Mua Hàng kiểu Shopee -->
            <div class="detail-info-box">
                <h1 class="detail-product-name">
                    <asp:Label ID="lblName" runat="server" />
                </h1>

                <div class="detail-badges-row">
                    <asp:Label ID="lblCategory" runat="server" CssClass="brand-badge" />
                    <asp:Label ID="lblBrand" runat="server" CssClass="brand-badge" />
                </div>

                <div class="detail-price-highlight">
                    <asp:Label ID="lblPrice" runat="server" />
                </div>

                <div class="detail-description-box">
                    <asp:Label ID="lblDescription" runat="server" />
                </div>

                <!-- KHỐI CHỌN SỐ LƯỢNG & 2 NÚT MUA HÀNG CHUẨN SHOPEE -->
                <div class="shopee-purchase-section">
                    <div class="quantity-picker-row">
                        <span class="quantity-label">Số Lượng:</span>
                        <div class="qty-control-group">
                            <button type="button" class="qty-step-btn" onclick="changeDetailQty(-1)">&minus;</button>
                            <asp:TextBox ID="txtQuantity" runat="server" Text="1" CssClass="qty-input-box" ClientIDMode="Static" />
                            <button type="button" class="qty-step-btn" onclick="changeDetailQty(1)">+</button>
                        </div>
                        <span class="stock-status-badge">&#10004; Sẵn hàng chính hãng</span>
                    </div>

                    <div class="shopee-action-buttons">
                        <asp:Button ID="btnAddToCart" runat="server"
                            Text="&#128722; Thêm Vào Giỏ Hàng"
                            CssClass="btn-shopee-add-cart"
                            OnClick="btnAddToCart_Click" />

                        <asp:Button ID="btnBuyNow" runat="server"
                            Text="Mua Ngay"
                            CssClass="btn-shopee-buy-now"
                            OnClick="btnBuyNow_Click" />
                    </div>
                </div>

                <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="~/default.aspx" CssClass="btn-back-home">&larr; Quay lại danh sách sản phẩm</asp:HyperLink>
            </div>
        </div>
    </asp:Panel>

    <script type="text/javascript">
        function changeDetailQty(delta) {
            var input = document.getElementById('txtQuantity');
            if (!input) return;
            var current = parseInt(input.value, 10);
            if (isNaN(current) || current < 1) current = 1;
            var next = current + delta;
            if (next < 1) next = 1;
            if (next > 99) next = 99;
            input.value = next;
        }
    </script>

</asp:Content>
