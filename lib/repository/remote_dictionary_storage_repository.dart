import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/repository/storage_repository.dart';

class RemoteDictionaryStorageRepository extends StorageRepository {
  const RemoteDictionaryStorageRepository({required this.firebaseFirestore});

  final FirebaseFirestore firebaseFirestore;

  @override
  Future<Map<String, dynamic>?> load(final String key) async {
    final collection = firebaseFirestore.collection('dictionary');

    final doc = await collection.doc(key).get();
    return doc.data();
  }

  // Provider

  static RemoteDictionaryStorageRepository of(final BuildContext context) {
    return RepositoryProvider.of<RemoteDictionaryStorageRepository>(context);
  }
}
