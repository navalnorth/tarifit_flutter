import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lesson.dart';

class FirestoreService {
  final CollectionReference _lessonsRef = FirebaseFirestore.instance.collection('lessons');

  Future<List<Lesson>> fetchLessons() async {
    QuerySnapshot snapshot = await _lessonsRef.get();
    return snapshot.docs.map((doc) => Lesson.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }
}