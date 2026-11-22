<%@ Page Title="Đăng Ký Thành Viên - MyPhoneShop" Language="C#" MasterPageFile="~/user.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="web_bai2_masterpage.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Nạp module CSS riêng cho phân hệ Tài khoản (Đăng nhập / Đăng ký) -->
    <link href="<%= ResolveUrl("~/Content/auth.css") %>?v=1" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="register-wrapper">
        <div class="register-card">
            <h2 class="register-title">Đăng Ký Thành Viên</h2>
            <!-- Thông báo trạng thái -->
            <asp:Label ID="lblMessage" runat="server" CssClass="msg-alert" Visible="false"></asp:Label>
            <div class="form-group">
                <label for="txtUsername">Tên tài khoản:</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control-input" placeholder="Tên đăng nhập viết liền..."></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtPassword">Mật khẩu:</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control-input" placeholder="Tối thiểu 6 ký tự..."></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtConfirmPassword">Nhập lại mật khẩu:</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control-input" placeholder="Nhập lại mật khẩu trên..."></asp:TextBox>
            </div>
            <asp:Button ID="btnRegister" runat="server" Text="ĐĂNG KÝ TÀI KHOẢN" CssClass="btn-register-submit" OnClick="btnRegister_Click" />
            <div class="register-footer-link">
                Đã có tài khoản? <asp:HyperLink ID="lnkLogin" runat="server" NavigateUrl="~/Login.aspx">Đăng nhập</asp:HyperLink>
            </div>
        </div>
    </div>

</asp:Content>
