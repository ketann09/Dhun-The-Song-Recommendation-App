import 'package:dhun/core/widgets/app_bg.dart';
import 'package:dhun/data/services/recommendation_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class RecommedationScreen extends StatefulWidget {
  const RecommedationScreen({super.key});

  @override
  State<RecommedationScreen> createState() => _RecommedationScreenState();
}

class _RecommedationScreenState extends State<RecommedationScreen> {
  final TextEditingController _trackIdController = TextEditingController();
  final TextEditingController _nController = TextEditingController();
  List<Map<String, dynamic>> _parsedRecommendations = [];

  List<dynamic> _recommendations = [];
  String _result = 'Results will appear here once fetched.';

  @override
  void initState() {
    super.initState();
    _nController.text = '5';
    _trackIdController.text = '0BRjO6ga9RKCKjfDqeFgWV'; // ✅ valid ID
  }

  @override
  void dispose() {
    _trackIdController.dispose();
    _nController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBg(
        child: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAppBar(context),
                    const SizedBox(height: 24),
                    _buildTextField(
                        _trackIdController, 'Track ID (e.g., 0BRjO6ga9RKCKjfDqeFgWV)'),
                    const SizedBox(height: 16),
                    _buildTextField(_nController, 'Number of Recommendations (n)'),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _getRecommendations,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Get Recommendations',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Results:',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Divider(color: Colors.white54),
                    _parsedRecommendations.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _result,
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                        : _buildResults(_parsedRecommendations),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Fetch Recommendations

  Future<void> _getRecommendations() async {
    final trackId = _trackIdController.text.trim();
    final n = int.tryParse(_nController.text.trim()) ?? 5;

    setState(() {
      _result = 'Fetching recommendations...';
      _parsedRecommendations.clear();
    });

    try {
      final response = await RecommendationService.fetchRecommendations(trackId, topN: n);

      // ✅ response is a List<String> or List<Map>
      List<Map<String, dynamic>> parsed = [];

      for (var item in response) {
        if (item is String) {
          try {
            final fixed = item
                .replaceAll("'", '"')
                .replaceAll('track_id:', '"track_id":')
                .replaceAll('track_name:', '"track_name":')
                .replaceAll('artist_name:', '"artist_name":')
                .replaceAll('popularity:', '"popularity":')
                .replaceAll('score:', '"score":');

            final decodedItem = json.decode(fixed);

            if (decodedItem is Map<String, dynamic>) {
              parsed.add(decodedItem);
            }
          } catch (e) {
            debugPrint('⚠️ Failed to decode item: $item');
          }
        } else if (item is Map<String, dynamic>) {
          // ✅ Explicitly ensure correct type
          parsed.add(item);
        } else if (item is Map) {
          // ✅ Handles generic Map<dynamic, dynamic>
          parsed.add(Map<String, dynamic>.from(item));
        }
      }

      setState(() {
        _parsedRecommendations = parsed;
        _result = parsed.isEmpty
            ? 'No recommendations found.'
            : 'Fetched ${parsed.length} recommendations.';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }
  }
  /// 🔹 Results Display Widget
  Widget _buildResults(List<dynamic> recommendations) {
    if (recommendations.isEmpty) {
      return const Text(
        'No recommendations found.',
        style: TextStyle(color: Colors.white70, fontSize: 16),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        final item = Map<String, dynamic>.from(recommendations[index]); // ✅ FIX HERE

        final trackName = item['track_name'] ?? 'Unknown Track';
        final artistName = item['artist_name'] ?? 'Unknown Artist';
        final popularity = item['popularity'] ?? '-';
        final score = item['score'] ?? '-';

        return Card(
          color: Colors.deepPurpleAccent.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purpleAccent,
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              trackName,
              style: const TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Artist: $artistName',
                    style: const TextStyle(color: Colors.white70)),
                Text('Popularity: $popularity  |  Score: $score',
                    style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
            trailing: const Icon(Icons.music_note, color: Colors.white70),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey.shade800.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const Text(
          'Recommendations',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}
