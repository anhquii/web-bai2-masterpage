<%@ Page Title="Thêm Sản Phẩm" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="AddProduct.aspx.cs" Inherits="web_bai2_masterpage.Admin.AddProduct" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2 class="section-title">Thêm sản phẩm</h2>
    <table class="admin-form-table">
        <tr>
            <td>Tên sản phẩm</td>
            <td><asp:TextBox ID="txtName" runat="server" Width="300px"></asp:TextBox></td>
        </tr>

        <tr>
            <td>Giá (đồng)</td>
            <td><asp:TextBox ID="txtPrice" runat="server"></asp:TextBox></td>
        </tr>

        <tr>
            <td>Loại hàng</td>
            <td>
                <asp:DropDownList ID="ddlCategory" runat="server"></asp:DropDownList></td>
        </tr>

        <tr>
            <td>Hãng</td>
            <td>
                <asp:DropDownList ID="ddlBrand" runat="server"></asp:DropDownList></td>
        </tr>

        <tr>
            <td>Ảnh</td>
            <td>
                <asp:FileUpload ID="fuImage" runat="server" /></td>
        </tr>

        <tr>
            <td>Mô tả</td>
            <td>
                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Width="300px"></asp:TextBox></td>
        </tr>

        <tr>
            <td>&nbsp;</td>
            <td>
                <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click"/>
                <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
            </td>
        </tr>
    </table>
</asp:Content>
