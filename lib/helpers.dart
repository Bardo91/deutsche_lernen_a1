String getBgImage() {
  DateTime now = new DateTime.now();
  if (now.hour > 7 && now.hour < 20) {
    return "assets/bg_day.jpg";
  } else {
    return "assets/bg_day.jpg";
  }
}
