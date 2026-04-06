// package config;

// import java.sql.Connection;
// import java.sql.DriverManager;

// public class DBConnection {
//     private static final String URL = "jdbc:mysql://localhost:3306/QLKS?useSSL=false&serverTimezone=UTC";
//     private static final String USER = "root";
//     private static final String PASS = "LongK@170105";

//     public static Connection getConnection() {
//         try {
//             Class.forName("com.mysql.cj.jdbc.Driver");
//             return DriverManager.getConnection(URL, USER, PASS);
//         } catch (Exception e) {
//             System.out.println("❌ Lỗi kết nối DB: " + e.getMessage());
//             return null;
//         }
//     }
// }
package config;

import java.sql.Connection;
import java.sql.DriverManager;
import io.github.cdimascio.dotenv.Dotenv;

public class DBConnection {

    private static String url;
    private static String user;
    private static String pass;

    static {
        try {
            // Load .env from root directory
            Dotenv dotenv = Dotenv.load();

            url = dotenv.get("DB_URL");
            user = dotenv.get("DB_USER");
            pass = dotenv.get("DB_PASSWORD");

            if (url == null || user == null) {
                System.out.println("⚠️ Không tìm thấy biến môi trường trong .env. Sử dụng mặc định.");
                url = "jdbc:postgresql://localhost:5432/hotelmanage?currentSchema=hotelmanage";
                user = "postgres";
                pass = "postgres";
            }

            Class.forName("org.postgresql.Driver");
        } catch (Exception e) {
            System.out.println("❌ Lỗi cấu hình Dotenv: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(url, user, pass);
        } catch (Exception e) {
            System.out.println("❌ Lỗi kết nối DB: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}