<%@ Page Title="" Language="C#" MasterPageFile="~/user.Master" AutoEventWireup="true" CodeBehind="Search.aspx.cs" Inherits="web_bai2_masterpage.Search" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2 class="section-title">Tìm kiếm sản phẩm</h2>

    <p>
        <asp:TextBox ID="txtKeyword" runat="server" Width="300px"></asp:TextBox>
        <asp:Button ID="btnSearch" runat="server" Text="TÌm" OnClick="btnSearch_Click" />
    </p>
    
    <asp:GridView ID="gvResults" runat="server" AllowPaging="True" AutoGenerateColumns="False" EmptyDataText="Không tìm thấy sản phẩm nào" OnPageIndexChanging="gvResults_PageIndexChanging" PageSize="5" ShowHeader="False">
        <Columns>
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:Image ID="imgProduct" runat="server" ImageUrl='<%# "~/Images/" + Eval("Image") %>' Width="100px" />
                </ItemTemplate>
                <ItemStyle Width="120px" />
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:HyperLink ID="lnkName" runat="server" NavigateUrl='<%# "~/ProductDetail.aspx?id=" + Eval("ProductId") %>' Text='<%# Eval("ProductName") %>'></asp:HyperLink>
                    <br />
                    <asp:Label ID="lblPrice" runat="server" CssClass="product-price" Text='<%# Eval("Price", "{0:N0} đ") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>


</asp:Content>
