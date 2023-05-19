import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';

import 'app_state.dart';
import 'package:provider/provider.dart';

class PlaylistDetailView extends StatelessWidget {
  final String playlistId;
  final String playlistName;
  const PlaylistDetailView(
      {super.key, required this.playlistId, required this.playlistName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playlistName),
      ),
      body: Consumer<FlutterDevPlaylists>(builder: (context, playlists, _) {
        final playlistItems = playlists.playlistItems(playlistId: playlistId);
        return PlaylistDetailListView(
          playlistItems: playlistItems,
        );
      }),
    );
  }
}

class PlaylistDetailListView extends StatelessWidget {
  final List<PlaylistItem> playlistItems;
  const PlaylistDetailListView({super.key, required this.playlistItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: playlistItems.length,
      itemBuilder: (context, index) {
        final playlistItem = playlistItems[index];

        return Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: [
              if (playlistItem.snippet!.thumbnails!.high != null)
                Image.network(playlistItem.snippet!.thumbnails!.high!.url!)
            ],
          ),
        );
      },
    );
  }
}
