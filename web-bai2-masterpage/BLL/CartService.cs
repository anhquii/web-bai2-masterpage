using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using web_bai2_masterpage.DAL;
using web_bai2_masterpage.Models;

namespace web_bai2_masterpage.BLL
{
    /// <summary>
    /// Lớp thực thi nghiệp vụ Giỏ hàng trên Session["Cart"].
    /// Áp dụng Dependency Inversion Principle (DIP): phụ thuộc vào IProductRepository thay vì gọi trực tiếp CSDL.
    /// </summary>
    public class CartService : ICartService
    {
        private const string CartSessionKey = "Cart";
        private readonly IProductRepository _productRepository;

        public CartService() : this(new ProductRepository())
        {
        }

        public CartService(IProductRepository productRepository)
        {
            _productRepository = productRepository ?? throw new ArgumentNullException(nameof(productRepository));
        }

        public List<CartItemDto> GetCart()
        {
            if (HttpContext.Current == null || HttpContext.Current.Session == null)
            {
                return new List<CartItemDto>();
            }

            List<CartItemDto> cart = HttpContext.Current.Session[CartSessionKey] as List<CartItemDto>;
            if (cart == null)
            {
                cart = new List<CartItemDto>();
                HttpContext.Current.Session[CartSessionKey] = cart;
            }

            return cart;
        }

        public bool AddToCart(int productId, int quantity)
        {
            if (productId <= 0 || quantity <= 0)
                return false;

            Product product = _productRepository.GetProductById(productId);
            if (product == null)
                return false;

            List<CartItemDto> cart = GetCart();
            CartItemDto existingItem = cart.FirstOrDefault(x => x.ProductId == productId);

            if (existingItem != null)
            {
                existingItem.Quantity = existingItem.Quantity + quantity;
            }
            else
            {
                CartItemDto newItem = new CartItemDto
                {
                    ProductId = product.ProductId,
                    ProductName = product.ProductName,
                    Image = product.Image,
                    UnitPrice = product.Price,
                    Quantity = quantity
                };
                cart.Add(newItem);
            }

            HttpContext.Current.Session[CartSessionKey] = cart;
            return true;
        }

        public void UpdateQuantity(int productId, int quantity)
        {
            List<CartItemDto> cart = GetCart();
            CartItemDto existingItem = cart.FirstOrDefault(x => x.ProductId == productId);

            if (existingItem != null)
            {
                if (quantity <= 0)
                {
                    cart.Remove(existingItem);
                }
                else
                {
                    existingItem.Quantity = quantity;
                }
                HttpContext.Current.Session[CartSessionKey] = cart;
            }
        }

        public void RemoveFromCart(int productId)
        {
            List<CartItemDto> cart = GetCart();
            CartItemDto existingItem = cart.FirstOrDefault(x => x.ProductId == productId);

            if (existingItem != null)
            {
                cart.Remove(existingItem);
                HttpContext.Current.Session[CartSessionKey] = cart;
            }
        }

        public void ClearCart()
        {
            if (HttpContext.Current != null && HttpContext.Current.Session != null)
            {
                HttpContext.Current.Session[CartSessionKey] = new List<CartItemDto>();
            }
        }

        public int GetTotalQuantity()
        {
            List<CartItemDto> cart = GetCart();
            return cart.Sum(x => x.Quantity);
        }

        public decimal GetSubTotalAmount()
        {
            List<CartItemDto> cart = GetCart();
            return cart.Sum(x => x.SubTotal);
        }
    }
}
