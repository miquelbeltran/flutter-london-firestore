class FirestorePaths {
  static String pathGifs = '/gifs';
  static String pathRatings = '/ratings';

  static String getPathRatings(String id) {
    return "$pathGifs/$id$pathRatings";
  }

  static String getPathRating(String id, String user) {
    return "$pathGifs/$id$pathRatings/$user";
  }
}