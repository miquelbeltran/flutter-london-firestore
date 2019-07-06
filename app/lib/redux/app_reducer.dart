import 'package:app/redux/app_actions.dart';
import 'package:app/redux/app_state.dart';
import 'package:redux/redux.dart';

final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, OnLoadedGifsAction>(_onGifsLoadedAction),
  TypedReducer<AppState, OnLoadedMyRatingAction>(_onLoadedMyRatingAction),
  TypedReducer<AppState, OnUpdatedRatingsAction>(_onUpdatedRatingsAction),
  TypedReducer<AppState, OnSubscribedToRatingsAction>(_onSubscribedToRatingsAction),
]);

AppState _onGifsLoadedAction(AppState state, OnLoadedGifsAction action) {
  return AppState(
    gifs: action.gifs,
    myRating: state.myRating,
    ratings: state.ratings,
    subscription: state.subscription,
  );
}

AppState _onLoadedMyRatingAction(AppState state, OnLoadedMyRatingAction action) {
  return AppState(
    gifs: state.gifs,
    myRating: action.myRating,
    ratings: state.ratings,
    subscription: state.subscription,
  );
}

AppState _onUpdatedRatingsAction(AppState state, OnUpdatedRatingsAction action) {
  return AppState(
    gifs: state.gifs,
    myRating: state.myRating,
    ratings: action.ratings,
    subscription: state.subscription,
  );
}

AppState _onSubscribedToRatingsAction(AppState state, OnSubscribedToRatingsAction action) {
  return AppState(
    gifs: state.gifs,
    myRating: state.myRating,
    ratings: state.ratings,
    subscription: action.subscription,
  );
}
