import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/repository/mutable_storage_repository.dart';

class LibraryStorageRepository extends MutableStorageRepository {
  const LibraryStorageRepository({required this.firebaseFirestore});

  final FirebaseFirestore firebaseFirestore;

  CollectionReference<Map<String, dynamic>> get collection =>
      firebaseFirestore.collection('library');

  // Provider

  static LibraryStorageRepository of(final BuildContext context) {
    return RepositoryProvider.of<LibraryStorageRepository>(context);
  }

  @override
  Future<Map<String, dynamic>?> load(final String key) {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<void> save(final String key, final Map<String, dynamic> data) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<void> delete(final String key) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
