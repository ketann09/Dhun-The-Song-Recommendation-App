import 'dart:convert';
import 'package:http/http.dart' as http;

class RecommendationService {
  static const String baseUrl = "https://hybrid-ml-recommender.onrender.com";

  static Future<List<dynamic>> fetchRecommendations(String trackId,
      {int topN = 5}) async {
    final url = Uri.parse("$baseUrl/recommend/collab?track_id=$trackId&top_n=$topN");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = response.body.trim();

      try {
        // ✅ If backend already returns valid JSON list
        final decoded = json.decode(body);
        if (decoded is List) return decoded;
        if (decoded is Map && decoded.containsKey('recommendations')) {
          return decoded['recommendations'];
        }
      } catch (_) {
        // continue to fallback below
      }

      // ✅ Fallback: sometimes backend returns single string list → convert manually
      final cleaned = body
          .replaceAll("'", '"')
          .replaceAll("track_id:", '"track_id":')
          .replaceAll("track_name:", '"track_name":')
          .replaceAll("artist_name:", '"artist_name":')
          .replaceAll("popularity:", '"popularity":')
          .replaceAll("score:", '"score":');

      try {
        return json.decode(cleaned);
      } catch (_) {
        // return as a raw string list
        return [body];
      }
    } else {
      throw Exception('Server responded ${response.statusCode}');
    }
  }
}
