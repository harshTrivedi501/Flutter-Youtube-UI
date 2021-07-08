import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_ui/data.dart';
import 'package:flutter_youtube_ui/screens/home_screen.dart';

final StateProvider<Video?> selectedVideoProvider =
    StateProvider<Video?>((ProviderReference ref) => null);

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0;

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
          log(selectedVideo.toString());
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
                .toList(),
          );
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
