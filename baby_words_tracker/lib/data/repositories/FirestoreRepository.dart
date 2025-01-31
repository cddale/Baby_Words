import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreRepository {
  static final database = FirebaseFirestore.instance;

  FirestoreRepository();

  Future<String> create(String collectionName, Map<String, dynamic> data) async {
    final collection = database.collection(collectionName);
    final docRef = await collection.add(data);
    return docRef.id;
  }

  Future<String> createWithId(String collectionName, String docId, Map<String, dynamic> data) async {
    final collection = database.collection(collectionName);
    await collection.doc(docId).set(data);
    return docId; 
  }

  Future<String> createSubcollection(String collectionName, String docId, String subcollectionName, Map<String, dynamic> data) async{
      final CollectionReference ref = database.collection(collectionName).doc(docId).collection(subcollectionName);
      final docRef = await ref.add(data);
      return docRef.id; 
  }

  Future<String> createSubcollectionWithId(String collectionName, String docId, String subcollectionName, String subDoc, Map<String, dynamic> data) async {
    final collection = database.collection(collectionName).doc(docId).collection(subcollectionName);
    await collection.doc(subDoc).set(data);
    return subDoc; 
  }

  Future<Map<String, dynamic>> read(String collectionName, String docId) async {
    final docRef = database.collection(collectionName).doc(docId);
    final doc = await docRef.get();
    if (!doc.exists) {
      throw Exception('Document not found');
    }
    return doc.data() as Map<String, dynamic>;
  }

  Future<void> update(String collectionName, String docId, Map<String, dynamic> data) async {
    final docRef = database.collection(collectionName).doc(docId);
    await docRef.update(data);
  }

  Future<void> updateField(String collectionName, String docId, String field, dynamic value) async {
    final docRef = database.collection(collectionName).doc(docId);
    await docRef.update({field: value});
  }

  Future<void> appendToArrayField(String collectionName, String docID, String field, dynamic value) async {
    final docRef = database.collection(collectionName).doc(docID);
    await docRef.update({field: FieldValue.arrayUnion([value])});
  }

  Future<void> removeFromArrayField(String collectionName, String docID, String field, dynamic value) async {
    final docRef = database.collection(collectionName).doc(docID);
    await docRef.update({field: FieldValue.arrayRemove([value])});
  }

  Future<void> delete(String collectionName, String docId) async {
    final docRef = database.collection(collectionName).doc(docId);
    await docRef.delete();
  }

  //isEqualTo
  Future<List<Map<String, dynamic>>> query(String collectionName, String field, dynamic value) async {
    final collection = database.collection(collectionName);
    final snapshot = await collection.where(field, isEqualTo: value).get();
    if (snapshot.docs.isEmpty) {
      throw Exception('No matching documents.');
    }
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }
  
}