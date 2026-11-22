<%@ Page Title="Trang Chủ - MyPhoneShop" Language="C#" MasterPageFile="~/user.Master" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="web_bai2_masterpage._default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Nạp module CSS riêng cho Trang chủ & Thẻ sản phẩm -->
    <link href="<%= ResolveUrl("~/Content/product.css") %>?v=1" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- ========================================================================= -->
    <!-- 1. BANNER KHUYẾN MÃI TÂM ĐIỂM (Ảnh thật CellphoneS Hero Promo Slider)     -->
    <!-- ========================================================================= -->
    <div class="hero-promo-slider">
        <div class="slider-main-banner">
            <a href="<%= ResolveUrl("~/ProductDetail.aspx?id=1") %>" class="banner-link" title="Xem chi tiết iPhone 15 Pro Max 256GB">
                <img src="<%= ResolveUrl("~/Images/banner_main.png?v=3") %>" alt="Mừng Năm Học Mới - Đại Tiệc Công Nghệ" class="banner-img-main" />
            </a>
        </div>
        <div class="slider-sub-banners">
            <div class="sub-banner-item">
                <a href="<%= ResolveUrl("~/Default.aspx?cat=1&brand=2") %>" class="banner-link" title="Khám phá Điện thoại Samsung Galaxy AI">
                    <img src="<%= ResolveUrl("~/Images/banner_sub1.png?v=3") %>" alt="Ưu Đãi Galaxy AI" class="banner-img-sub" />
                </a>
            </div>
            <div class="sub-banner-item">
                <a href="<%= ResolveUrl("~/Default.aspx?cat=1&brand=3") %>" class="banner-link" title="Ưu đãi Điện thoại Xiaomi chính hãng">
                    <img src="<%= ResolveUrl("~/Images/banner_sub2.png?v=3") %>" alt="Ưu Đãi Thu Cũ Đổi Mới" class="banner-img-sub" />
                </a>
            </div>
        </div>
    </div>

    <h2 class="section-title"><asp:Literal ID="litTitle" runat="server" Mode="Encode" /></h2>

    <!-- ========================================================================= -->
    <!-- 3. LƯỚI THẺ SẢN PHẨM CHUẨN BÁN LẺ CELLPHONES                              -->
    <!-- ========================================================================= -->
    <div class="product-grid">
        <asp:Repeater ID="rptProducts" runat="server">
            <ItemTemplate>
                <div class="product-card">
                    <!-- Tem ưu đãi giảm giá & Trả góp 0% phong cách CellphoneS -->
                    <div class="card-badges">
                        <span class="badge-discount">Giảm 15%</span>
                        <span class="badge-installment">Trả góp 0%</span>
                    </div>

                    <img class="product-image"
                         src='<%# ResolveUrl("~/Images/" + Eval("Image")) %>'
                         alt='<%#: Eval("ProductName") %>'
                         onerror="this.src='<%= ResolveUrl("~/Images/no-image.svg") %>';" />

                    <span class="brand-badge"><%#: Eval("BrandName") %></span>
                    <h3 class="product-name" title='<%#: Eval("ProductName") %>'><%#: Eval("ProductName") %></h3>
                    <span class="product-price"><%# string.Format("{0:N0} đ", Eval("Price")) %></span>
                    <a class="btn-detail" href='<%# ResolveUrl("~/ProductDetail.aspx?id=" + Eval("ProductId")) %>'>Xem chi tiết</a>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <asp:Label ID="lblEmpty" runat="server" CssClass="empty-message" Visible="false"
               Text="Chưa có sản phẩm nào phù hợp." />
</asp:Content>
