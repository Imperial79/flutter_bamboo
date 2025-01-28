import 'dart:io';
import 'package:flutter/services.dart';
import 'package:indian_currency_to_word/indian_currency_to_word.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generate({required orderDetails}) async {
    final ByteData companyLogoBytes =
        await rootBundle.load('assets/images/logo.png');
    final Uint8List companyLogo = companyLogoBytes.buffer.asUint8List();

    // final ByteData authSignBytes =
    //     await rootBundle.load('assets/images/invoice_signature.png');
    // final Uint8List authSignature = authSignBytes.buffer.asUint8List();

    // var url = orderDetail['productImg'];
    // var response = await get(Uri.parse(url));
    // var data = response.bodyBytes;

    final pdf = Document();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      build: (context) => [
        headerPart(companyLogo),
        companyPart(),
        // invoiceToPart(),
        // itemsPart(),
        // amountPart(),
        thanksNote(),
        termsPart(),
      ],
      footer: (context) => footerPart(),
    ));
    return saveDocument(
        name: "Invoice_${orderDetails["orderId"]}.pdf", pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getDownloadsDirectory();
    final file = File('${dir?.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }

  static Widget headerPart(companyLogo) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        children: [
          Image(
            MemoryImage(
              companyLogo,
            ),
            height: 20,
            width: 20,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 10,
          ),
          Text("My Postmates"),
          Spacer(),
          Text(
            "Invoice",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static Widget companyPart() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(),
          right: BorderSide(),
          bottom: BorderSide(),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "COSHIFTER LOGISTICS PRIVATE LIMITED",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            "NO 6, MAHENDRU GAIGHAT, PATNA, Patna, Bihar, 800007",
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            "CIN: U93000BR2020PTC047059",
            style: const TextStyle(fontSize: 12),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  // static Widget invoiceToPart() {
  //   return Container(
  //     width: double.infinity,
  //     decoration: const BoxDecoration(
  //       border: Border(
  //         left: BorderSide(),
  //         right: BorderSide(),
  //         bottom: BorderSide(),
  //       ),
  //     ),
  //     child: TableHelper.fromTextArray(
  //       data: [
  //         [
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Invoice To",
  //                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //               ),
  //               Text(
  //                 "${orderDetails!.fromName} (+91 ${orderDetails!.fromPhone})",
  //                 style: const TextStyle(fontSize: 12),
  //               ),
  //               Text(
  //                 "${orderDetails!.fromAddress2}",
  //                 style: const TextStyle(fontSize: 12),
  //               ),
  //               Text(
  //                 "${orderDetails!.fromAddress}",
  //                 style: const TextStyle(fontSize: 12),
  //               ),
  //             ],
  //           ),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Order Id: ${orderDetails!.id}",
  //                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //               ),
  //               Text(
  //                 "Invoice Date: ${DateFormat('dd MMM, yyyy').format(DateTime.parse(orderDetails!.date!))}",
  //                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //               ),
  //               Text(
  //                 "Order Status: ${orderDetails!.status}",
  //                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(height: 10),
  //               Text(
  //                 "Order Value: ${orderDetails!.packageValue}",
  //                 style: const TextStyle(fontSize: 12),
  //               ),
  //               Text(
  //                 "Content: ${orderDetails!.packageContent}",
  //                 style: const TextStyle(fontSize: 12),
  //               ),
  //               Text(
  //                 "Weight: ${orderDetails!.weightRange}",
  //                 style: const TextStyle(fontSize: 12),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ],
  //       cellHeight: 30,
  //       columnWidths: const <int, TableColumnWidth>{
  //         0: FlexColumnWidth(),
  //         1: FlexColumnWidth(),
  //       },
  //       cellAlignments: {
  //         0: Alignment.centerLeft,
  //         1: Alignment.centerLeft,
  //       },
  //     ),
  //   );
  // }

  // static Widget itemsPart() {
  //   return Container(
  //     width: double.infinity,
  //     decoration: const BoxDecoration(
  //       border: Border(
  //         left: BorderSide(),
  //         right: BorderSide(),
  //         bottom: BorderSide(),
  //       ),
  //     ),
  //     child: TableHelper.fromTextArray(
  //       headers: ['Item', 'Cost', 'Distance', 'Extra Charge', 'Total'],
  //       data: [
  //         [
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                   "From: ${orderDetails!.fromAddress} ${orderDetails!.fromAddress2}"),
  //               SizedBox(height: 10),
  //               Text(
  //                   "To: ${orderDetails!.toAddress} ${orderDetails!.toAddress2}"),
  //             ],
  //           ),
  //           '${orderDetails!.subTotal}',
  //           '${orderDetails!.direction!.distance}',
  //           '${orderDetails!.extendedDistanceCharge}',
  //           '${orderDetails!.netPayable}'
  //         ],
  //         [
  //           Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
  //           Text('${orderDetails!.subTotal}',
  //               style: TextStyle(fontWeight: FontWeight.bold)),
  //           Text('${orderDetails!.direction!.distance}',
  //               style: TextStyle(fontWeight: FontWeight.bold)),
  //           Text('${orderDetails!.extendedDistanceCharge}',
  //               style: TextStyle(fontWeight: FontWeight.bold)),
  //           Text('${orderDetails!.netPayable}',
  //               style: TextStyle(fontWeight: FontWeight.bold))
  //         ]
  //       ],
  //       headerStyle: TextStyle(fontWeight: FontWeight.bold),
  //       headerDecoration: const BoxDecoration(color: PdfColors.grey300),
  //       cellHeight: 30,
  //       columnWidths: const <int, TableColumnWidth>{
  //         0: FlexColumnWidth(),
  //         1: IntrinsicColumnWidth(),
  //         2: IntrinsicColumnWidth(),
  //         3: IntrinsicColumnWidth(),
  //         4: IntrinsicColumnWidth(),
  //       },
  //       cellAlignments: {
  //         0: Alignment.centerLeft,
  //         1: Alignment.center,
  //         2: Alignment.center,
  //         3: Alignment.center,
  //         4: Alignment.center,
  //       },
  //     ),
  //   );
  // }

  // static Widget amountPart() {
  //   return Container(
  //     width: double.infinity,
  //     decoration: const BoxDecoration(
  //       border: Border(
  //         left: BorderSide(),
  //         right: BorderSide(),
  //         bottom: BorderSide(),
  //       ),
  //     ),
  //     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
  //     child: Text(
  //       "Amount in words: ${AmountToWords().convertAmountToWords(orderDetails!.netPayable!, ignoreDecimal: false)} ONLY",
  //       style: TextStyle(
  //         fontSize: 12,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // }

  static Widget thanksNote() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(),
          right: BorderSide(),
          bottom: BorderSide(),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Thanks for choosing My Postmates, Vivek!",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static Widget termsPart() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(),
          right: BorderSide(),
          bottom: BorderSide(),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Terms & Conditions:",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            "1. Price shown is non-inclusive of certain fees such as tolls/tunnels, parking or any other charges agreed upon with the rider.",
            style: const TextStyle(fontSize: 9),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            "2. If you have any issues or queries in respect of your order, please contact customer chat support through My Postmates platform or drop in email at info@mypostmates.in",
            style: const TextStyle(fontSize: 9),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            "3. Please note that we never ask for bank account details such as CVV, account number, UPI Pin, etc. across our support channels. For your safety please do not share these details with anyone over any medium.",
            style: const TextStyle(fontSize: 9),
          ),
        ],
      ),
    );
  }

  static Widget footerPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Divider(),
        SizedBox(height: 2 * PdfPageFormat.mm),
        Text("Visit our website: https://mypostmates.in")
      ],
    );
  }
}
