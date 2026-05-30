import 'package:equatable/equatable.dart';

/// Abstract class for all favorites states.
abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

/// Initial state of favorites before loading is finished.
class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

/// State containing the complete set of favorited song IDs.
class FavoritesReady extends FavoritesState {
  /// The set of all favorited song IDs.
  final Set<int> favoriteSongIds;

  const FavoritesReady(this.favoriteSongIds);

  @override
  List<Object?> get props => [favoriteSongIds];
}
