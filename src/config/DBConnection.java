package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;
import java.util.TimeZone;
import io.github.cdimascio.dotenv.Dotenv;

public class DBConnection {

    private static String url;
    private static String user;
    private static String pass;
    private static String timez;

    static {
        try {
            // Set JVM timezone to avoid issues
            TimeZone.setDefault(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
            
            // Load .env from root directory
            Dotenv dotenv = Dotenv.load();

            url = dotenv.get("DB_URL");
            user = dotenv.get("DB_USER");
            pass = dotenv.get("DB_PASSWORD");
            timez = dotenv.get("DB_TIMEZONE");

            if (url == null || user == null) {
                System.out.println("⚠️ Không tìm thấy biến môi trường trong .env. Sử dụng mặc định.");
                url = "jdbc:postgresql://localhost:5432/postgres?currentSchema=hotelbook&TimeZone=Asia/Ho_Chi_Minh";
                user = "postgres";
                pass = "postgres";
                timez = "Asia/Ho_Chi_Minh";
            }

            Class.forName("org.postgresql.Driver");
        } catch (Exception e) {
            System.out.println("❌ Lỗi cấu hình Dotenv: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        try {
            Properties props = new Properties();
            props.setProperty("user", user);
            props.setProperty("password", pass);
            props.setProperty("TimeZone", timez);
            return DriverManager.getConnection(url, props);
        } catch (Exception e) {
            System.out.println("❌ Lỗi kết nối DB: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}