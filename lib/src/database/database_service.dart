import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final userCollection = FirebaseFirestore.instance.collection('userSpleb');
  final userRegisteredCollection = FirebaseFirestore.instance.collection('userRegistrationSpleb');
  final roleCollection = FirebaseFirestore.instance.collection('roleSpleb');
  final projectCollection = FirebaseFirestore.instance.collection('projectSpleb');
  final logQualityCollection = FirebaseFirestore.instance.collection('logQualitySpleb');
  final logOSHECollection = FirebaseFirestore.instance.collection('logOSHESpleb');
  final isuCollection = FirebaseFirestore.instance.collection('isuSpleb');
}
