const String appLink = "https://app.ngforganic.com";

String createProductPath({required int productId, String? referCode}) {
  String path = "$appLink/product/$productId";
  if (referCode != null) {
    path += "?referCode=$referCode";
  }

  return path;
}
