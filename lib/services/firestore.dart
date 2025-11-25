import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/work_log.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> addWorkLog(DateTime date, double hours, String? comment) async {
    User? user = auth.currentUser;
    if (user == null) {
      await auth.signInAnonymously();
      user = auth.currentUser;
    }

    if (user == null) return;
    final workLog = WorkLog(id: '', date: date, hours: hours, comment: comment);

    // users -> [ID user] -> work_logs
    await db
        .collection('users')
        .doc(user.uid)
        .collection('work_logs')
        .add(workLog.toMap());
  }

  Stream<List<WorkLog>> getWorkLogs(DateTime date) {
    User? user = auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return db
        .collection('users')
        .doc(user.uid)
        .collection('work_logs')
        .where(
          'date',
          isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch,
        )
        .where('date', isLessThanOrEqualTo: endOfDay.millisecondsSinceEpoch)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return WorkLog.fromMap(doc.id, doc.data());
          }).toList();
        });
  }
}
