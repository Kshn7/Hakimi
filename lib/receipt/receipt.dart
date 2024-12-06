import 'package:flutter/material.dart';

class ReceiptGenerator extends StatefulWidget {
  const ReceiptGenerator({super.key});

  @override
  State<ReceiptGenerator> createState() => _ReceiptGeneratorState();
}

class _ReceiptGeneratorState extends State<ReceiptGenerator> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BigBox(),
          SizedBox(height: 10),
          Center(
            child: Text(
              'Preview',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          CustomInputField(
            initialValue: '',
            hintText: 'Customer details',
          ),
          SizedBox(height: 6),
          CustomInputField(
            hintText: 'Customer number',
          ),
          SizedBox(height: 12),
          ReceiptDetails(),
          SizedBox(height: 12),
          GenerateButton(),
        ],
      ),
    );
  }
}

class ReceiptDetails extends StatelessWidget {
  const ReceiptDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildDetailCard(title: 'Package', content: '6 Bilik\n6 Bilik Air'),
            const SizedBox(width: 6),
            buildDetailCard(title: 'Payment', content: 'Deposit'),
            const SizedBox(width: 6),
            buildDetailCard(title: 'Price', content: 'RM 350'),
            const SizedBox(width: 6),
            buildDetailCard(title: 'Date', content: '17/10/2024 -\n19/10/2024'),
          ],
        ),
      ),
    );
  }

  Widget buildDetailCard({required String title, required String content}) {
    return Container(
      width: 100,
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
          Container(
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
}

class BigBox extends StatelessWidget {
  const BigBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                const LowerLabelInputBoxes(),
                const SizedBox(height: 10),
                const ResitRasmiButton(),
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
    );
  }
}

class LowerLabelInputBoxes extends StatelessWidget {
  const LowerLabelInputBoxes({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LowerLabelInputBox(label: 'Nama'),
              SizedBox(height: 6),
              LowerLabelInputBox(label: 'Tarikh'),
              SizedBox(height: 6),
              LowerLabelInputBox(label: 'Jumlah'),
            ],
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LowerLabelInputBox(label: 'Pakej'),
              SizedBox(height: 6),
              LowerLabelInputBox(label: 'Penginapan'),
              SizedBox(height: 6),
              LowerLabelInputBox(label: 'Bayaran'),
            ],
          ),
        ),
      ],
    );
  }
}

class LowerLabelInputBox extends StatelessWidget {
  final String label;

  const LowerLabelInputBox({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            '$label:',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          ),
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String? initialValue;
  final String? hintText;

  const CustomInputField({super.key, this.initialValue, this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      initialValue: initialValue,
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

class GenerateButton extends StatelessWidget {
  const GenerateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.autorenew, color: Colors.white, size: 12),
        label: const Text(
          'Generate',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
      ),
    );
  }
}
