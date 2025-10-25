part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<Map<String, dynamic>> newReleases;
  final List<Map<String, dynamic>> popularList;
  final List<Map<String, dynamic>> popularArtists;
  // Make recommendations potentially null or empty initially
  final List<Map<String, dynamic>>? recommendations;

  HomeSuccess({
    required this.newReleases,
    required this.popularList,
    required this.popularArtists,
    this.recommendations, // Optional
  });
}

class HomeError extends HomeState {
  final String errorMessage;
  HomeError({required this.errorMessage});
}