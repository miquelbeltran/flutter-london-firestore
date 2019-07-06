import 'dart:async';

class AppState {
  List<Gif> gifs;

  // Current selected gif
  double myRating;
  List<Rating> ratings;
  StreamSubscription subscription;

  AppState({
    this.gifs,
    this.myRating,
    this.ratings,
    this.subscription,
  });
}

class Gif {
  String id;
  String url;
  double rating;

  Gif(this.id, this.url, this.rating);
}

class Rating {
  String user;
  double rating;

  Rating(this.user, this.rating);
}
