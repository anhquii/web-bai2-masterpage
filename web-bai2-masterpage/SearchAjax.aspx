<%@ Page Title="Tìm Kiếm Sản Phẩm - MyPhoneShop" Language="C#" MasterPageFile="~/user.Master" AutoEventWireup="true" CodeBehind="SearchAjax.aspx.cs" Inherits="web_bai2_masterpage.SearchAjax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Nạp jQuery & module CSS riêng cho Thẻ sản phẩm + Tìm kiếm -->
    <script src="<%= ResolveUrl("~/Scripts/jquery-3.6.0.min.js") %>" type="text/javascript"></script>
    <link href="<%= ResolveUrl("~/Content/product.css") %>?v=1" rel="stylesheet" type="text/css" />
    <link href="<%= ResolveUrl("~/Content/search.css") %>?v=1" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- 1. Hộp tìm kiếm trực tiếp trên trang SearchAjax -->
    <div class="search-box-wrapper">
        <h2 class="section-title">Tìm Kiếm Sản Phẩm Thời Gian Thực (Live Ajax Search)</h2>
        <div class="search-input-group">
            <input type="text" id="txtKeyword" class="search-input" placeholder="Nhập tên sản phẩm hoặc thương hiệu cần tìm (VD: iPhone, Samsung, Dell...)" autocomplete="off" />
        </div>
        <div>
            <span id="lblResultCount" class="search-badge">Đang tải danh sách sản phẩm...</span>
            <span id="lblLoading" class="loading-indicator">Đang tìm kiếm...</span>
        </div>
    </div>

    <!-- 2. Lưới hiển thị danh sách thẻ sản phẩm (Sẽ được JavaScript chèn tự động) -->
    <div class="product-grid" id="productGrid"></div>
        
    <!-- ========================================================================= -->
    <!-- KỊCH BẢN JQUERY AJAX & RENDERING THỜI GIAN THỰC                           -->
    <!-- ========================================================================= -->
    <script type="text/javascript">
        // @ts-nocheck
        $(document).ready(function () {

            // 1. Đọc từ khóa ?q=... nếu người dùng chuyển sang từ thanh Header Search
            var urlParams = new URLSearchParams(window.location.search);
            var initialKeyword = (urlParams.get("q") || "").trim();
            if (initialKeyword.length > 0) {
                $("#txtKeyword").val(initialKeyword);
            }

            // Nạp danh sách sản phẩm ban đầu ngay khi người dùng mở trang
            searchProducts(initialKeyword);

            var typingTimer;
            // 2. Bắt sự kiện gõ phím vào ô tìm kiếm
            $("#txtKeyword").on("input", function () {
                clearTimeout(typingTimer);
                var keyword = $(this).val().trim();

                // KỸ THUẬT DEBOUNCE (Chờ 300ms sau khi ngừng gõ mới gửi request để tránh nghẽn server)
                typingTimer = setTimeout(function () {
                    searchProducts(keyword);
                }, 300);
            });

            // 3. Hàm gửi yêu cầu AJAX ngầm lên server
            function searchProducts(keyword) {
                $("#lblLoading").show(); // Hiện chữ đang tìm kiếm

                $.ajax({
                    type: "POST",
                    url: '<%= ResolveUrl("~/SearchAjax.aspx/SearchProducts") %>',
                    data: JSON.stringify({ keyword: keyword }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        $("#lblLoading").hide();
                        // Dữ liệu C# trả về được ASP.NET tự động bọc trong thuộc tính response.d
                        var products = response.d;
                        renderProducts(products);
                    },
                    error: function (xhr, status, error) {
                        $("#lblLoading").hide();
                        console.error("Lỗi gọi Ajax: " + error);
                    }
                });
            }

            // 4. Hàm vẽ giao diện các thẻ card sản phẩm từ mảng JSON nhận được
            function renderProducts(products) {
                var container = $("#productGrid");
                container.empty(); // Xóa sạch các thẻ cũ trước khi vẽ danh sách mới

                // Trường hợp không tìm thấy sản phẩm nào
                if (!products || products.length === 0) {
                    container.html('<div class="no-result">Không tìm thấy sản phẩm nào phù hợp với từ khóa!</div>');
                    $("#lblResultCount").text("Tìm thấy 0 sản phẩm");
                    return;
                }

                // Cập nhật số lượng sản phẩm tìm thấy
                $("#lblResultCount").text("Tìm thấy " + products.length + " sản phẩm");

                var imagesBaseUrl = '<%= ResolveUrl("~/Images/") %>';
                var defaultNoImage = '<%= ResolveUrl("~/Images/no-image.svg") %>';
                var detailBaseUrl = '<%= ResolveUrl("~/ProductDetail.aspx?id=") %>';

                // Duyệt qua từng sản phẩm và tạo thẻ card chuẩn phong cách CellphoneS
                $.each(products, function (index, item) {
                    var formattedPrice = new Intl.NumberFormat('vi-VN').format(item.Price) + " đ";
                    var imgSrc = item.Image ? (imagesBaseUrl + item.Image) : defaultNoImage;

                    var cardHtml =
                        '<div class="product-card">' +
                        '<div class="card-badges">' +
                        '<span class="badge-discount">Giảm 15%</span>' +
                        '<span class="badge-installment">Trả góp 0%</span>' +
                        '</div>' +
                        '<img class="product-image" src="' + imgSrc + '" alt="' + item.ProductName + '" onerror="this.src=\'' + defaultNoImage + '\';" />' +
                        '<span class="brand-badge">' + (item.BrandName || "Chính hãng") + '</span>' +
                        '<h3 class="product-name" title="' + item.ProductName + '">' + item.ProductName + '</h3>' +
                        '<span class="product-price">' + formattedPrice + '</span>' +
                        '<a class="btn-detail" href="' + detailBaseUrl + item.ProductId + '">Xem chi tiết</a>' +
                        '</div>';

                    container.append(cardHtml);
                });
            }
        });
    </script>

</asp:Content>
