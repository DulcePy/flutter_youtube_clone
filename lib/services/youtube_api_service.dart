import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_youtube_clone/helper.dart';
import 'package:flutter_youtube_clone/models/video_model.dart';
import 'package:http/http.dart' as http;

class YoutubeApiService {
  final String _baseUrl = "https://www.googleapis.com/youtube/v3";
  final String? _apiKey = dotenv.env['API_KEY'];
  String? _nextPageToken;

  Future<List<VideoModel>> fetchVideos({
    String query = '',
    String? pageToken,
    int maxResults = 10,
  }) async {
    return await Helper.handleRequest(() async {
          final Uri uri = query.isEmpty
              ? Uri.parse(
                  '$_baseUrl/videos?part=snippet,statistics,contentDetails&chart=mostPopular&maxResults=$maxResults&pageToken=${pageToken ?? ''}&key=$_apiKey')
              : Uri.parse(
                  '$_baseUrl/search?part=snippet&q=$query&type=video&maxResults=$maxResults&pageToken=${pageToken ?? ''}&key=$_apiKey');

          final response = await http.get(uri);

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            _nextPageToken = data['nextPageToken'];

            final List<dynamic> items = data['items'];

            if (query.isNotEmpty) {
              final List<VideoModel> videos = [];
              for (var item in items) {
                final videoId = item['id']['videoId'];
                final details = await getVideoDetails(videoId);

                if (details != null) {
                  final video = await VideoModel.fromJson(details);

                  if (video != null) {
                    videos.add(video);
                  }
                }
              }
              return videos;
            }

            final List<VideoModel> videos = [];
            for (var item in items) {
              final video = await VideoModel.fromJson(item);

              if (video != null) {
                videos.add(video);
              }
            }

            return videos;
          } else {
            debugPrint('API Error: ${response.statusCode} - ${response.body}');
          }
        }) ??
        [];
  }

  String? get nextPageToken => _nextPageToken;

  Future<Map<String, dynamic>> getVideoDetails(String videoId) async {
    return await Helper.handleRequest(() async {
      final uri = Uri.parse(
          '$_baseUrl/videos?part=snippet,statistics,contentDetails&id=$videoId&key=$_apiKey');

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'];
        return items.isNotEmpty ? items.first : null;
      }

      debugPrint(
          'Video details API error: ${response.statusCode} - ${response.body}');
      return null;
    });
  }
}
