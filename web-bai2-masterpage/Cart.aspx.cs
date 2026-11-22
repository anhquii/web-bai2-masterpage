using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using web_bai2_masterpage.BLL;
using web_bai2_masterpage.Models;

namespace web_bai2_masterpage
{
    public partial class Cart : System.Web.UI.Page
    {
        private readonly ICartService _cartService = new CartService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCartData();
                BindSuggestedProducts();
            }
        }

        private void BindCartData()
        {
            List<CartItemDto> cartItems = _cartService.GetCart();

            if (cartItems == null || cartItems.Count == 0)
            {
                pnlEmptyCart.Visible = true;
                pnlCartContent.Visible = false;
                return;
            }

            pnlEmptyCart.Visible = false;
            pnlCartContent.Visible = true;

            rptCart.DataSource = cartItems;
            rptCart.DataBind();

            litTotalQuantity.Text = _cartService.GetTotalQuantity().ToString();
            litSubTotalAmount.Text = string.Format("{0:N0}₫", _cartService.GetSubTotalAmount());
        }

        private void BindSuggestedProducts()
        {
            try
            {
                using (MyPhoneShopDataContext db = new MyPhoneShopDataContext())
                {
                    var suggested = db.Products
                                      .OrderByDescending(p => p.ProductId)
                                      .Take(6)
                                      .ToList();

                    rptSuggestedProducts.DataSource = suggested;
                    rptSuggestedProducts.DataBind();
                }
            }
            catch
            {
            }
        }

        protected void rptSuggestedProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "QuickAdd")
            {
                int productId;
                if (int.TryParse(e.CommandArgument.ToString(), out productId))
                {
                    _cartService.AddToCart(productId, 1);
                    BindCartData();
                }
            }
        }

        /// <summary>
        /// Tự động cập nhật số lượng ngay khi người dùng gõ số mới vào ô txtItemQty và nhấn Enter / click ra ngoài (không cần nút Lưu).
        /// </summary>
        protected void txtItemQty_TextChanged(object sender, EventArgs e)
        {
            TextBox txtQty = sender as TextBox;
            if (txtQty == null)
                return;

            RepeaterItem item = txtQty.NamingContainer as RepeaterItem;
            if (item == null)
                return;

            HiddenField hfProductId = item.FindControl("hfItemProductId") as HiddenField;
            int productId;
            int newQty;

            if (hfProductId != null &&
                int.TryParse(hfProductId.Value, out productId) &&
                int.TryParse(txtQty.Text, out newQty))
            {
                _cartService.UpdateQuantity(productId, newQty);
            }

            BindCartData();
        }

        protected void rptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int productId;
            if (!int.TryParse(e.CommandArgument.ToString(), out productId))
                return;

            List<CartItemDto> cart = _cartService.GetCart();
            CartItemDto currentItem = cart.FirstOrDefault(x => x.ProductId == productId);

            if (e.CommandName == "Increase" && currentItem != null)
            {
                _cartService.UpdateQuantity(productId, currentItem.Quantity + 1);
            }
            else if (e.CommandName == "Decrease" && currentItem != null)
            {
                if (currentItem.Quantity > 1)
                {
                    _cartService.UpdateQuantity(productId, currentItem.Quantity - 1);
                }
                else
                {
                    _cartService.RemoveFromCart(productId);
                }
            }
            else if (e.CommandName == "Remove")
            {
                _cartService.RemoveFromCart(productId);
            }

            BindCartData();
        }

        protected void btnClearCart_Click(object sender, EventArgs e)
        {
            _cartService.ClearCart();
            BindCartData();
        }
    }
}
