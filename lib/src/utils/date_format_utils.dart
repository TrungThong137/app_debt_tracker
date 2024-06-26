import 'package:intl/intl.dart';

class AppDateUtils {
  static String splitHourDate(String time) {
    final result = time.split(' ');
    final hour = result[1].substring(0, 5);
    return '$hour ${formatDateTime(result[0])}';
  }

  static String formatDateLocal(String time) {
    return DateTime.parse(time).toLocal().toString().split('.')[0];
  }

  static String formatTimeToHHMM(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatDateTime(dynamic time) {
    try {
      return DateFormat('dd-MM-yyyy').format(time);
    } catch (e) {
      return DateFormat('dd-MM-yyyy').format(DateTime.now());
    }
  }

  static String formatDateTimeFromUtc(dynamic time) {
    try {
      return DateFormat('dd-MM-yyyy')
          .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(time));
    } catch (e) {
      return DateFormat('dd-MM-yyyy').format(DateTime.now());
    }
  }

  static String formatDateTimeFromHours(dynamic time) {
    try {
      return DateFormat('HH:mm')
          .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(time));
    } catch (e) {
      return DateFormat('HH:mm').format(DateTime.now());
    }
  }

  static String formatDateTimeFromHoursAndDate(dynamic time) {
    try {
      return DateFormat('HH:mm dd-MM-yyyy')
          .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(time));
    } catch (e) {
      return DateFormat('HH:mm dd-MM-yyyy').format(DateTime.now());
    }
  }

  static String formatDateTimeNotify(String? time) {
    try {
      return time!.isNotEmpty
          ? DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(time))
          : '';
    } catch (e) {
      return DateFormat('HH:mm dd/MM/yyyy').format(DateTime.now());
    }
  }

  static String formatDaTime(dynamic time) {
    try {
      return DateFormat('HH:mm dd-MM-yyyy').format(
        DateFormat('yyyy-MM-dd HH:mm').parse(time));
    } catch (e) {
      return DateFormat('HH:mm dd-MM-yyyy').format(DateTime.now());
    }
  }

  static DateTime parseDate(dynamic time) {
    try {
      return DateFormat('yyyy-MM-dd').parse(time);
    } catch (e) {
      return DateFormat('dd-MM-yyyy').parse(DateTime.now().toString());
    }
  }

  static String formatDateTT(String time) {
    final inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

    // Định dạng ngày giờ đầu ra
    final outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

    // Chuyển đổi từ định dạng đầu vào sang định dạng đầu ra
    final dateTime = inputFormat.parse(time);
    final result = outputFormat.format(dateTime);

    return result;
  }

  static String formatFromDateTime(dynamic time) {
    try {
      return DateFormat('HH:mm dd-MM-yyyy').format(time);
    } catch (e) {
      return DateFormat('HH:mm dd-MM-yyyy').format(DateTime.now());
    }
  }
}
