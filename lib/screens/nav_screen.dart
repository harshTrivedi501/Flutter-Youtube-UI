import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_ui/data.dart';
import 'package:flutter_youtube_ui/screens/home_screen.dart';
import 'package:miniplayer/miniplayer.dart';

final StateProvider<Video?> selectedVideoProvider =
    StateProvider<Video?>((ProviderReference ref) => null);

final AutoDisposeStateProvider<MiniplayerController>
    miniplayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
        (ProviderReference ref) => MiniplayerController());

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0;
  static const double _playerMinHeight = 60.0;

  final List<Widget> _screens = <Widget>[
    HomeScreen(),
    const Scaffold(body: Center(child: Text('Explore'))),
    const Scaffold(body: Center(child: Text('Add'))),
    const Scaffold(body: Center(child: Text('Subscriptions'))),
    const Scaffold(body: Center(child: Text('Library'))),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (BuildContext context,
            T Function<T>(ProviderBase<Object?, T>) watch, _) {
          final Video? selectedVideo = watch(selectedVideoProvider).state;
          final MiniplayerController miniPlayerController = watch(miniplayerControllerProvider).state;
          return Stack(
              children: _screens
                  .asMap()
                  .map((int index, Widget screen) => MapEntry<int, Offstage>(
                        index,
                        Offstage(
                          offstage: _selectedIndex != index,
                          child: screen,
                        ),
                      ))
                  .values
                  .toList()
                    ..add(
                      Offstage(
                        offstage: selectedVideo == null,
                        child: Miniplayer(
                          controller: miniPlayerController,
                          minHeight: _playerMinHeight,
                          maxHeight: MediaQuery.of(context).size.height,
                          builder: (double height, double percentage) {
                            //* Even though when selected video is null the offstage widget will hide this miniplayer but still
                            //* this builder method gets called and the widget gets rendered so for optimization we need to add
                            //* the below if statement so that when it is hidden shrinked sizedBox will be returned not the
                            //* Container, so we get optimized results.
                            if (selectedVideo == null) {
                              return const SizedBox.shrink();
                            }
                            return Container(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Image.network(
                                          selectedVideo.thumbnailUrl,
                                          //* Reason for subtracting 4 from below height is because LinearProgressIndicator takes
                                          //* up 4 pixels of height by default, so to fit this image properly we subtract 4 pixels from
                                          //* this Image height
                                          height: _playerMinHeight - 4.0,
                                          width: 120.0,
                                          fit: BoxFit.cover,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                //* By default Text widget has maxLines 1
                                                Text(
                                                  selectedVideo.title,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption!
                                                      .copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                                Text(
                                                  selectedVideo.author.username,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.play_arrow),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            context
                                                .read(selectedVideoProvider)
                                                .state = null;
                                          },
                                        )
                                      ],
                                    ),
                                    const LinearProgressIndicator(
                                      value: 0.4,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.red),
                                    ),
                                  ],
                                ));
                          },
                        ),
                      ),
                    ));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (int index) => setState(() => _selectedIndex = index),
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        //* The reason for putting const below for items list is because it will not re-render the items list
        //* whenever the build method is recalled
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions_outlined),
            activeIcon: Icon(Icons.subscriptions),
            label: 'Subscriptions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            activeIcon: Icon(Icons.video_library),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
