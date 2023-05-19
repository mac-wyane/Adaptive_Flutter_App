import 'package:adaptive_apps/app_state.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class PlayLists extends StatelessWidget {
  const PlayLists({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Play List"),
      ),
      body: Consumer<FlutterDevPlaylists>(
        builder: (context, flutterDev, child) {
          final playlists = flutterDev.getPlayList;

          if (playlists.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return _PlaylistView(playlists: playlists);
        },
      ),
    );
  }
}

class _PlaylistView extends StatelessWidget {
  final List<Playlist> playlists;
  const _PlaylistView({super.key, required this.playlists});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) {
      final item = playlists[index];
      return ListTile(
        leading: Image.network(item.snippet!.thumbnails!.high!.url ?? ''),
        title: Text(item.snippet!.title ?? ""),
        subtitle: Text(item.snippet!.description ?? ""),
        onTap: () {
          context.go(
            Uri(path: '/playlist/${item.id}', queryParameters: <String, String>{
              'title': item.snippet!.title!
            }).toString(),
          );
        },
      );
    });
  }
}
