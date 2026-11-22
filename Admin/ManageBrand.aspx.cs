using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace web_bai2_masterpage.Admin
{
    public partial class ManageBrand : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBrands();
            }
        }

        private void LoadBrands()
        {
            using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
            {
                // Lấy danh sách thương hiệu, sắp xếp theo mã tăng dần
                var list = db.Brands.OrderBy(b => b.BrandId).ToList();
                gvBrands.DataSource = list;
                gvBrands.DataBind();
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            string brandName = txtBrandName.Text.Trim();
            // Kiểm tra rỗng
            if (string.IsNullOrEmpty(brandName))
            {
                lblMessage.Text = "⚠ Vui lòng nhập tên thương hiệu!";
                lblMessage.BackColor = Color.FromArgb(254, 242, 242);
                lblMessage.ForeColor = Color.FromArgb(185, 28, 28);
                lblMessage.Visible = true;
                return;
            }
            try
            {
                using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
                {
                    // Tạo đối tượng Brand mới
                    Brand brand = new Brand();
                    brand.BrandName = brandName;
                    // Đưa đối tượng vào hàng đợi thêm và thực thi lưu xuống CSDL
                    db.Brands.InsertOnSubmit(brand);
                    db.SubmitChanges();
                }
                // Xóa trắng ô nhập sau khi thêm thành công
                txtBrandName.Text = string.Empty;
                // Báo kết quả thành công màu xanh
                lblMessage.Text = "✔ Thêm thương hiệu '" + brandName + "' thành công!";
                lblMessage.BackColor = Color.FromArgb(240, 253, 244);
                lblMessage.ForeColor = Color.FromArgb(21, 128, 61);
                lblMessage.Visible = true;
                // Nạp lại danh sách để dòng mới hiển thị ngay trên GridView
                LoadBrands();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "✖ Không thể thêm thương hiệu. Lỗi: " + ex.Message;
                lblMessage.BackColor = Color.FromArgb(254, 242, 242);
                lblMessage.ForeColor = Color.FromArgb(185, 28, 28);
                lblMessage.Visible = true;
            }   
        }

        // =============================================================
        // PHẦN A: SỬA TRỰC TIẾP TRÊN LƯỚI (IN-PLACE EDITING - Slide 27-31)
        // =============================================================

        // 1. Khi bấm chữ "Sửa" trên một dòng: Bật chế độ EditItem
        protected void gvBrands_RowEditing(object sender, GridViewEditEventArgs e)
        {
            // Gán chỉ số dòng đang chọn vào EditIndex
            gvBrands.EditIndex = e.NewEditIndex;
            // Nạp lại dữ liệu để dòng này biến thành TextBox
            LoadBrands();
        }

        // 2. Khi bấm chữ "Hủy": Thoát chế độ sửa về bình thường
        protected void gvBrands_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            // Trả EditIndex về -1 nghĩa là không có dòng nào ở chế độ sửa
            gvBrands.EditIndex = -1;
            LoadBrands();
        }

        // 3. Khi bấm chữ "Lưu": Đọc giá trị mới và cập nhật xuống SQL Server
        protected void gvBrands_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                // Bước 1: Lấy khóa chính BrandId từ mảng DataKeys của dòng đang sửa
                int brandId = Convert.ToInt32(gvBrands.DataKeys[e.RowIndex].Value);

                // Bước 2: Truy xuất TextBox tại Cột 2 (Cột Tên thương hiệu, index = 2)
                // Cột 0: CheckBox | Cột 1: Mã Hãng | Cột 2: Tên Hãng
                TextBox txtName = (TextBox)gvBrands.Rows[e.RowIndex].Cells[2].Controls[0];
                string updatedName = txtName.Text.Trim();

                if (string.IsNullOrEmpty(updatedName))
                {
                    lblMessage.Text = "⚠ Tên thương hiệu không được để trống!";
                    lblMessage.BackColor = Color.FromArgb(254, 242, 242);
                    lblMessage.ForeColor = Color.FromArgb(185, 28, 28);
                    lblMessage.Visible = true;
                    return;
                }

                // Bước 3: Tìm và cập nhật bằng LINQ to SQL
                using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
                {
                    var brand = db.Brands.SingleOrDefault(b => b.BrandId == brandId);
                    if (brand != null)
                    {
                        brand.BrandName = updatedName;
                        db.SubmitChanges();

                        lblMessage.Text = "✔ Đã cập nhật thương hiệu mã [" + brandId + "] thành công!";
                        lblMessage.BackColor = Color.FromArgb(240, 253, 244);
                        lblMessage.ForeColor = Color.FromArgb(21, 128, 61);
                        lblMessage.Visible = true;
                    }
                }

                // Bước 4: Thoát chế độ sửa và nạp lại dữ liệu mới nhất
                gvBrands.EditIndex = -1;
                LoadBrands();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "✖ Cập nhật thất bại. Lỗi: " + ex.Message;
                lblMessage.BackColor = Color.FromArgb(254, 242, 242);
                lblMessage.ForeColor = Color.FromArgb(185, 28, 28);
                lblMessage.Visible = true;
            }
        }

        // =============================================================
        // PHẦN B: XÓA HÀNG LOẠT (BULK DELETE - Slide 24-26)
        // =============================================================
        protected void btnDeleteSelected_Click(object sender, EventArgs e)
        {
            int deletedCount = 0;
            List<string> errorList = new List<string>();

            using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
            {
                // Duyệt qua từng dòng của GridView
                foreach (GridViewRow row in gvBrands.Rows)
                {
                    // Tìm control CheckBox 'chkSelect' nằm trong dòng đó
                    CheckBox chk = (CheckBox)row.FindControl("chkSelect");

                    // Nếu người dùng tick chọn dòng này
                    if (chk != null && chk.Checked)
                    {
                        // Lấy BrandId tương ứng của dòng
                        int brandId = Convert.ToInt32(gvBrands.DataKeys[row.RowIndex].Value);

                        // Kiểm tra ràng buộc khóa ngoại: Nếu thương hiệu đã có sản phẩm thì không cho xóa
                        bool hasProducts = db.Products.Any(p => p.BrandId == brandId);
                        if (hasProducts)
                        {
                            errorList.Add("Mã " + brandId + " (đang có sản phẩm)");
                            continue;
                        }

                        // Tìm và xóa khỏi CSDL
                        var brand = db.Brands.SingleOrDefault(b => b.BrandId == brandId);
                        if (brand != null)
                        {
                            db.Brands.DeleteOnSubmit(brand);
                            deletedCount++;
                        }
                    }
                }

                // Thực thi lưu các lệnh xóa xuống SQL Server
                if (deletedCount > 0)
                {
                    db.SubmitChanges();
                }
            }

            // Hiển thị thông báo tổng kết cho người dùng
            if (deletedCount > 0 && errorList.Count == 0)
            {
                lblMessage.Text = "✔ Đã xóa thành công " + deletedCount + " thương hiệu được chọn!";
                lblMessage.BackColor = Color.FromArgb(240, 253, 244);
                lblMessage.ForeColor = Color.FromArgb(21, 128, 61);
                lblMessage.Visible = true;
            }
            else if (errorList.Count > 0)
            {
                lblMessage.Text = "⚠ Đã xóa " + deletedCount + " mục. Không thể xóa: " + string.Join(", ", errorList) + " do đang chứa sản phẩm liên quan!";
                lblMessage.BackColor = Color.FromArgb(254, 242, 242);
                lblMessage.ForeColor = Color.FromArgb(185, 28, 28);
                lblMessage.Visible = true;
            }
            else
            {
                lblMessage.Text = "⚠ Bạn chưa chọn thương hiệu nào để xóa!";
                lblMessage.BackColor = Color.FromArgb(254, 242, 242);
                lblMessage.ForeColor = Color.FromArgb(185, 28, 28);
                lblMessage.Visible = true;
            }

            // Nạp lại GridView để cập nhật danh sách mới nhất
            LoadBrands();
        }

    }
}