class BaseAPI {
  static String base = "http://localhost:3000";
  static String api = "$base/api/v1";
  String customersPath = "$api/customers";
  String authPath = "$api/auth";

// more routes
  Map<String, String> headers = <String, String>{
    "Content-Type": "application/json; charset=UTF-8"
  };
}
