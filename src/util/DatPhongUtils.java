package util;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;

public class DatPhongUtils {

    // Tính tiền phòng (MỚI: giaGio là giá trực tiếp theo mỗi giờ)
    public static BigDecimal tinhTienPhong(Timestamp nhan, Timestamp tra, BigDecimal giaGio) {
        if (nhan == null || tra == null || giaGio == null) return BigDecimal.ZERO;

        long millis = tra.getTime() - nhan.getTime();
        long hours = millis / (1000 * 60 * 60); 

        if (hours <= 0) return BigDecimal.ZERO;

        return giaGio.multiply(BigDecimal.valueOf(hours));
    }

    /**
     * Tính phạt theo quy định mới:
     * - Trễ >= 1 giờ HOẶC Sớm >= 12 giờ so với hẹn trả.
     * - Mức phạt: 10% giá giờ cho mỗi giờ chênh lệch (tuyệt đối).
     */
    public static BigDecimal tinhPhatTheoGio(Timestamp henTra, Timestamp tra, BigDecimal giaGio) {
        if (henTra == null || tra == null || giaGio == null) return BigDecimal.ZERO;

        long millisDiff = tra.getTime() - henTra.getTime();
        long hoursDiff = millisDiff / (1000 * 60 * 60); // Dương là trễ, âm là sớm

        boolean biPhat = false;
        if (hoursDiff >= 1) {
            biPhat = true; // Phạt trả muộn
        } else if (hoursDiff <= -12) {
            biPhat = true; // Phạt trả sớm
        }

        if (!biPhat) return BigDecimal.ZERO;

        // Phạt = Giá giờ * 10% * |Số giờ chênh lệch|
        BigDecimal phatMoiGio = giaGio.multiply(BigDecimal.valueOf(0.10));
        long absHours = Math.abs(hoursDiff);
        
        return phatMoiGio.multiply(BigDecimal.valueOf(absHours)).setScale(2, RoundingMode.HALF_UP);
    }
}
