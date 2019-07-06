import 'package:app/firestore/firestore_paths.dart';
import 'package:app/redux/app_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingRepository {
  Firestore firestore = Firestore.instance;

  Future<double> getMyRating(String id, String user) async {
    final document =
        await firestore.document(FirestorePaths.getPathRating(id, user)).get();
    if (!document.exists) {
      return 0.0;
    }
    return double.tryParse(document['rating']) ?? 0.0;
  }

  Future<void> setRating(String id, String user, double rating) async {
    return await firestore
        .document(FirestorePaths.getPathRating(id, user))
        .setData({'rating': rating.toString()});
  }

  Stream<List<Rating>> getRatings(String id) {
    return firestore
        .collection(FirestorePaths.getPathRatings(id))
        .snapshots()
        .map((snap) {
      return snap.documents.map((doc) {
        return Rating(
          doc.documentID,
          double.parse(doc['rating']),
        );
      }).toList();
    });
  }
}
