import 'package:cloud_firestore/cloud_firestore.dart';

class APIs {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<String?> fetchProfileImageUrl(String phoneNumber) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('Driver')
          .where('phone_number', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one document for each phone number
        var document = querySnapshot.docs.first;
        return document['profileImageUrl'];
      } else {
        print('No document found for phone number: $phoneNumber');
        return null;
      }
    } catch (e) {
      print("Error fetching profile image URL: $e");
      return null;
    }
  }
}
