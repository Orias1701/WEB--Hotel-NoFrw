package util;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;

public class DatPhongUtils {

    // Tính tiền phòng theo giờ
    public static BigDecimal tinhTienPhong(Timestamp nhan, Timestamp tra, BigDecimal giaNgay) {
        if (nhan == null || tra == null || giaNgay == null) return BigDecimal.ZERO;

        long millis = tra.getTime() - nhan.getTime();
        long hours = millis / (1000 * 60 * 60); // số giờ chênh lệch

        if (hours <= 0) return BigDecimal.ZERO;

        BigDecimal giaGio = giaNgay.divide(BigDecimal.valueOf(24), 2, RoundingMode.HALF_UP);
        return giaGio.multiply(BigDecimal.valueOf(hours));
    }

    // Tính phạt theo giờ (mỗi giờ 5%)
    public static BigDecimal tinhPhatTheoGio(Timestamp henTra, Timestamp tra, BigDecimal giaNgay) {
        if (henTra == null || tra == null || giaNgay == null) return BigDecimal.ZERO;
        if (tra.before(henTra)) return BigDecimal.ZERO;

        long millis = tra.getTime() - henTra.getTime();
        long hours = millis / (1000 * 60 * 60); // số giờ trễ

        if (hours <= 0) return BigDecimal.ZERO;

        BigDecimal phatMoiGio = giaNgay.multiply(BigDecimal.valueOf(0.05)); // 5% mỗi giờ
        return phatMoiGio.multiply(BigDecimal.valueOf(hours)).setScale(2, RoundingMode.HALF_UP);
    }
}
