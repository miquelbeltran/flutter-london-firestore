import 'dart:async';

import 'package:app/redux/app_state.dart';

class LoadGifsAction {

}

class OnLoadedGifsAction {
  List<Gif> gifs;

  OnLoadedGifsAction(this.gifs);
}

class LoadRatingsAction {
  String id;

  LoadRatingsAction(this.id);
}

class OnLoadedMyRatingAction {
  double myRating;

  OnLoadedMyRatingAction(this.myRating);
}

class OnUpdatedRatingsAction {
  List<Rating> ratings;

  OnUpdatedRatingsAction(this.ratings);
}

class OnSubscribedToRatingsAction {
  StreamSubscription subscription;

  OnSubscribedToRatingsAction(this.subscription);
}

class UnsubscribeAction {

}

class OnRatingAction {
  String id;
  double rating;

  OnRatingAction(this.id, this.rating);

}