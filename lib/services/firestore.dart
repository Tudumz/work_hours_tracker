import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/work_log.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addWorkLog(DateTime date, double hours, String? comment) async {
    User? user = _auth.currentUser;
    if (user == null) {
      await _auth.signInAnonymously();
      user = _auth.currentUser;
    }

    if (user == null) return;
    final workLog = WorkLog(id: '', date: date, hours: hours, comment: comment);

    // users -> [ID user] -> work_logs
    await _db
        .collection('users')
        .doc(user.uid)
        .collection('work_logs')
        .add(workLog.toMap());
  }
}
