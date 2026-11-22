<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="ProductList.aspx.cs" Inherits="web_bai2_masterpage.Admin.ProductList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .admin-table th { padding: 12px 8px; text-align: left; }
        .admin-table td { padding: 8px; border-bottom: 1px solid #e2e8f0; }
        .grid-pager table { margin: 0 auto; }
        .grid-pager td { padding: 4px 8px; }
        .grid-pager a, .grid-pager span { padding: 6px 12px; border: 1px solid #cbd5e1; border-radius: 4px; text-decoration: none; color: #1e293b; }
        .grid-pager span { background-color: #d70018; color: #fff; border-color: #d70018; font-weight: bold; }

    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2 class="section-title">Quản Lý Danh Sách Sản Phẩm</h2>

    <asp:Label ID="lblMessage" runat="server" CssClass="empty-message" Visible="false"></asp:Label>

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; 
                                background: #fff; padding: 12px; border-radius: 6px; 
                                box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
    <div>
        <asp:HyperLink ID="lnkAddNew" runat="server" NavigateUrl="~/Admin/AddProduct.aspx" 
            CssClass="btn-search-trigger" style="text-decoration: none; position: static;">
            + Thêm sản phẩm mới
        </asp:HyperLink>
        </div>
    
        <div style="display: flex; gap: 12px; align-items: center;">
        <label><strong>Loại:</strong></label>
        <asp:DropDownList ID="ddlCategory" runat="server" AutoPostBack="true" 
            OnSelectedIndexChanged="ddlFilter_SelectedIndexChanged" style="padding: 6px; border-radius: 4px;">
        </asp:DropDownList>
        <label><strong>Hãng:</strong></label>
        <asp:DropDownList ID="ddlBrand" runat="server" AutoPostBack="true" 
            OnSelectedIndexChanged="ddlFilter_SelectedIndexChanged" style="padding: 6px; border-radius: 4px;">
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
    style="background: #fff; border-radius: 6px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.1);"
    EmptyDataText="Không có sản phẩm nào phù hợp điều kiện lọc.">
    
        
    
    <HeaderStyle BackColor="#d70018" ForeColor="White" Font-Bold="True" Height="40px" />
    <RowStyle  Height="50px" />
    <AlternatingRowStyle BackColor="#f8fafc" />
    <PagerStyle HorizontalAlign="Center" Height="40px" CssClass="grid-pager" />
    

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
