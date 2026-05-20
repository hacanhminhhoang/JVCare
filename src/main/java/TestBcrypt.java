import org.mindrot.jbcrypt.BCrypt;

public class TestBcrypt {
    public static void main(String[] args) {
        String hash = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy";
        System.out.println("admin123 matches: " + BCrypt.checkpw("admin123", hash));
        System.out.println("patient123 matches: " + BCrypt.checkpw("patient123", hash));
        System.out.println("doctor123 matches: " + BCrypt.checkpw("doctor123", hash));
    }
}
