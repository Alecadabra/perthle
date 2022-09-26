import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/repository/mutable_storage_repository.dart';

class DailyStorageRepository extends MutableStorageRepository {
  const DailyStorageRepository({required this.firebaseFirestore}) : super();

  final FirebaseFirestore firebaseFirestore;

  CollectionReference<Map<String, dynamic>> get collection {
    return firebaseFirestore.collection('daily');
  }

  @override
  Future<Map<String, dynamic>?> load(final String key) async {
    final doc = await collection.doc(key).get();
    final json = doc.data();
    if (json == null) {
      return null;
    } else {
      // Validate data
      final daily = DailyState.fromJson(json);
      return daily.toJson();
    }
  }

  @override
  Future<void> save(final String key, final Map<String, dynamic> data) async {
    // Validate data
    final json = DailyState.fromJson(data).toJson();
    await collection.doc(key).set(json);
  }

  @override
  Future<void> delete(final String key) async {
    await collection.doc(key).delete();
  }

  // Provider

  static DailyStorageRepository of(final BuildContext context) {
    return RepositoryProvider.of<DailyStorageRepository>(context);
  }
}
