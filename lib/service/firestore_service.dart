import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ✅ Fetch Services from Firestore and order by 'name'
  Future<List<Map<String, dynamic>>> fetchServices() async {
    try {
      QuerySnapshot snapshot = await _db.collection('services')
          .orderBy('name') // Ordering by 'name' field
          .get();

      // Map the querySnapshot to a list of Map<String, dynamic>
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("🔥 Firestore Fetch Error: $e");
      return [];
    }
  }

  // ✅ Add a New Service to Firestore
  Future<void> addService(Map<String, dynamic> serviceData) async {
    try {
      await _db.collection('services').add(serviceData);
    } catch (e) {
      print("🔥 Firestore Add Error: $e");
    }
  }

  // ✅ Get Service by ID (optional utility)
  Future<Map<String, dynamic>?> getServiceById(String id) async {
    try {
      DocumentSnapshot doc = await _db.collection('services').doc(id).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("🔥 Firestore GetById Error: $e");
    }
    return null;
  }

  // ✅ Delete a Service by ID (optional utility)
  Future<void> deleteService(String id) async {
    try {
      await _db.collection('services').doc(id).delete();
    } catch (e) {
      print("🔥 Firestore Delete Error: $e");
    }
  }
}
