using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace web_bai2_masterpage.Helpers
{
    public class SecurityHelper
    {

        /// <summary>
        /// Tạo một chuỗi muối ngẫu nhiên (Salt) độ dài mặc định 16 byte (chuỗi hex 32 ký tự)
        /// </summary>
        public static string GenerateSalt(int size = 16)
        {
            byte[] saltBytes = new byte[size];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(saltBytes);
            }
            return BitConverter.ToString(saltBytes).Replace("-", "").ToLower();
        }
        /// <summary>
        /// Băm mật khẩu kết hợp với Salt theo chuẩn thuật toán SHA-256
        /// </summary>
        public static string HashPassword(string password, string salt)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                // Nối chuỗi mật khẩu thô với chuỗi Salt
                string combinedString = password + salt;
                byte[] inputBytes = Encoding.UTF8.GetBytes(combinedString);
                byte[] hashBytes = sha256.ComputeHash(inputBytes);
                // Chuyển mảng byte băm thành chuỗi ký tự Hexadecimal thường
                StringBuilder sb = new StringBuilder();
                foreach (byte b in hashBytes)
                {
                    sb.Append(b.ToString("x2"));
                }
                return sb.ToString();
            }


        }


        /// <summary>
        /// Xác thực mật khẩu người dùng nhập vào so với chuỗi Hash đã lưu trong CSDL
        /// </summary>
        public static bool VerifyPassword(string inputPassword, string storedHash, string storedSalt)
        {
            string computedHash = HashPassword(inputPassword, storedSalt);
            // So sánh 2 chuỗi Hash (bỏ qua viết hoa/thường)
            return string.Equals(computedHash, storedHash, StringComparison.OrdinalIgnoreCase);
        }











    }
}