class Endpoint {
  String get apiUrl => "http://192.168.1.112:8000/";
  // 10.18.116.48
  // String get apiUrl => "http://10.18.116.48:8000/";
  String get predictUrl => "${apiUrl}analyze/";
}
