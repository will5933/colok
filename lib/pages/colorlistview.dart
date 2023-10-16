import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:colok/colors.dart';

class ColorListView extends StatefulWidget {
  const ColorListView({
    super.key,
    required this.colokData,
    required this.setThemeColor,
    required this.tabCounter,
    required this.index,
  });

  final List<List<Colok>> colokData;
  final void Function(Color colorSeed) setThemeColor;
  final int tabCounter;
  final int index;

  @override
  State<ColorListView> createState() => _ColorListViewState();
}

class _ColorListViewState extends State<ColorListView>
    with TickerProviderStateMixin {
  final List<Widget> _list = [];

  late TabController _tabController;

  TabBar get _bottomAppBar {
    return TabBar(
      isScrollable: true,
      controller: _tabController,
      tabs: widget.tabCounter == 24 ? _the24stTab : _materialTab,
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabCounter, vsync: this);

    for (int i = 0; i < widget.colokData.length; i++) {
      _list.add(ListView(
          children: widget.colokData[i].map((c) {
        return createInkWell(c.name, c.hex, c.rgb[0], c.rgb[1], c.rgb[2]);
      }).toList()));
    }
  }

  InkWell createInkWell(String title, String hex, int r, int g, int b) {
    return InkWell(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (context) =>
              ABottomSheet(name: title, hex: hex, r: r, g: g, b: b),
        );
      },
      onLongPress: () {
        widget.setThemeColor(Color.fromARGB(255, r, g, b));
      },
      child: ListTile(
        title: Text(title),
        subtitle: Text('$hex  RGB($r, $g, $b)'),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, r, g, b),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(50, r, g, b),
                blurRadius: 3,
                spreadRadius: 3,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.tabCounter > 1
        ? Scaffold(
            appBar: _bottomAppBar,
            body: TabBarView(
              controller: _tabController,
              children: _list,
            ),
          )
        : Scaffold(
            body: _list[0],
          );
  }
}

class ABottomSheet extends StatefulWidget {
  const ABottomSheet({
    super.key,
    required this.name,
    required this.hex,
    required this.r,
    required this.g,
    required this.b,
  });

  final String name;
  final String hex;
  final int r;
  final int g;
  final int b;

  @override
  State<ABottomSheet> createState() => _ABottomSheetState();
}

// BottomModalSheet
class _ABottomSheetState extends State<ABottomSheet> {
  String? _titleText;

  InkWell createInkWell({required String key, required String value}) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        setState(() => _titleText = '"$value" Copied!');
      },
      child: ListTile(
        title: Text(key),
        trailing:
            FittedBox(child: Text(value, style: const TextStyle(fontSize: 16))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: ListView(
        children: [
          SizedBox(
            height: 80,
            child: _titleText != null
                ? Center(
                    child: Text(
                      _titleText!,
                      style: const TextStyle(fontSize: 20),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(
                            255,
                            widget.r,
                            widget.g,
                            widget.b,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(
                                50,
                                widget.r,
                                widget.g,
                                widget.b,
                              ),
                              blurRadius: 4,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.name,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
          ),
          createInkWell(key: 'NAME', value: widget.name),
          createInkWell(key: 'HEX', value: widget.hex),
          createInkWell(
            key: 'RGB',
            value: 'rgb(${widget.r}, ${widget.g}, ${widget.b})',
          ),
        ],
      ),
    );
  }
}

const _the24stTab = <Tab>[
  Tab(text: '立春'),
  Tab(text: '雨水'),
  Tab(text: '惊蛰'),
  Tab(text: '春分'),
  Tab(text: '清明'),
  Tab(text: '谷雨'),
  Tab(text: '立夏'),
  Tab(text: '小满'),
  Tab(text: '芒种'),
  Tab(text: '夏至'),
  Tab(text: '小暑'),
  Tab(text: '大暑'),
  Tab(text: '立秋'),
  Tab(text: '处暑'),
  Tab(text: '白露'),
  Tab(text: '秋分'),
  Tab(text: '寒露'),
  Tab(text: '霜降'),
  Tab(text: '立冬'),
  Tab(text: '小雪'),
  Tab(text: '大雪'),
  Tab(text: '冬至'),
  Tab(text: '小寒'),
  Tab(text: '大寒'),
];

const _materialTab = <Tab>[
  Tab(text: 'red'),
  Tab(text: 'pink'),
  Tab(text: 'purple'),
  Tab(text: 'deepPurple'),
  Tab(text: 'indigo'),
  Tab(text: 'blue'),
  Tab(text: 'lightBlue'),
  Tab(text: 'cyan'),
  Tab(text: 'teal'),
  Tab(text: 'green'),
  Tab(text: 'lightGreen'),
  Tab(text: 'lime'),
  Tab(text: 'yellow'),
  Tab(text: 'amber'),
  Tab(text: 'orange'),
  Tab(text: 'deepOrange'),
  Tab(text: 'brown'),
  Tab(text: 'grey'),
  Tab(text: 'blueGrey'),
];
