import 'package:ngf_organic/Models/Product_Detail_Model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';

import 'appLink.dart';

class ProductHelper {
  createNameForUrl(String name) {
    return name.replaceAll(" ", "-");
  }

  Uri createProductPath({
    required int productId,
    String? referCode,
    required String name,
    required String sku,
  }) {
    Map<String, dynamic> query = {"sku": sku};
    if (referCode != null) query["referCode"] = referCode;

    Uri path = Uri.parse(
      "$appLink/product/${createNameForUrl(name)}/$productId",
    ).replace(queryParameters: query);

    return path;
  }

  Future<void> shareProduct(
    ProductDetailModel product, {
    required String sku,
    String? referCode,
  }) async {
    try {
      // Download the image
      final response = await http.get(Uri.parse(product.images[0]));
      if (response.statusCode == 200) {
        // Get temporary directory
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/product_image.png');

        // Save the image to a temporary file
        await file.writeAsBytes(response.bodyBytes);
        Uri productLink = createProductPath(
          name: product.name,
          sku: sku,
          productId: product.id,
          referCode: referCode,
        );
        // Share the link and image
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Check out this product: $productLink',
        );
      } else {
        // If image download fails, share only the text
        Uri productLink = createProductPath(
          name: product.name,
          sku: sku,
          productId: product.id,
          referCode: referCode,
        );
        await Share.share(
          'Check out this product: $productLink',
        );
      }
    } catch (e) {
      // If any error occurs, share only the text
      Uri productLink = createProductPath(
        name: product.name,
        sku: sku,
        productId: product.id,
        referCode: referCode,
      );
      await Share.share(
        'Check out this product: $productLink',
      );
      debugPrint('Error sharing product: $e');
    }
  }
}
