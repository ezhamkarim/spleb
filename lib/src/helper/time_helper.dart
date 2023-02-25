class TimeHelper {
  static String getGreetingTime() {
    var dateTime = DateTime.now();

    if (dateTime.hour < 12) {
      return 'Selamat Pagi';
    } else if (dateTime.hour >= 12 && dateTime.hour < 13) {
      return 'Selamat Tengah Hari';
    } else if (dateTime.hour > 13) {
      return 'Selamat Petang';
    } else {
      return 'Selamat Malam';
    }
  }
}
