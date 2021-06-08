import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final databaseReference = FirebaseDatabase.instance.reference();

  Future<void> addData(
    String child,
    var querryParam,
  ) async {
    await databaseReference.child(child).set(querryParam);
  }

  Future readData(String child) async {
    DataSnapshot response = await databaseReference.child(child).once();
    return response.value;
  }

  void deleteData(String child) {
    databaseReference.child(child).remove();
  }

  Future<void> updateData(
    String child,
    var querryParam,
  ) async {
    await databaseReference.child(child).update(
          querryParam,
        );
  }
}
