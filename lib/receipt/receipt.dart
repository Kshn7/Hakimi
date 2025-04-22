import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReceiptGenerator extends StatefulWidget {
  const ReceiptGenerator({super.key});

  @override
  State<ReceiptGenerator> createState() => _ReceiptGeneratorState();
}

class _ReceiptGeneratorState extends State<ReceiptGenerator> {
  // Create a GlobalKey to capture the widget
  final key = GlobalKey();
  final TextEditingController _custNameController = TextEditingController();
  final TextEditingController _custNumberController = TextEditingController();

  String custname = '';
  String custnumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth > 600 ? 800 : double.infinity,
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Center(
                            child: Text(
                              'Form',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomInputField(
                            controller: _custNameController,
                            hintText: 'Customer details',
                          ),
                          const SizedBox(height: 6),
                          CustomInputField(
                            controller: _custNumberController,
                            hintText: 'Customer number',
                          ),
                          const SizedBox(height: 12),
                          const ReceiptDetails(),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      custname = _custNameController.text;
                                      custnumber = _custNumberController.text;
                                    });

                                    print('Customer Name: $custname');
                                    print('Customer Number: $custnumber');
                                  },
                                  child: const Text('Save Details'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _generateAndPrintPDF();
                                  },
                                  icon: const Icon(Icons.autorenew,
                                      color: Colors.white, size: 12),
                                  label: const Text(
                                    'Generate',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Center(
                            child: Text(
                              'Preview',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          RepaintBoundary(
                            key: key,
                            child: BigBox(custname: custname),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

// Function to generate and print PDF
  void _generateAndPrintPDF() async {
    final pdf = pw.Document();

    // Wait for the widget to be painted and then capture the image
    await Future.delayed(Duration(milliseconds: 100));

    // Capture the image as a byte array
    final imageBytes = await _captureWidgetToImage(key);

    // Add a page to the PDF and insert the captured image
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pw.MemoryImage(
              imageBytes,
            )),
          );
        },
      ),
    );

    // Use the printing package to preview and print the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        return pdf.save(); // Return the PDF bytes to print or preview
      },
    );
  } // Function to capture the widget as an image in bytes

  Future<Uint8List> _captureWidgetToImage(GlobalKey key) async {
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}

class ReceiptDetails extends StatefulWidget {
  const ReceiptDetails({super.key});

  @override
  _ReceiptDetailsState createState() => _ReceiptDetailsState();
}

class _ReceiptDetailsState extends State<ReceiptDetails> {
  // Define state variables for each box's content
  String packageContent = '';
  String paymentContent = '';
  String priceContent = '';
  String dateContent = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildDetailCard(
              title: 'Package',
              content: packageContent,
              context: context,
              onSave: (newContent) {
                setState(() {
                  packageContent = newContent; // Update the content state
                });
              },
            ),
            const SizedBox(width: 6),
            buildDetailCard(
              title: 'Payment',
              content: paymentContent,
              context: context,
              onSave: (newContent) {
                setState(() {
                  paymentContent = newContent; // Update the content state
                });
              },
            ),
            const SizedBox(width: 6),
            buildDetailCard(
              title: 'Price',
              content: priceContent,
              context: context,
              onSave: (newContent) {
                setState(() {
                  priceContent = newContent; // Update the content state
                });
              },
            ),
            const SizedBox(width: 6),
            buildDetailCard(
              title: 'Date',
              content: dateContent,
              context: context,
              onSave: (newContent) {
                setState(() {
                  dateContent = newContent; // Update the content state
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailCard({
    required String title,
    required String content,
    required BuildContext context,
    required Function(String) onSave, // Callback for saving the new content
  }) {
    return Container(
      width: 160,
      height: 60,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              _showPopup(context, title, content, onSave);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(2.0),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6.0),
                  topRight: Radius.circular(6.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.edit, color: Colors.white, size: 10),
                ],
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            content,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showPopup(BuildContext context, String title, String initialContent,
      Function(String) onSave) {
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newContent = controller.text;
                onSave(newContent); // Call onSave to update the content
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class BigBox extends StatelessWidget {
  final String custname;

  const BigBox({super.key, required this.custname});

  @override
  Widget build(BuildContext context) {
    // Get screen width to apply responsive max width
    double screenWidth = MediaQuery.of(context).size.width;
    double maxWidth = screenWidth > 600 ? 1000 : double.infinity;

    return Center(
      child: Container(
        width: maxWidth,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Homestay',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'No. 3, Jalan Yoga 13/42,\nSeksyen 13, 40100 Shah Alam,\nSelangor',
                              style: TextStyle(fontSize: 10),
                            ),
                            SizedBox(height: 2),
                            Text('WhatsApp +60123456789',
                                style: TextStyle(fontSize: 10)),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Text('No: ......................',
                                    style: TextStyle(fontSize: 10)),
                                SizedBox(width: 8),
                                Text('Tarikh: ...............................',
                                    style: TextStyle(fontSize: 10)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.home,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LowerLabelInputBoxes(
                    custname: custname, // Retrieve the value dynamically
                  ),
                  const SizedBox(height: 4),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Resit ini adalah cetakan komputer',
                      style: TextStyle(fontSize: 10, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Icon(Icons.music_note, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Icon(Icons.facebook, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Icon(Icons.play_circle_filled, color: Colors.white, size: 20),
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
          ],
        ),
      ),
    );
  }
}

class LowerLabelInputBoxes extends StatefulWidget {
  final String custname; // Pass customer name from parent widget
  const LowerLabelInputBoxes({super.key, required this.custname});

  @override
  _LowerLabelInputBoxesState createState() => _LowerLabelInputBoxesState();
}

class _LowerLabelInputBoxesState extends State<LowerLabelInputBoxes> {
  // Default content for the input boxes
  String tarikhContent = 'dateContent';
  String jumlahContent = 'priceContent';
  String pakejContent = 'packageContent';
  String bayaranContent = 'paymentContent';

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LowerLabelInputBox(
                label: 'Nama',
                content: widget.custname, // Use custname passed from parent
              ),
              const SizedBox(height: 6),
              LowerLabelInputBox(
                label: 'Tarikh',
                content: tarikhContent,
                onSave: (newContent) {
                  setState(() {
                    tarikhContent = newContent;
                  });
                },
              ),
              const SizedBox(height: 6),
              LowerLabelInputBox(
                label: 'Jumlah',
                content: jumlahContent,
                onSave: (newContent) {
                  setState(() {
                    jumlahContent = newContent;
                  });
                },
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
                content: pakejContent,
                onSave: (newContent) {
                  setState(() {
                    pakejContent = newContent;
                  });
                },
              ),
              const SizedBox(height: 6),
              LowerLabelInputBox(
                label: 'Penginapan',
                content: bayaranContent,
                onSave: (newContent) {
                  setState(() {
                    bayaranContent = newContent;
                  });
                },
              ),
              const SizedBox(height: 6),
              LowerLabelInputBox(
                label: 'Bayaran',
                content: 'Paid', // Static content
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Method to update the input fields when called from ReceiptDetails
  void updateFields(
      String tarikh, String jumlah, String pakej, String bayaran) {
    setState(() {
      tarikhContent = tarikh;
      jumlahContent = jumlah;
      pakejContent = pakej;
      bayaranContent = bayaran;
    });
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
        Text(label),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            _showPopup(context, label, content, onSave);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue),
            ),
            child: Text(content),
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newContent = controller.text;
                if (onSave != null) {
                  onSave(newContent); // Call onSave to update the content
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
}

class CustomInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;

  const CustomInputField({
    Key? key,
    this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
        child: const Text(
          'RESIT RASMI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
