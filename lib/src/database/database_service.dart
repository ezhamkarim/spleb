import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final userCollection = FirebaseFirestore.instance.collection('userSpleb');
  final roleCollection = FirebaseFirestore.instance.collection('roleSpleb');
}
