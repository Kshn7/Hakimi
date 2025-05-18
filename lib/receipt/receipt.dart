import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart'
    as pw; // Add pdf package for handling printing
import 'package:printing/printing.dart';

class ReceiptGenerator extends StatefulWidget {
  const ReceiptGenerator({super.key});

  @override
  State<ReceiptGenerator> createState() => _ReceiptGeneratorState();
}

class _ReceiptGeneratorState extends State<ReceiptGenerator> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _custNameController = TextEditingController();
  final TextEditingController _custNumberController = TextEditingController();
  final TextEditingController _packageNameController = TextEditingController();
  final TextEditingController _packagePriceController = TextEditingController();

  String custname = '';
  String custnumber = '';
  String packageName = '';
  String packagePrice = '';
  String receiptNumber = DateTime.now().millisecondsSinceEpoch.toString();
  bool isDetailsSaved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Customer Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Customer Name Input
                  CustomInputField(
                    controller: _custNameController,
                    hintText: 'Customer Name',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter customer name'
                        : null,
                  ),
                  const SizedBox(height: 12),

                  // Customer Number Input
                  CustomInputField(
                    controller: _custNumberController,
                    hintText: 'Customer Number',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter customer number';
                      } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                        return 'Only digits allowed';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Package Name Input
                  CustomInputField(
                    controller: _packageNameController,
                    hintText: 'Package Name',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter package name'
                        : null,
                  ),
                  const SizedBox(height: 12),

                  // Package Price Input
                  CustomInputField(
                    controller: _packagePriceController,
                    hintText: 'Package Price',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter package price';
                      } else if (double.tryParse(value) == null) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            custname = _custNameController.text.trim();
                            custnumber = _custNumberController.text.trim();
                            packageName = _packageNameController.text.trim();
                            packagePrice = _packagePriceController.text.trim();
                            isDetailsSaved = true;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Details saved')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blueAccent, // Match your home page
                        foregroundColor: Colors.white,
                        elevation: 4,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.save, size: 20),
                          SizedBox(width: 8),
                          Text('Save Details'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Preview Section
                  if (isDetailsSaved) ...[
                    const Center(
                      child: Text(
                        'Receipt Preview',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 10),
                    BigBox(
                      custname: custname,
                      custnumber: custnumber,
                      packageName: packageName,
                      packagePrice: packagePrice,
                      bookingDate: DateTime.now(),
                    ),
                  ] else ...[
                    const Center(
                      child: Text(
                        'Please save the customer details to preview the receipt.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BigBox extends StatefulWidget {
  final String custname;
  final String custnumber;
  final String packageName;
  final String packagePrice;
  final DateTime bookingDate;

  const BigBox({
    super.key,
    required this.custname,
    required this.custnumber,
    required this.packageName,
    required this.packagePrice,
    required this.bookingDate,
  });

  @override
  State<BigBox> createState() => _BigBoxState();
}

class _BigBoxState extends State<BigBox> {
  final keyPrint = GlobalKey();
  bool printing = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double maxWidth = screenWidth > 600 ? 1000 : double.infinity;

    return RepaintBoundary(
      key: keyPrint,
      child: Center(
        child: Container(
          width: maxWidth,
          decoration: BoxDecoration(
            border:
                Border.all(color: Colors.black.withOpacity(0.5), width: 1.0),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section with Homestay and Contact Information
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Homestay',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'No. 3, Jalan Yoga 13/42,\nSeksyen 13, 40100 Shah Alam,\nSelangor',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          SizedBox(height: 4),
                          Text('WhatsApp +60123456789',
                              style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.home,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),

              // Customer Information Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LowerLabelInputBoxes(
                  custname: widget.custname,
                  price: widget.packagePrice,
                  packageName: widget.packageName,
                ),
              ),
              const Divider(),

              // Receipt Information Section (No and Date)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('No: 123456', style: TextStyle(fontSize: 14)),
                    Text(
                        'Tarikh: ${widget.bookingDate.day}/${widget.bookingDate.month}/${widget.bookingDate.year}',
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Footer Section (Additional Text)
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Resit ini adalah cetakan komputer',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Only display the Generate Button if not in print mode
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  color: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Icon(Icons.music_note, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Icon(Icons.facebook, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Icon(Icons.play_circle_filled,
                          color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Text(
                        '@ASTANA_RIA_DRAJA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              printing
                  ? const SizedBox.shrink()
                  : // Can adjust based on your needs
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GenerateButton(
                        onGenerate: () async {
                          setState(() {
                            printing = !printing;
                          });

                          final pdf = pw.Document();

                          await Future.delayed(
                              const Duration(milliseconds: 100));
                          final imageBytes =
                              await _captureWidgetToImage(keyPrint);

                          pdf.addPage(
                            pw.Page(
                              pageFormat: PdfPageFormat.a4,
                              margin: const pw.EdgeInsets.all(32),
                              build: (pw.Context context) {
                                return pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    // Header Section
                                    pw.Text('ASTANA RIA D\'RAJA HOMESTAY',
                                        style: pw.TextStyle(
                                            fontSize: 20,
                                            fontWeight: pw.FontWeight.bold)),
                                    pw.SizedBox(height: 4),
                                    pw.Text(
                                        'No. 3, Jalan Yoga 13/42, Seksyen 13,\n40100 Shah Alam, Selangor',
                                        style: pw.TextStyle(fontSize: 12)),
                                    pw.Text('WhatsApp: +60123456789',
                                        style: pw.TextStyle(fontSize: 12)),
                                    pw.Divider(thickness: 1),
                                    pw.SizedBox(height: 10),

                                    pw.Image(pw.MemoryImage(imageBytes!)),

                                    // Footer
                                    pw.Text(
                                        'This is a computer-generated receipt.',
                                        style: pw.TextStyle(
                                            fontSize: 10,
                                            color: PdfColors.grey)),
                                    pw.SizedBox(height: 12),
                                    pw.Divider(thickness: 1),
                                    pw.Align(
                                      alignment: pw.Alignment.center,
                                      child: pw.Text(
                                        '@ASTANA_RIA_DRAJA',
                                        style: pw.TextStyle(
                                            fontSize: 12,
                                            fontWeight: pw.FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );

                          await Printing.layoutPdf(
                            onLayout: (PdfPageFormat format) async {
                              return pdf.save();
                            },
                          );

                          setState(() {
                            printing = !printing;
                          });
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Uint8List?> _captureWidgetToImage(GlobalKey key) async {
    // Ensure that the key has a valid context
    if (key.currentContext == null) {
      return null; // Or handle the error as appropriate
    }

    // Get the render object of the widget using the key
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    // Capture the image from the RenderRepaintBoundary
    var image = await boundary.toImage(pixelRatio: 3.0);

    // Convert the captured image to byte data
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

    // Check if byteData is null and handle accordingly
    if (byteData == null) {
      return null; // Or handle the error as appropriate
    }

    // Return the Uint8List from the byte data
    return byteData.buffer.asUint8List();
  }
}

class LowerLabelInputBoxes extends StatefulWidget {
  final String custname;
  String price;
  String packageName;
  LowerLabelInputBoxes(
      {super.key,
      required this.custname,
      required this.price,
      required this.packageName});

  @override
  _LowerLabelInputBoxesState createState() => _LowerLabelInputBoxesState();
}

class _LowerLabelInputBoxesState extends State<LowerLabelInputBoxes> {
  String tarikhContent = '2025-05-18';
  String bayaranContent = 'Paid';

  // Save the details to be used for generating the receipt
  void _saveDetails() {
    // For now, we'll just print the details to the console
    print('Saved Details:');
    print('Name: ${widget.custname}');
    print('Date: $tarikhContent');
    print('Amount: ${widget.price}');
    print('Package: ${widget.packageName}');
    print('Payment Status: $bayaranContent');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LowerLabelInputBox(label: 'Nama', content: widget.custname),
              const SizedBox(height: 8),
              LowerLabelInputBox(
                label: 'Tarikh',
                content: tarikhContent,
                onSave: (newContent) =>
                    setState(() => tarikhContent = newContent),
              ),
              const SizedBox(height: 8),
              LowerLabelInputBox(
                label: 'Jumlah',
                content: widget.price,
                onSave: (newContent) =>
                    setState(() => widget.price = newContent),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LowerLabelInputBox(
                label: 'Pakej',
                content: widget.packageName,
                onSave: (newContent) =>
                    setState(() => widget.packageName = newContent),
              ),
              const SizedBox(height: 8),
              LowerLabelInputBox(
                label: 'Penginapan',
                content: bayaranContent,
                onSave: (newContent) =>
                    setState(() => bayaranContent = newContent),
              ),
              const SizedBox(height: 8),
              LowerLabelInputBox(label: 'Bayaran', content: bayaranContent),
            ],
          ),
        ),
      ],
    );
  }

  // Method to update fields and save details when user presses the "Save" button
  void saveDetails() {
    _saveDetails();
  }
}

class LowerLabelInputBox extends StatelessWidget {
  final String label;
  final String content;
  final Function(String)? onSave;

  const LowerLabelInputBox({
    super.key,
    required this.label,
    required this.content,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            if (label == 'Tarikh') {
              _showDatePicker(context, label, content, onSave);
            } else {
              _showPopup(context, label, content, onSave);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue),
            ),
            child: Text(content, style: TextStyle(fontSize: 14)),
          ),
        ),
      ],
    );
  }

  void _showPopup(BuildContext context, String title, String initialContent,
      Function(String)? onSave) {
    TextEditingController controller =
        TextEditingController(text: initialContent);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter new $title details',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newContent = controller.text;
                if (onSave != null) {
                  onSave(newContent);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDatePicker(BuildContext context, String title,
      String initialContent, Function(String)? onSave) {
    DateTime initialDate = DateTime.now();
    if (initialContent != 'dateContent') {
      initialDate = DateTime.parse(initialContent);
    }

    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ).then((selectedDate) {
      if (selectedDate != null) {
        String formattedDate =
            "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
        if (onSave != null) {
          onSave(formattedDate);
        }
      }
    });
  }
}

// Generate button to trigger receipt generation or save functionality
class GenerateButton extends StatelessWidget {
  final VoidCallback onGenerate;

  const GenerateButton({super.key, required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onGenerate,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Generate Receipt',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool autofocus;
  final IconData? icon;

  const CustomInputField({
    Key? key,
    this.controller,
    required this.hintText,
    this.validator,
    this.keyboardType,
    this.autofocus = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        autofocus: autofocus,
        decoration: InputDecoration(
          prefixIcon:
              icon != null ? Icon(icon, color: Colors.blueAccent) : null,
          labelText: hintText,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class ResitRasmiButton extends StatelessWidget {
  const ResitRasmiButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FixedSizeButton(
        text: 'RESIT RASMI',
        onPressed: () {},
      ),
    );
  }
}

class FixedSizeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const FixedSizeButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
