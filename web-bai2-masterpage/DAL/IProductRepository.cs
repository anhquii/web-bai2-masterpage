namespace web_bai2_masterpage.DAL
{
    /// <summary>
    /// Giao diện truy xuất dữ liệu Sản phẩm (Abstraction & Dependency Inversion Principle).
    /// </summary>
    public interface IProductRepository
    {
        Product GetProductById(int productId);
    }
}
