using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace web_bai2_masterpage.Admin
{
    public partial class ProductList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFilters();
                BindGrid();
            }
        }


        private void LoadFilters()
        {
            using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
            {
                // 1. Nạp danh mục Loại sản phẩm
                ddlCategory.DataSource = db.Categories.ToList();
                ddlCategory.DataTextField = "CategoryName"; // Tên hiển thị ra màn hình
                ddlCategory.DataValueField = "CategoryId";   // Giá trị thực (Value)
                ddlCategory.DataBind();
                // Chèn lựa chọn "Tất cả" lên dòng đầu tiên (vị trí index 0)
                ddlCategory.Items.Insert(0, new ListItem("--- Tất cả loại ---", "0"));

                // 2. Nạp danh mục Hãng sản xuất
                ddlBrand.DataSource = db.Brands.ToList();
                ddlBrand.DataTextField = "BrandName";
                ddlBrand.DataValueField = "BrandId";
                ddlBrand.DataBind();
                ddlBrand.Items.Insert(0, new ListItem("--- Tất cả hãng ---", "0"));
            }
        }

        private void BindGrid()
        {
            int selectedCat = Convert.ToInt32(ddlCategory.SelectedValue);
            int selectedBrand = Convert.ToInt32(ddlBrand.SelectedValue);

            using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
            {
                // Khởi tạo truy vấn nối 3 bảng
                var query = from p in db.Products
                            join c in db.Categories on p.CategoryId equals c.CategoryId
                            join b in db.Brands on p.BrandId equals b.BrandId
                            select new
                            {
                                p.ProductId,
                                p.ProductName,
                                p.Price,
                                p.Image,
                                p.CategoryId,
                                p.BrandId,
                                c.CategoryName,
                                b.BrandName
                            };

                // Nếu người dùng chọn 1 loại cụ thể (khác 0) -> Lọc theo CategoryId
                if (selectedCat > 0)
                {
                    query = query.Where(x => x.CategoryId == selectedCat);
                }

                // Nếu người dùng chọn 1 hãng cụ thể (khác 0) -> Lọc theo BrandId
                if (selectedBrand > 0)
                {
                    query = query.Where(x => x.BrandId == selectedBrand);
                }

                // Sắp xếp ID giảm dần (sản phẩm mới thêm hiện lên trên cùng)
                gvProducts.DataSource = query.OrderByDescending(x => x.ProductId).ToList();
                gvProducts.DataBind();
            }
        }

        protected void gvProducts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            // Gán trang mới mà người dùng vừa bấm vào
            gvProducts.PageIndex = e.NewPageIndex;
            // Nạp lại dữ liệu cho đúng trang đó
            BindGrid();
        }

        protected void gvProducts_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                // 1. Đọc ProductId từ mảng DataKeys dựa vào chỉ số dòng bị xóa (e.RowIndex)
                int productId = Convert.ToInt32(gvProducts.DataKeys[e.RowIndex].Value);

                using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
                {
                    // 2. Tìm sản phẩm trong CSDL theo ID
                    var product = db.Products.SingleOrDefault(p => p.ProductId == productId);
                    if (product != null)
                    {
                        string productName = product.ProductName;

                        // 3. Đánh dấu xóa đối tượng và lưu xuống CSDL
                        db.Products.DeleteOnSubmit(product);
                        db.SubmitChanges();

                        // 4. Báo thành công màu xanh
                        lblMessage.Text = "✔ Đã xóa thành công sản phẩm: " + productName;
                        lblMessage.ForeColor = System.Drawing.Color.DarkGreen;
                        lblMessage.Visible = true;
                    }
                }

                // 5. Nạp lại GridView để dòng vừa xóa biến mất khỏi màn hình
                BindGrid();
            }
            catch (Exception ex)
            {
                // Bắt lỗi (ví dụ sản phẩm đang dính khóa ngoại ở bảng khác nếu có)
                lblMessage.Text = "✖ Không thể xóa sản phẩm. Lỗi: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Visible = true;
            }
        }

        protected void ddlFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Đưa phân trang về trang 1 (index 0) khi thay đổi điều kiện lọc
            gvProducts.PageIndex = 0;
            // Nạp lại danh sách theo loại hoặc hãng vừa chọn
            BindGrid();
        }



    }
}