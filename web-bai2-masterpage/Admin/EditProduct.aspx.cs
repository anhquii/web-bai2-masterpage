using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;


namespace web_bai2_masterpage.Admin
{
    public partial class EditProduct : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                
                LoadProduct();
            }

        }

       

        private int GetProductId()
        {
            int id;
            int.TryParse(Request.QueryString["id"], out id);
            return id;
        }

        private void LoadProduct()
        {
            using (MyPhoneShopDataContext db
                = new MyPhoneShopDataContext())
            {
                int id = GetProductId();
                Product p = db.Products.SingleOrDefault(x => x.ProductId == id);
                if (p == null)
                {
                    lblMessage.Text = "Không tìm thấy sản phẩm";
                    btnSave.Visible = false;
                    return;
                }

                lblProductId.Text = p.ProductId.ToString();
                txtName.Text = p.ProductName;
                txtPrice.Text = p.Price.ToString("0");

                txtDescription.Text = p.Description;

                imgCurrent.ImageUrl = "~/Images/" + (p.Image ?? "no-image.svg");


                ddlCategory.SelectedValue = p.CategoryId.ToString();
                ddlBrand.SelectedValue = p.BrandId.ToString();

            }



        }

        protected void btnSave_Click(object sender, EventArgs e)
        {

            string name = txtName.Text.Trim();
            if (name == "")
            {
                lblMessage.Text = "Bạn chưa nhập tên sản phẩm";
                return;
            }

            decimal price;
            if (!decimal.TryParse(txtPrice.Text, out price) || price <= 0)
            {
                lblMessage.Text = "Giá phải là số dương.";
                return;
            }


            string imageName = null;
            if (fuImage.HasFile)
            {
                string ext = Path.GetExtension(fuImage.FileName).ToLower();
                string[] allowed = { ".jpg", ".jpeg", ".png", ".gif", ".webp" };
                if (!allowed.Contains(ext))
                {
                    lblMessage.Text = "Chỉ nhận ảnh .jpg, .jpeg, .png, .gif, .webp";
                    return;
                }
                imageName = Guid.NewGuid().ToString("N") + ext;
            }



            try
            {
                using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
                {
                    // Tìm lại sản phẩm (lần bấm nút là một trang mới, biến p của LoadProduct đã mất)
                    int id = GetProductId();
                    Product p = db.Products.SingleOrDefault(x => x.ProductId == id);
                    if (p == null)
                    {
                        lblMessage.Text = "Không tìm thấy sản phẩm.";
                        return;
                    }

                    p.ProductName = name;
                    p.Price = price;
                    p.Description = txtDescription.Text.Trim();
                    p.CategoryId = Convert.ToInt32(ddlCategory.SelectedValue);
                    p.BrandId = Convert.ToInt32(ddlBrand.SelectedValue);


                    if (imageName != null)                                       // ← THÊM (3)
                    {
                        fuImage.SaveAs(Server.MapPath("~/Images/" + imageName));
                        p.Image = imageName;
                    }

                    

                    db.SubmitChanges();   // KHÔNG có InsertOnSubmit, xem giải thích bên dưới
                }

                if (imageName != null)                                           // ← THÊM (4)
                {
                    imgCurrent.ImageUrl = "~/Images/" + imageName;
                }
                

                lblMessage.Text = "Cập nhật thành công: " + name;
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Cập nhật không thành công: " + ex.Message;
            }

        }
    }
}