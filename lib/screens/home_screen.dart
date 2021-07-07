import 'package:flutter/material.dart';
import 'package:flutter_youtube_ui/data.dart';
import 'package:flutter_youtube_ui/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          CustomSliverAppBar(),
          _buildListOfVideos(),
        ],
      ),
    );
  }

  SliverList _buildListOfVideos() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final Video video = videos[index];
          return VideoCard(video: video);
        },
        childCount: videos.length,
      ),
    );
  }
}
