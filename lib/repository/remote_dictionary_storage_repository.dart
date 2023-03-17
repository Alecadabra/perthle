import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/repository/mutable_storage_repository.dart';

class RemoteDictionaryStorageRepository extends MutableStorageRepository {
  const RemoteDictionaryStorageRepository({required this.firebaseFirestore});

  final FirebaseFirestore firebaseFirestore;

  CollectionReference<Map<String, dynamic>> get collection =>
      firebaseFirestore.collection('dictionary');

  @override
  Future<Map<String, dynamic>?> load(final String key) async {
    final doc = await collection.doc(key).get();
    return doc.data();
  }

  // Provider

  static RemoteDictionaryStorageRepository of(final BuildContext context) {
    return RepositoryProvider.of<RemoteDictionaryStorageRepository>(context);
  }

  @override
  Future<void> save(final String key, final Map<String, dynamic> data) async {
    await collection.doc(key).set(data);
  }

  @override
  Future<void> delete(final String key) async {
    await collection.doc(key).delete();
  }
}
