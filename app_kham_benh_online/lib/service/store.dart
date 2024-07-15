import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all documents from a specific collection
  Stream<List<Map<String, dynamic>>> streamCollection(String collectionPath) {
    return _firestore.collection(collectionPath).snapshots().map(
          (querySnapshot) => querySnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList(),
        );
  }

  // Fetch a single document by ID
  Future<Map<String, dynamic>?> getDocumentById(
      String collectionPath, String id) async {
    DocumentSnapshot doc =
        await _firestore.collection(collectionPath).doc(id).get();
    return doc.data() as Map<String, dynamic>?;
  }

  // Add a new document to a collection
  Future<void> addDocument(
      String collectionPath, Map<String, dynamic> data) async {
    await _firestore.collection(collectionPath).add(data);
  }

  // Update an existing document
  Future<void> updateDocument(
      String collectionPath, String id, Map<String, dynamic> data) async {
    await _firestore.collection(collectionPath).doc(id).update(data);
  }

  // Delete a document
  Future<void> deleteDocument(String collectionPath, String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
  }
}
