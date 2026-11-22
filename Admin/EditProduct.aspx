<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="EditProduct.aspx.cs" Inherits="web_bai2_masterpage.Admin.EditProduct" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2 class="section-title">Sửa sản phẩm</h2>
<table>
    <tr>
        <td>Mã sản phẩm</td>
        <td>
            <asp:Label ID="lblProductId" runat="server" ></asp:Label>

        </td>
    </tr>

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
            <asp:DropDownList ID="ddlCategory" runat="server" DataSourceID="LinqDataSource2" DataTextField="CategoryName" DataValueField="CategoryId"></asp:DropDownList>
            <asp:LinqDataSource ID="LinqDataSource2" runat="server" ContextTypeName="web_bai2_masterpage.MyPhoneShopDataContext" EntityTypeName="" Select="new (CategoryId, CategoryName)" TableName="Categories">
            </asp:LinqDataSource>
        </td>
    </tr>

    <tr>
        <td>Hãng</td>
        <td>
            <asp:DropDownList ID="ddlBrand" runat="server" DataSourceID="LinqDataSource1" DataTextField="BrandName" DataValueField="BrandId"></asp:DropDownList>
            <asp:LinqDataSource ID="LinqDataSource1" runat="server" ContextTypeName="web_bai2_masterpage.MyPhoneShopDataContext" EntityTypeName="" Select="new (BrandId, BrandName)" TableName="Brands">
            </asp:LinqDataSource>
        </td>
    </tr>

    <tr>
        <td>Ảnh</td>
        <td>
            <asp:Image ID="imgCurrent" runat="server" Width="120px" />
            <asp:FileUpload ID="fuImage" runat="server" />
        </td>
        
    </tr>

    <tr>
        <td>Mô tả</td>
        <td>
            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Width="300px"></asp:TextBox></td>
    </tr>

    <tr>
        <td>&nbsp;</td>
        <td>
            <asp:Button ID="btnSave" runat="server" Text="Cập nhật" OnClick="btnSave_Click"/>
            <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        </td>
    </tr>



</table>

</asp:Content>
