<%@ Page Title="Quản Lý Sản Phẩm" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="ProductList.aspx.cs" Inherits="web_bai2_masterpage.Admin.ProductList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2 class="section-title">Quản Lý Danh Sách Sản Phẩm</h2>

    <asp:Label ID="lblMessage" runat="server" CssClass="empty-message" Visible="false"></asp:Label>

    <div class="admin-toolbar">
        <div>
            <asp:HyperLink ID="lnkAddNew" runat="server" NavigateUrl="~/Admin/AddProduct.aspx" CssClass="btn-add-new">
                + Thêm sản phẩm mới
            </asp:HyperLink>
        </div>

        <div class="admin-filter-group">
            <label><strong>Loại:</strong></label>
            <asp:DropDownList ID="ddlCategory" runat="server" AutoPostBack="true" CssClass="admin-select"
                OnSelectedIndexChanged="ddlFilter_SelectedIndexChanged">
            </asp:DropDownList>
            <label><strong>Hãng:</strong></label>
            <asp:DropDownList ID="ddlBrand" runat="server" AutoPostBack="true" CssClass="admin-select"
                OnSelectedIndexChanged="ddlFilter_SelectedIndexChanged">
            </asp:DropDownList>
        </div>
    </div>

    <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" 
        DataKeyNames="ProductId"
        AllowPaging="True" PageSize="8"
        OnPageIndexChanging="gvProducts_PageIndexChanging"
        OnRowDeleting="gvProducts_RowDeleting"
        Width="100%" CellPadding="8" GridLines="None"
        CssClass="admin-table"
        EmptyDataText="Không có sản phẩm nào phù hợp điều kiện lọc.">
    
        <HeaderStyle BackColor="#d70018" ForeColor="White" Font-Bold="True" Height="42px" />
        <RowStyle Height="52px" />
        <AlternatingRowStyle BackColor="#f8fafc" />
        <PagerStyle HorizontalAlign="Center" Height="44px" CssClass="grid-pager" />

        <Columns>
            <%-- Cột 1: Mã ID (Dùng BoundField lấy trực tiếp từ thuộc tính ProductId) --%>
            <asp:BoundField DataField="ProductId" HeaderText="Mã" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="60px" />
            <%-- Cột 2: Ảnh sản phẩm (Dùng TemplateField vì cần thẻ <img>) --%>
            <asp:TemplateField HeaderText="Hình Ảnh" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="80px">
                <ItemTemplate>
                    <asp:Image ID="imgThumb" runat="server" Width="50px" Height="50px" style="object-fit: contain;"
                        ImageUrl='<%# "~/Images/" + (Eval("Image") ?? "no-image.svg") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <%-- Cột 3: Tên sản phẩm --%>
            <asp:TemplateField HeaderText="Tên Sản Phẩm">
                <ItemTemplate>
                    <strong><%#: Eval("ProductName") %></strong>
                </ItemTemplate>
            </asp:TemplateField>
            <%-- Cột 4: Giá bán (Định dạng tiền tệ VNĐ: {0:N0} đ) --%>
            <asp:BoundField DataField="Price" HeaderText="Giá Bán" DataFormatString="{0:N0} đ" 
                ItemStyle-ForeColor="#d70018" ItemStyle-Font-Bold="True" ItemStyle-Width="120px" ItemStyle-HorizontalAlign="Right" />
            <%-- Cột 5: Tên Loại hàng --%>
            <asp:BoundField DataField="CategoryName" HeaderText="Loại" ItemStyle-Width="110px" ItemStyle-HorizontalAlign="Center" />
            <%-- Cột 6: Tên Hãng --%>
            <asp:BoundField DataField="BrandName" HeaderText="Hãng" ItemStyle-Width="100px" ItemStyle-HorizontalAlign="Center" />
            <%-- Cột 7: Thao tác Sửa / Xóa --%>
            <asp:TemplateField HeaderText="Hành Động" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="140px">
                <ItemTemplate>
                    <!-- Nút Sửa: Dẫn thẳng sang trang EditProduct kèm theo id trên URL -->
                    <asp:HyperLink ID="lnkEdit" runat="server" 
                        NavigateUrl='<%# "~/Admin/EditProduct.aspx?id=" + Eval("ProductId") %>' 
                        Text="Sửa" style="color: #0284c7; font-weight: 600; text-decoration: none; margin-right: 12px;" />
                    <!-- Nút Xóa: CommandName="Delete" sẽ kích hoạt sự kiện OnRowDeleting của GridView -->
                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" Text="Xóa"
                        ForeColor="#dc2626" Font-Bold="true" style="text-decoration: none;"
                        OnClientClick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này không? Thao tác này không thể hoàn tác!');" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</asp:Content>
