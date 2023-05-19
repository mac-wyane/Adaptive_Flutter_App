import 'package:adaptive_apps/app_consts.dart';
import 'package:adaptive_apps/play_lists.dart';
import 'package:adaptive_apps/playlist_detail.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:io' show Platform;
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

void main() {
  runApp(ChangeNotifierProvider<FlutterDevPlaylists>(
    create: (context) => FlutterDevPlaylists(
        flutterDevId: FLUTTER_DEV_CHANNEL_ID, youtubeAPIKey: YOUTUBE_API_KEY),
    child: const MyApp(),
  ));
}

final router = GoRouter(routes: [
  GoRoute(
      path: "/",
      builder: (context, state) {
        return const PlayLists();
      },
      routes: [
        GoRoute(
          path: "playlist/:id",
          builder: ((context, state) {
            final id = state.queryParameters['id']!;
            final title = state.queryParameters['title']!;

            return PlaylistDetailView(playlistId: id, playlistName: title);
          }),
        )
      ])
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: FlexColorScheme.light(
        useMaterial3: true,
        scheme: FlexScheme.amber,
      ).toTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
