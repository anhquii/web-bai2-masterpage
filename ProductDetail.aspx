<%@ Page Title="Chi Tiết Sản Phẩm - MyPhoneShop" Language="C#" MasterPageFile="~/user.Master" AutoEventWireup="true" CodeBehind="ProductDetail.aspx.cs" Inherits="web_bai2_masterpage.ProductDetail" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Label ID="lblMessage" runat="server" CssClass="empty-message" Visible="false"></asp:Label>

    <asp:Panel ID="pnlDetail" runat="server" CssClass="detail-card-wrapper">
        <div class="detail-layout-grid">
            <!-- Cột trái: Ảnh sản phẩm lớn -->
            <div class="detail-image-box">
                <asp:Image ID="imgProduct" runat="server" CssClass="detail-main-img" />
            </div>

            <!-- Cột phải: Khối thông tin chi tiết -->
            <div class="detail-info-box">
                <h1 class="detail-product-name">
                    <asp:Label ID="lblName" runat="server" />
                </h1>

                <div style="margin-bottom: 12px; display: flex; gap: 8px;">
                    <asp:Label ID="lblCategory" runat="server" CssClass="brand-badge" />
                    <asp:Label ID="lblBrand" runat="server" CssClass="brand-badge" />
                </div>

                <div class="detail-price-highlight">
                    <asp:Label ID="lblPrice" runat="server" />
                </div>

                <div style="font-size: 14px; color: #475569; line-height: 1.7; margin-bottom: 20px;">
                    <asp:Label ID="lblDescription" runat="server" />
                </div>

                <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="~/default.aspx" CssClass="btn-back-home">&larr; Quay lại danh sách sản phẩm</asp:HyperLink>
            </div>
        </div>
    </asp:Panel>

</asp:Content>
