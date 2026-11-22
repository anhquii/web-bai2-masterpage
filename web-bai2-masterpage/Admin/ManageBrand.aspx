<%@ Page Title="Quản Lý Thương Hiệu" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="ManageBrand.aspx.cs" Inherits="web_bai2_masterpage.Admin.ManageBrand" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2 class="section-title">Quản Lý Thương Hiệu (Brands)</h2>
    <!-- Thông báo lỗi hoặc thành công -->
    <asp:Label ID="lblMessage" runat="server" Visible="false" 
        style="display:block; padding: 10px; margin-bottom: 15px; border-radius: 6px; font-weight: 600;"></asp:Label>
    <!-- Khối 1: Form thêm mới nhanh -->
    <div class="admin-card">
        <h4 style="margin-top: 0; margin-bottom: 12px; color: #334155;">Thêm Thương Hiệu Mới</h4>
        <div class="form-inline">
            <label><strong>Tên thương hiệu:</strong></label>
            <asp:TextBox ID="txtBrandName" runat="server" placeholder="Ví dụ: Sony, Google, Dell..."></asp:TextBox>
            <asp:Button ID="btnAdd" runat="server" Text="+ Thêm Thương Hiệu" CssClass="btn-action btn-add" OnClick="btnAdd_Click" />
        </div>
    </div>

    <!-- Khối 2: Lưới GridView quản trị dữ liệu -->
    <asp:GridView ID="gvBrands" runat="server" AutoGenerateColumns="False"
        DataKeyNames="BrandId"
        Width="100%" CellPadding="8" GridLines="None" CssClass="admin-table"
        EmptyDataText="Chưa có dữ liệu thương hiệu."
        OnRowEditing="gvBrands_RowEditing"
        OnRowUpdating="gvBrands_RowUpdating"
        OnRowCancelingEdit="gvBrands_RowCancelingEdit">
        <RowStyle Height="45px" />
        <AlternatingRowStyle BackColor="#f8fafc" />
        <Columns>
            <%-- Cột 1: Xóa hàng loạt (Header có nút xóa, Item có CheckBox) --%>
            <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-Width="80px">
                <HeaderTemplate>
                    <asp:Button ID="btnDeleteSelected" runat="server" Text="Xóa Chọn" CssClass="btn-action btn-delete-bulk"
                        OnClick="btnDeleteSelected_Click"
                        OnClientClick="return confirm('Bạn có chắc chắn muốn xóa các thương hiệu đã chọn không?');" />
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="chkSelect" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>
            <%-- Cột 2: Khóa chính BrandId (Bắt buộc ReadOnly="True" để không bị sửa khóa chính theo Slide 28) --%>
            <asp:BoundField DataField="BrandId" HeaderText="Mã Hãng" ReadOnly="True" 
                ItemStyle-HorizontalAlign="Center" ItemStyle-Width="90px" />
            <%-- Cột 3: Tên thương hiệu (Để BoundField thông thường để GridView tự biến thành TextBox khi bấm Sửa) --%>
            <asp:BoundField DataField="BrandName" HeaderText="Tên Thương Hiệu" />
            <%-- Cột 4: Cột lệnh Sửa trực tiếp trên lưới (Slide 27) --%>
            <asp:CommandField ShowEditButton="True" 
                EditText="Sửa" UpdateText="Lưu" CancelText="Hủy"
                ItemStyle-HorizontalAlign="Center" ItemStyle-Width="120px"
                ControlStyle-Font-Bold="True" ControlStyle-ForeColor="#0284c7" />
        </Columns>
    </asp:GridView>

</asp:Content>
