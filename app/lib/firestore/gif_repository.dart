import 'package:app/firestore/firestore_paths.dart';
import 'package:app/redux/app_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GifRepository {
  Firestore firestore = Firestore.instance;

  Future<List<Gif>> getGifs() async {
    final documents =
        await firestore.collection(FirestorePaths.pathGifs).getDocuments();
    return Future.wait(documents.documents.map((doc) async {
      final double rating = await _getScore(doc.documentID);
      return fromDoc(doc, rating);
    }).toList());
  }

  Future<double> _getScore(String documentID) async {
    final documents = await firestore
        .collection(FirestorePaths.getPathRatings(documentID))
        .getDocuments();

    if (documents.documents.isEmpty) {
      return 0.0;
    }

    return documents.documents.map((doc) {
      return double.parse(doc['rating']);
    }).toList().fold<double>(0, (a, b) => a + b) / documents.documents.length;
  }
}

Gif fromDoc(DocumentSnapshot doc, double rating) {
  return Gif(
    doc.documentID,
    doc['url'],
    rating,
  );
}
