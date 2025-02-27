import 'dart:io';
import 'package:flutter/services.dart';
import 'package:ngf_organic/Models/order_detail_model.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:indian_currency_to_word/indian_currency_to_word.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static OrderDetailModel? orderDetails;
  static double taxAmount = 0;
  static Future<File> generate({required OrderDetailModel orderDetails}) async {
    // Company logo
    final ByteData companyLogoBytes =
        await rootBundle.load('assets/images/logo.png');
    final Uint8List companyLogo = companyLogoBytes.buffer.asUint8List();

    // authroised signatory
    final ByteData authSignBytes =
        await rootBundle.load('assets/images/signature.png');
    final Uint8List authSignature = authSignBytes.buffer.asUint8List();

    PdfInvoiceApi.orderDetails = orderDetails;
    PdfInvoiceApi.taxAmount =
        orderDetails.subTotal * (orderDetails.taxRate / 100);

    final pdf = Document();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      build: (context) => [
        headerPart(companyLogo),
        billingPart(),
        itemsPart(),
        amountPart(),
        signaturePart(authSignature),
        // termsPart(),
      ],
      footer: (context) => footerPart(),
    ));
    return saveDocument(
        name: "NGFOrganic_Invoice_${orderDetails.shoppingOrderId}.pdf",
        pdf: pdf);
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
            Text("NIGHTBIRDES HUB (OPC) PRIVATE LIMITED",
                style: TextStyle(fontSize: 8)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SOLD BY:",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "NIGHTBIRDES HUB (OPC) PRIVATE LIMITED",
                  style: const TextStyle(fontSize: 10),
                ),
                Text(
                  """Floor No.: SECOND FLOOR
Building No./Flat No.: NO 5/10-73
Road/Street: SEVENWELL STREET ST.THOMAS MOUNT
City/Town/Village: Chennai
District: Chennai
State: Tamil Nadu
PIN Code: 600016""",
                  style: const TextStyle(fontSize: 10),
                ),
                SizedBox(height: 20),
                Text(
                  "GST Registration No:33AAJCN0176A1ZY",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "Order Number: ${orderDetails?.shoppingOrderId}",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Order Date: ${kDateFormat(orderDetails!.orderDate)}",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "BILLING/SHIPPING ADDRESS",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 10),
                Text(
                  "${orderDetails?.shippingName}",
                  style: const TextStyle(fontSize: 10),
                  textAlign: TextAlign.right,
                ),
                Text(
                  "${orderDetails?.shippingAddress}",
                  style: const TextStyle(fontSize: 10),
                  textAlign: TextAlign.right,
                ),
                Text(
                  "Place of supply:${orderDetails?.shippingState}",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Place of delivery:${orderDetails?.shippingState}",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget itemsPart() {
    double unitPrice = orderDetails!.salePrice - PdfInvoiceApi.taxAmount;
    double netAmount =
        orderDetails!.subTotal - (PdfInvoiceApi.taxAmount * orderDetails!.qty);
    double taxPercent = orderDetails!.taxRate;
    double taxAmount = PdfInvoiceApi.taxAmount * orderDetails!.qty;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(),
          right: BorderSide(),
          bottom: BorderSide(),
        ),
      ),
      child: Table(
        columnWidths: {
          0: FixedColumnWidth(40), // Sl. No.
          1: FixedColumnWidth(200), // Description (fixed width)
          2: FixedColumnWidth(70), // Unit Price
          3: FixedColumnWidth(50), // Qty
          4: FixedColumnWidth(80), // Net Amount
          5: FixedColumnWidth(50), // Tax Rate
          6: FixedColumnWidth(80), // Tax Amount
          7: FixedColumnWidth(80), // Discount
          8: FixedColumnWidth(100), // Total Amount
        },
        border: TableBorder.all(),
        children: [
          TableRow(
            decoration: const BoxDecoration(color: PdfColors.grey300),
            children: [
              textCell('Sl. No.', bold: true),
              textCell('Description', bold: true),
              textCell('Unit Price', bold: true),
              textCell('Qty', bold: true),
              textCell('Net Amount', bold: true),
              textCell('Tax Rate', bold: true),
              textCell('Tax Amount', bold: true),
              textCell('Discount', bold: true),
              textCell('Total Amount', bold: true),
            ],
          ),
          TableRow(
            children: [
              textCell("1"),
              textCell(
                '${orderDetails?.name} - ${orderDetails?.attributeValue}',
              ), // Truncate if too long
              textCell(
                  kCurrencyFormat(unitPrice, decimalDigits: 2, symbol: "")),
              textCell('${orderDetails?.qty}'),
              textCell(
                  kCurrencyFormat(netAmount, decimalDigits: 2, symbol: "")),
              textCell('${taxPercent.toStringAsFixed(1)}%'),
              textCell(
                  kCurrencyFormat(taxAmount, decimalDigits: 2, symbol: "")),
              textCell(kCurrencyFormat(orderDetails!.couponDiscount,
                  decimalDigits: 2, symbol: "")),
              textCell(kCurrencyFormat(orderDetails!.netPayable,
                  decimalDigits: 2, symbol: "")),
            ],
          ),
          TableRow(
            children: [
              textCell(''),
              textCell('Total', bold: true),
              textCell(''),
              textCell(''),
              textCell(kCurrencyFormat(netAmount, decimalDigits: 2, symbol: ""),
                  bold: true),
              textCell(''),
              textCell(kCurrencyFormat(taxAmount, decimalDigits: 2, symbol: ""),
                  bold: true),
              textCell(
                  kCurrencyFormat(orderDetails!.couponDiscount,
                      decimalDigits: 2, symbol: ""),
                  bold: true),
              textCell(
                  kCurrencyFormat(orderDetails!.netPayable,
                      decimalDigits: 2, symbol: ""),
                  bold: true),
            ],
          ),
        ],
      ),
    );
  }

// Helper function to create a text cell
  static Widget textCell(String text, {bool bold = false, int maxLines = 5}) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: 8),
        maxLines: maxLines,
        // overflow: TextOverflow.ellipsis,
      ),
    );
  }

  static Widget amountPart() {
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
      child: Text(
        "Amount in words: ${AmountToWords().convertAmountToWords(orderDetails!.netPayable, ignoreDecimal: false)} ONLY",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget signaturePart(authSignature) {
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "For NIGHTBIRDES HUB (OPC) PRIVATE LIMITED:",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Image(
            MemoryImage(
              authSignature,
            ),
            height: 20,
            width: 50,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(
            "Authorized Signatory",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
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
        Text("Visit our website: https://ngforganic.com")
      ],
    );
  }
}
