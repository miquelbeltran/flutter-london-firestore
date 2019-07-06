import 'dart:ui' as ui;

import 'package:app/firestore/gif_repository.dart';
import 'package:app/firestore/rating_repository.dart';
import 'package:app/redux/app_actions.dart';
import 'package:app/redux/app_middleware.dart';
import 'package:app/redux/app_reducer.dart';
import 'package:app/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: createMiddleware(GifRepository(), RatingRepository()),
    );
    store.dispatch(LoadGifsAction());
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Gif Review',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gif Review'),
      ),
      body: StoreConnector<AppState, List<Gif>>(
        builder: (context, gifs) {
          return ListView.builder(
            itemCount: gifs?.length ?? 0,
            itemBuilder: (context, position) {
              return GifScore(gifs[position]);
            },
          );
        },
        converter: (store) => store.state.gifs,
      ),
    );
  }
}

class GifScore extends StatelessWidget {
  Gif gif;

  GifScore(this.gif);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          StoreProvider.of<AppState>(context)
              .dispatch(LoadRatingsAction(gif.id));
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => GifReview(gif)));
        },
        child: Column(
          children: <Widget>[
            Image.network(gif.url),
            SmoothStarRating(
              size: 60,
              rating: gif.rating,
            )
          ],
        ),
      ),
    );
  }
}

class GifReview extends StatefulWidget {
  final Gif gif;

  GifReview(this.gif);

  @override
  _GifReviewState createState() => _GifReviewState();
}

class _GifReviewState extends State<GifReview> {
  Store<AppState> store;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    store = StoreProvider.of(context);
  }

  @override
  void dispose() {
    super.dispose();
    store.dispatch(UnsubscribeAction());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Image.network(widget.gif.url),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Your Score',
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          StoreConnector<AppState, double>(
            builder: (context, rating) {
              return SmoothStarRating(
                size: 60,
                rating: rating ?? 0,
                onRatingChanged: (rating) {
                  StoreProvider.of<AppState>(context)
                      .dispatch(OnRatingAction(widget.gif.id, rating));
                },
              );
            },
            converter: (store) => store.state.myRating,
          ),
          Expanded(
            child: StoreConnector<AppState, List<Rating>>(
              converter: (store) => store.state.ratings,
              builder: (context, ratings) {
                return ListView.builder(
                  itemCount: ratings?.length ?? 0,
                  itemBuilder: (context, position) {
                    return Review(ratings[position]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Review extends StatelessWidget {
  Rating rating;

  Review(this.rating);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SmoothStarRating(
            rating: rating.rating,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(rating.user),
        ),
      ],
    );
  }
}
