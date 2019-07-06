import 'package:app/firestore/gif_repository.dart';
import 'package:app/firestore/rating_repository.dart';
import 'package:app/redux/app_actions.dart';
import 'package:app/redux/app_state.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createMiddleware(
  GifRepository gifRepository,
  RatingRepository ratingRepository,
) {
  return [
    TypedMiddleware<AppState, LoadGifsAction>(_loadGifs(gifRepository)),
    TypedMiddleware<AppState, LoadRatingsAction>(
        _loadRatings(ratingRepository)),
    TypedMiddleware<AppState, UnsubscribeAction>(_unsubscribe()),
    TypedMiddleware<AppState, OnRatingAction>(
        _onRatingAction(ratingRepository)),
  ];
}

void Function(
  Store<AppState> store,
  UnsubscribeAction action,
  NextDispatcher next,
) _unsubscribe() {
  return (store, action, next) async {
    print('On Unsubscribe Action');
    store.state.subscription?.cancel();
  };
}

void Function(
  Store<AppState> store,
  LoadGifsAction action,
  NextDispatcher next,
) _loadGifs(GifRepository gifRepository) {
  return (store, action, next) async {
    next(action);

    final gifs = await gifRepository.getGifs();
    store.dispatch(OnLoadedGifsAction(gifs));
  };
}

void Function(
  Store<AppState> store,
  LoadRatingsAction action,
  NextDispatcher next,
) _loadRatings(RatingRepository ratingRepository) {
  return (store, action, next) async {
    next(action);

    final myRating = await ratingRepository.getMyRating(action.id, 'miguel');
    store.dispatch(OnLoadedMyRatingAction(myRating));
    // ignore: cancel_subscriptions
    final subscription = ratingRepository.getRatings(action.id).listen((data) {
      store.dispatch(OnUpdatedRatingsAction(data));
    });

    // Store the subscription in the AppState and unsubscribe eventually
    store.dispatch(OnSubscribedToRatingsAction(subscription));
  };
}

void Function(
  Store<AppState> store,
  OnRatingAction action,
  NextDispatcher next,
) _onRatingAction(RatingRepository ratingRepository) {
  return (store, action, next) async {
    next(action);

    store.dispatch(OnLoadedMyRatingAction(action.rating));
    await ratingRepository.setRating(action.id, 'miguel', action.rating);
  };
}
