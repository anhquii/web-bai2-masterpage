<%@ Page Title="Đăng Nhập - MyPhoneShop" Language="C#" MasterPageFile="~/user.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="web_bai2_masterpage.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Nạp module CSS riêng cho phân hệ Tài khoản (Đăng nhập / Đăng ký) -->
    <link href="<%= ResolveUrl("~/Content/auth.css") %>?v=1" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="login-wrapper">
        <div class="login-card">
            <h2 class="login-title">Đăng Nhập</h2>
            <!-- Thông báo lỗi khi đăng nhập sai -->
            <asp:Label ID="lblMessage" runat="server" CssClass="msg-alert msg-error" Visible="false"></asp:Label>
            <div class="form-group">
                <label for="txtUsername">Tên đăng nhập:</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control-input" placeholder="Nhập username..."></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtPassword">Mật khẩu:</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control-input" placeholder="Nhập mật khẩu..."></asp:TextBox>
            </div>
            <div class="form-checkbox">
                <asp:CheckBox ID="chkRememberMe" runat="server" Text="Ghi nhớ đăng nhập" />
            </div>
            <asp:Button ID="btnLogin" runat="server" Text="ĐĂNG NHẬP" CssClass="btn-login-submit" OnClick="btnLogin_Click" />
            <div class="login-footer-link">
                Chưa có tài khoản? <asp:HyperLink ID="lnkRegister" runat="server" NavigateUrl="~/Register.aspx">Đăng ký ngay</asp:HyperLink>
            </div>
        </div>
    </div>

</asp:Content>
