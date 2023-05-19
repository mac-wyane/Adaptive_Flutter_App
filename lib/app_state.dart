import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:http/http.dart' as http;

class FlutterDevPlaylists extends ChangeNotifier {
  FlutterDevPlaylists(
      {required String flutterDevId, required String youtubeAPIKey})
      : _flutterDevId = flutterDevId {
    _youtubeAPI = YouTubeApi(
      _APIKeyClient(client: http.Client(), key: youtubeAPIKey),
    );
    loadPlaylists();
  }

  final String _flutterDevId;
  late final YouTubeApi _youtubeAPI;

  final List<Playlist> _playlists = [];
  List<Playlist> get getPlayList => UnmodifiableListView(_playlists);

  Future<void> loadPlaylists() async {
    String? nextPageToken;
    do {
      final response = await _youtubeAPI.playlists.list(
        ['snippet', 'contentDetails', 'id'],
        channelId: _flutterDevId,
        maxResults: 30,
        pageToken: nextPageToken,
      );
      _playlists.addAll(response.items!);
      _playlists.sort((a, b) => a.snippet!.title!
          .toLowerCase()
          .compareTo(b.snippet!.title!.toLowerCase()));
      notifyListeners();
    } while (nextPageToken != null);
  }

  final Map<String, List<PlaylistItem>> _playlistItems = {};

  Future<void> retrievePlayList(String playlistId) async {
    String? nextPageToken;

    do {
      final response = await _youtubeAPI.playlistItems.list(
          ['snippet', 'contentDetails'],
          playlistId: playlistId, maxResults: 20, pageToken: nextPageToken);

      final items = response.items;
      if (items != null) {
        _playlistItems[playlistId]!.addAll(items);
      }
      notifyListeners();
      nextPageToken = response.nextPageToken;
    } while (nextPageToken != null);
  }

  List<PlaylistItem> playlistItems({required String playlistId}) {
    if (!_playlistItems.containsKey(playlistId)) {
      _playlistItems[playlistId] = [];
      retrievePlayList(playlistId);
    }
    return UnmodifiableListView(_playlistItems[playlistId]!);
  }
}

class _APIKeyClient extends http.BaseClient {
  final String key;
  final http.Client client;

  _APIKeyClient({required this.key, required this.client});
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final url = request.url.replace(queryParameters: <String, List<String>>{
      ...request.url.queryParametersAll,
      'key': [key]
    });

    return client.send(http.Request(request.method, url));
  }
}
