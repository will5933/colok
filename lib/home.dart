import 'package:flutter/material.dart';

import 'package:colok/colors.dart';

import 'package:colok/pages/mainnav.dart';
import 'package:colok/pages/colorlistview.dart';
import 'package:colok/pages/colorconverter.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.setThemeColor,
  });

  final void Function(Color colorSeed) setThemeColor;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectNavIndex = 0;

  void _switchPage(int index) => setState(() {
        _selectNavIndex = index;
      });

  String get _appBarTitle {
    return <String>[
      'Colok',
      '中国传统色',
      '日本传统色',
      '二十四节气主题色',
      'Material Colors',
      'HTML Colors',
      'Copic Colors',
      'Color Converter'
    ][_selectNavIndex];
  }

  @override
  Widget build(BuildContext context) {
    final NavigationDrawer drawer = NavigationDrawer(
        selectedIndex: _selectNavIndex,
        children: const [
          DrawerHeader(
            child: Center(
              child: Text(
                'Colok',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: Text('Home'),
          ),
          Divider(),
          NavigationDrawerDestination(
            icon: Icon(Icons.stream),
            selectedIcon: Icon(Icons.ac_unit_rounded),
            label: Text('中国传统色'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.stream),
            selectedIcon: Icon(Icons.ac_unit_rounded),
            label: Text('日本传统色'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.stream),
            selectedIcon: Icon(Icons.ac_unit_rounded),
            label: Text('二十四节气主题色'),
          ),
          Divider(),
          NavigationDrawerDestination(
            icon: Icon(Icons.hexagon_outlined),
            selectedIcon: Icon(Icons.hexagon_rounded),
            label: Text('Material Colors'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.hexagon_outlined),
            selectedIcon: Icon(Icons.hexagon_rounded),
            label: Text('HTML Colors'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.hexagon_outlined),
            selectedIcon: Icon(Icons.hexagon_rounded),
            label: Text('Copic Colors'),
          ),
          Divider(),
          NavigationDrawerDestination(
            icon: Icon(Icons.sync_outlined),
            selectedIcon: Icon(Icons.sync),
            label: Text('Color Converter'),
          ),
        ],
        onDestinationSelected: (v) {
          setState(() {
            _selectNavIndex = v;
            Navigator.pop(context);
          });
        });

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final IndexedStack content = IndexedStack(
            index: _selectNavIndex,
            children: [
              MainNav(switchPage: _switchPage),
              ColorListView(
                colokData: tcColorsList,
                setThemeColor: widget.setThemeColor,
                tabCounter: 1,
                index: 0,
              ),
              ColorListView(
                colokData: tjColorsList,
                setThemeColor: widget.setThemeColor,
                tabCounter: 1,
                index: 1,
              ),
              ColorListView(
                colokData: the24STColorsList,
                setThemeColor: widget.setThemeColor,
                tabCounter: 24,
                index: 2,
              ),
              ColorListView(
                colokData: materialColorsList,
                setThemeColor: widget.setThemeColor,
                tabCounter: 19,
                index: 3,
              ),
              ColorListView(
                colokData: htmlColorsList,
                setThemeColor: widget.setThemeColor,
                tabCounter: 1,
                index: 4,
              ),
              ColorListView(
                colokData: copicColorsList,
                setThemeColor: widget.setThemeColor,
                tabCounter: 1,
                index: 5,
              ),
              const ColorConverter(),
            ],
          );
          // return orientation == Orientation.portrait
          //     ? content
          //     : Row(
          //         children: [
          //           drawer,
          //           Flexible(child: content),
          //         ],
          //       );
          return content;
        },
      ),
      drawer: drawer,
    );
  }
}
