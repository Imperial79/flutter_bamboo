import 'package:flutter_bamboo/Models/Product_Detail_Model.dart';
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

  String createProductPath({
    required int productId,
    String? referCode,
    required String name,
    required String sku,
  }) {
    String path = "$appLink/${createNameForUrl(name)}/$productId";
    path += "?sku=$sku";
    if (referCode != null) {
      path += "&referCode=$referCode";
    }

    return path;
  }

  Future<void> shareProduct(
    ProductDetailModel product, {
    required int selectedVariant,
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
        String productLink = createProductPath(
          name: product.name,
          sku: product.product_variants[selectedVariant]["sku"],
          productId: product.id,
          referCode: referCode,
        );
        // Share the link and image
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Check out this product: ${Uri.parse(productLink)}',
        );
      } else {
        throw Exception('Failed to download image.');
      }
    } catch (e) {
      debugPrint('Error sharing product: $e');
    }
  }
}
