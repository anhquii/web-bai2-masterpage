using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data;


namespace web_bai2_masterpage.Admin
{
    public partial class AddProduct : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDropDownLists();
            }

        }
        private void LoadDropDownLists()
        {
            using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
            {
                ddlCategory.DataSource = db.Categories.ToList();
                ddlCategory.DataTextField = "CategoryName";
                ddlCategory.DataValueField = "CategoryId";
                ddlCategory.DataBind();

                ddlBrand.DataSource = db.Brands.ToList();
                ddlBrand.DataTextField = "BrandName";
                ddlBrand.DataValueField = "BrandId";
                ddlBrand.DataBind();
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
                lblMessage.Text = "Giá phải là số dương";
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

                if (imageName != null)
                {
                    fuImage.SaveAs(Server.MapPath("~/Images/" + imageName));
                }

                Product p = new Product();
                p.ProductName = name;
                p.Price = price;
                p.Description = txtDescription.Text.Trim();
                p.CategoryId = Convert.ToInt32(ddlCategory.SelectedValue);
                p.BrandId = Convert.ToInt32(ddlBrand.SelectedValue);
                p.Image = imageName;



                using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
                {
                    db.Products.InsertOnSubmit(p);
                    db.SubmitChanges();
                }

                lblMessage.Text = "Lưu thành công: " + name;

            }
            catch (Exception ex)  
            {
                lblMessage.Text = "Lưu không thành công: " + ex.Message;
            }
        }

    }
}