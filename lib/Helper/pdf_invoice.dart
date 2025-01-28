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
        billingPart(),
        itemsPart(),
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
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        children: [
          Image(
            MemoryImage(
              companyLogo,
            ),
            height: 30,
            width: 30,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 10,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("NGF Organic", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Nightbirdes Hub OPC Pvt", style: TextStyle(fontSize: 8)),
          ]),
          Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(
              "Tax Invoice/Bill of Supply/Cash Memo",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "(Original for Recipient)",
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
            ),
          ]),
        ],
      ),
    );
  }

  static Widget billingPart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "SOLD BY:",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              "COMPANY NAME",
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              "Full Address here with state,\ncity, pincode and\ncountry code",
              style: const TextStyle(fontSize: 12),
            ),
            SizedBox(height: 20),
            Text(
              "PAN No:MKAL00SOLS",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              "GST Registration No:19AAKAOLS9DKIOD",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Order Number: 6778",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              "Order Date: 01-02-2025",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ]),
          SizedBox(width: 30),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(
              "BILLING/SHIPPING ADDRESS",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            Text(
              "Vivek Verma",
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.right,
            ),
            Text(
              "Full Address here with state,\ncity, pincode and\ncountry code",
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.right,
            ),
            Text(
              "Place of supply:WEST BENGAL",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              "Place of delivery:WEST BENGAL",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ])
        ],
      ),
    );
  }

  static Widget itemsPart() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(),
          right: BorderSide(),
          bottom: BorderSide(),
        ),
      ),
      child: TableHelper.fromTextArray(
        headers: [
          'Sl. No.',
          'Description',
          'Unit Price',
          'Qty',
          'Net Amount',
          'Tax Rate',
          'Tax Amount',
          'Total Amount'
        ],
        data: [
          [
            "1",
            'Bamboo Brush (Non-pLastic) Stylish brush, Choose bamboo over plastic',
            '',
            '',
            ''
          ],
          [
            "",
            "",
            "",
            Text('', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('', style: TextStyle(fontWeight: FontWeight.bold))
          ]
        ],
        headerStyle: TextStyle(fontWeight: FontWeight.bold),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        cellHeight: 30,
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(),
          1: IntrinsicColumnWidth(),
          2: IntrinsicColumnWidth(),
          3: IntrinsicColumnWidth(),
          4: IntrinsicColumnWidth(),
        },
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.center,
          2: Alignment.center,
          3: Alignment.center,
          4: Alignment.center,
        },
      ),
    );
  }

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
