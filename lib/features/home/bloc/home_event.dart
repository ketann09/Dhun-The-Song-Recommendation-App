part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

// Event triggered when the HomeScreen wants to load its data
class LoadHomeData extends HomeEvent {}

// We can add other events later, e.g., for tapping a song
// class SongTapped extends HomeEvent {
//   final Map<String, dynamic> songData;
//   SongTapped({required this.songData});
// }