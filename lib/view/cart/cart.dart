import 'package:super_store_e_commerce_flutter/imports.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final TextEditingController _addressController = TextEditingController();
  String _selectedPaymentMethod = 'Credit Card';
  bool _isGeneratingBill = false;

  Future<void> _generateBill(BuildContext context, CartProvider cart) async {
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty')),
      );
      return;
    }

    setState(() {
      _isGeneratingBill = true;
    });

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("SUPER STORE",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 24)),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text("INVOICE",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 24)),
                        pw.SizedBox(height: 5),
                        pw.Text(
                            "Invoice #: INV-${DateTime.now().millisecondsSinceEpoch}"),
                        pw.Text(
                            "Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}"),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),
                pw.Text("Super Store E-Commerce",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 20)),
                pw.Text("123 Store Street, E-Commerce City"),
                pw.Text("Phone: +1 234 567 890"),
                pw.Text("Email: support@superstore.com"),
                pw.SizedBox(height: 20),
                pw.Text("Bill To:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(_addressController.text.isNotEmpty
                    ? _addressController.text
                    : "Customer Address"),
                pw.SizedBox(height: 20),
                pw.Text("Payment Method: $_selectedPaymentMethod"),
                pw.SizedBox(height: 30),
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FractionColumnWidth(0.1),
                    1: const pw.FractionColumnWidth(0.4),
                    2: const pw.FractionColumnWidth(0.15),
                    3: const pw.FractionColumnWidth(0.15),
                    4: const pw.FractionColumnWidth(0.2),
                  },
                  children: [
                    pw.TableRow(
                      decoration:
                          const pw.BoxDecoration(color: PdfColors.grey300),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text("No.",
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text("Item",
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text("Price",
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text("Qty",
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text("Total",
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                      ],
                    ),
                    ...cart.items.asMap().entries.map((entry) {
                      int idx = entry.key;
                      CartModel item = entry.value;
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text((idx + 1).toString()),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(item.title ?? "Unknown Product"),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                                "₹${item.price?.toStringAsFixed(2) ?? '0.00'}"),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text("${item.quantity ?? 0}"),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                                "₹${item.totalPrice?.toStringAsFixed(2) ?? '0.00'}"),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Row(
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          pw.Container(
                            width: 100,
                            child: pw.Text("Subtotal:",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Text("₹${cart.totalPrice().toStringAsFixed(2)}"),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          pw.Container(
                            width: 100,
                            child: pw.Text("Tax (5%):",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Text(
                              "₹${(cart.totalPrice() * 0.05).toStringAsFixed(2)}"),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Divider(),
                      pw.Row(
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          pw.Container(
                            width: 100,
                            child: pw.Text("Total:",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Text(
                            "₹${(cart.totalPrice() * 1.05).toStringAsFixed(2)}",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 40),
                pw.Text("Thank you for shopping with us!",
                    style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
                pw.SizedBox(height: 5),
                pw.Text(
                    "For any inquiries, please contact our customer service."),
              ],
            );
          },
        ),
      );

      // Instead of saving to a file, display a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invoice generated successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Show order placement success
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Order Placed!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your order has been placed successfully!'),
              const SizedBox(height: 10),
              Text('Shipping Address: ${_addressController.text}'),
              Text('Payment Method: $_selectedPaymentMethod'),
              const SizedBox(height: 10),
              Text(
                  'Total Amount: ₹${(cart.totalPrice() * 1.05).toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Clear cart after successful order
                cart.clearCart();
                // Navigate back to home
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const Home()),
                  (route) => false,
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

      setState(() {
        _isGeneratingBill = false;
      });
    } catch (e) {
      setState(() {
        _isGeneratingBill = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating bill: $e')),
      );
    }
  }

  void _showCheckoutDialog(BuildContext context, CartProvider cart) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Checkout',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Shipping Address',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            const Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: ['Credit Card', 'PayPal', 'Cash on Delivery']
                  .map((method) => DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _generateBill(context, cart);
                    },
                    child: const Text(
                      'Generate Bill',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const AppNameWidget(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              height: 25,
              width: 25,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.black),
              child: TextBuilder(
                text: cart.itemCount.toString(),
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: cart.items.isEmpty
            ? const Center(
                child: Text('Your cart is empty'),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(15),
                itemCount: cart.items.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int i) {
                  return CartCard(cart: cart.items[i]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 10.0);
                },
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          height: 60,
          color: Colors.black,
          minWidth: size.width,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onPressed: _isGeneratingBill
              ? null
              : () => _showCheckoutDialog(context, cart),
          child: _isGeneratingBill
              ? const CircularProgressIndicator(color: Colors.white)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextBuilder(
                        text:
                            '₹ ${(cart.totalPrice() * 1.05).toStringAsFixed(2)}',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                    const SizedBox(width: 10.0),
                    const TextBuilder(
                      text: 'Checkout',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
