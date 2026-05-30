import 'package:equatable/equatable.dart';

/// Abstract class for all favorites states.
abstract class FavoritesState extends Equatable {
  /// Const constructor.
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

/// Initial state of favorites before loading is finished.
class FavoritesInitial extends FavoritesState {
  /// Const constructor.
  const FavoritesInitial();
}

/// State containing the complete set of favorited song IDs.
class FavoritesReady extends FavoritesState {
  /// The set of all favorited song IDs.
  final Set<int> favoriteSongIds;

  /// Creates a [FavoritesReady] state with the given [favoriteSongIds].
  const FavoritesReady(this.favoriteSongIds);

  @override
  List<Object?> get props => [favoriteSongIds];
}
