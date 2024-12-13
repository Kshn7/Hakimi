import 'package:cloud_firestore/cloud_firestore.dart';

class BookingCalendarBackend {
  final CollectionReference bookings =
  FirebaseFirestore.instance.collection('bookings');

  /// Fetches all booked dates from Firebase
  Future<List<DateTime>> fetchBookedDates() async {
    try {
      QuerySnapshot snapshot = await bookings.get();

      // Convert Firestore data to a list of DateTime
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final date = (data['date'] as Timestamp).toDate();
        return date;
      }).toList();
    } catch (e) {
      print('Error fetching booked dates: $e');
      return [];
    }
  }

  /// Adds a new booking to Firebase
  Future<void> addBooking(DateTime date) async {
    try {
      // Check if the date is already booked to prevent duplicates
      QuerySnapshot existingBooking = await bookings
          .where('date', isEqualTo: Timestamp.fromDate(date))
          .get();

      if (existingBooking.docs.isEmpty) {
        await bookings.add({
          'date': Timestamp.fromDate(date), // Save date as Firestore timestamp
        });
        print('Booking added successfully for $date!');
      } else {
        print('Error: Date $date is already booked!');
      }
    } catch (e) {
      print('Error adding booking for $date: $e');
    }
  }

  /// Deletes a booking from Firebase
  Future<void> deleteBooking(DateTime date) async {
    try {
      QuerySnapshot snapshot = await bookings
          .where('date', isEqualTo: Timestamp.fromDate(date))
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print('Booking for $date deleted successfully!');
    } catch (e) {
      print('Error deleting booking for $date: $e');
    }
  }

  /// Checks if a specific date is booked
  Future<bool> isDateBooked(DateTime date) async {
    try {
      QuerySnapshot snapshot = await bookings
          .where('date', isEqualTo: Timestamp.fromDate(date))
          .get();

      final isBooked = snapshot.docs.isNotEmpty;
      print('Date $date is ${isBooked ? "already booked" : "available"}');
      return isBooked;
    } catch (e) {
      print('Error checking booking for $date: $e');
      return false;
    }
  }

  /// Fetches all bookings as a list of maps (Optional Utility)
  Future<List<Map<String, dynamic>>> fetchAllBookings() async {
    try {
      QuerySnapshot snapshot = await bookings.get();

      return snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print('Error fetching all bookings: $e');
      return [];
    }
  }
}
