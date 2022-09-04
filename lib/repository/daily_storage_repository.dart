import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/repository/storage_repository.dart';

class DailyStorageRepository extends StorageRepository {
  const DailyStorageRepository({required this.firebaseFirestore}) : super();

  final FirebaseFirestore firebaseFirestore;

  @override
  Future<Map<String, dynamic>?> load(final String key) async {
    final collection = firebaseFirestore.collection('daily');
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

  // Provider

  static DailyStorageRepository of(final BuildContext context) {
    return RepositoryProvider.of<DailyStorageRepository>(context);
  }
}
