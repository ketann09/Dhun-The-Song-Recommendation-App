import 'package:bloc/bloc.dart';
// Remove FirestoreService import if only used for assumed getPopularArtists
// import 'package:dhun/features/auth/services/firestore_service.dart';
import 'package:dhun/features/home/song_service.dart'; // Import Song service
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // Use ONLY the service instance shown in the original code
  final SongService _songService = SongService();
  // Keep FirestoreService only if needed for logging later via BLoC
  // final FirestoreService _firestoreService = FirestoreService();

  HomeBloc() : super(HomeInitial()) {
    // --- Event Handler for Loading Initial Data ---
    on<LoadHomeData>((event, emit) async {
      emit(HomeLoading()); // Start by emitting the loading state

      try {
        // --- Fetch ONLY the general song list ---
        // This corresponds to the original fetchSongs() call
        final allSongs = await _songService.getSongs();

        // --- Calculate Popular Artists (Moved logic from UI) ---
        final popularArtists = allSongs
            .map((song) => song['artist_name'])
            .toSet() // Get unique artist names
            .map((artistName) => {
                  'artist': artistName,
                  'photoUrl': allSongs.firstWhere(
                      (s) => s['artist_name'] == artistName,
                      orElse: () => {'url': ''})['url'], // Assumes 'url' field exists
                  'songCount': allSongs.where((s) => s['artist_name'] == artistName).length,
                })
            .toList();

        // --- Emit Success State WITHOUT recommendations ---
        // Pass 'allSongs' to the lists where specific data isn't available yet
        emit(HomeSuccess(
          newReleases: allSongs, // Using allSongs as placeholder
          popularList: allSongs, // Using allSongs as placeholder
          popularArtists: popularArtists,
          recommendations: null, // Recommendations not fetched yet
        ));

      } catch (e) {
        print("Error loading initial home data: $e");
        emit(HomeError(errorMessage: "Failed to load data. Please try again."));
      }
    });

    // --- Placeholder handler for fetching recommendations LATER ---
    // This would be triggered by a new event after a song is played,
    // and would call _songService.getRecommendations()
    // on<FetchRecommendations>((event, emit) async { ... });

  }
}