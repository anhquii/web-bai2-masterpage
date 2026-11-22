<%@ Page Title="" Language="C#" MasterPageFile="~/user.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="web_bai2_masterpage.Login" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .login-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 15px;
        }
        .login-card {
            background: #ffffff;
            width: 100%;
            max-width: 420px;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
        }
        .login-title {
            text-align: center;
            font-size: 22px;
            font-weight: 700;
            color: #d70018;
            margin-bottom: 20px;
            text-transform: uppercase;
        }
        .form-group {
            margin-bottom: 16px;
        }
        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            font-size: 14px;
            color: #334155;
        }
        .form-control-input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 14px;
            box-sizing: border-box;
            outline: none;
            transition: border-color 0.2s;
        }
        .form-control-input:focus {
            border-color: #d70018;
        }
        .form-checkbox {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: #475569;
            margin-bottom: 20px;
        }
        .btn-login-submit {
            width: 100%;
            padding: 12px;
            background-color: #d70018;
            color: #ffffff;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .btn-login-submit:hover {
            background-color: #b90014;
        }
        .msg-alert {
            display: block;
            padding: 10px;
            border-radius: 6px;
            font-size: 14px;
            margin-bottom: 16px;
            text-align: center;
        }
        .msg-error {
            background-color: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }
        .login-footer-link {
            text-align: center;
            margin-top: 18px;
            font-size: 14px;
            color: #64748b;
        }
        .login-footer-link a {
            color: #d70018;
            font-weight: 600;
            text-decoration: none;
        }
        .login-footer-link a:hover {
            text-decoration: underline;
        }
    </style>

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
