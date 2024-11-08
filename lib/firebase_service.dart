import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addReceipt({
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required String customerName,
    required String packageType,
    required String paymentType,
    required String period,
    required double price,
  }) async {
    try {
      await _firestore.collection('receipts').add({
        'checkInDate': checkInDate,
        'checkOutDate': checkOutDate,
        'customerName': customerName,
        'packageType': packageType,
        'paymentType': paymentType,
        'period': period,
        'price': price,
        'dateCreated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding receipt: $e');
    }
  }
}