<%@ Page Title="" Language="C#" MasterPageFile="~/user.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="web_bai2_masterpage.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .register-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 15px;
        }
        .register-card {
            background: #ffffff;
            width: 100%;
            max-width: 440px;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
        }
        .register-title {
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
        .btn-register-submit {
            width: 100%;
            padding: 12px;
            background-color: #d70018;
            color: #ffffff;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            margin-top: 10px;
            transition: background-color 0.2s;
        }
        .btn-register-submit:hover {
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
        .msg-success {
            background-color: #f0fdf4;
            color: #16a34a;
            border: 1px solid #bbf7d0;
        }
        .register-footer-link {
            text-align: center;
            margin-top: 18px;
            font-size: 14px;
            color: #64748b;
        }
        .register-footer-link a {
            color: #d70018;
            font-weight: 600;
            text-decoration: none;
        }
    </style>
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
