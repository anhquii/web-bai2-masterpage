<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="ManageBrand.aspx.cs" Inherits="web_bai2_masterpage.Admin.ManageBrand" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .admin-card {
            background: #fff;
            padding: 16px 20px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .form-inline {
            display: flex;
            gap: 12px;
            align-items: center;
        }
        .form-inline input[type="text"] {
            padding: 8px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 4px;
            width: 280px;
            font-size: 14px;
        }
        .btn-action {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
        }
        .btn-add { background-color: #16a34a; color: #fff; }
        .btn-delete-bulk { background-color: #dc2626; color: #fff; font-size: 12px; padding: 4px 8px; }
        .admin-table th { padding: 10px; background-color: #d70018; color: #fff; }
        .admin-table td { padding: 8px 10px; border-bottom: 1px solid #e2e8f0; }
    </style>



</asp:Content>






<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2 class="section-title">Quản Lý Thương Hiệu (Brands)</h2>
    <!-- Thông báo lỗi hoặc thành công -->
    <asp:Label ID="lblMessage" runat="server" Visible="false" 
        style="display:block; padding: 10px; margin-bottom: 15px; border-radius: 4px; font-weight: 500;"></asp:Label>
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
        style="background: #fff; border-radius: 6px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.1);"
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
