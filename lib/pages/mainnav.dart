import 'package:flutter/material.dart';

class MainNav extends StatelessWidget {
  const MainNav({super.key, required this.switchPage});

  final void Function(int index) switchPage;

  @override
  Widget build(BuildContext context) {
    Container createCard(List<Widget> list) {
      return Container(
        margin: const EdgeInsets.fromLTRB(36, 8, 36, 8),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Card(
          color: Theme.of(context).colorScheme.surfaceVariant,
          clipBehavior: Clip.hardEdge,
          shadowColor: Colors.transparent,
          child: Column(children: list),
        ),
      );
    }

    InkWell createInkWell(String title, int index) {
      return InkWell(
        onTap: () => switchPage(index),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 16),
            createCard([
              createInkWell('中国传统色', 1),
              createInkWell('日本传统色', 2),
              createInkWell('二十四节气主题色', 3),
            ]),
            createCard([
              createInkWell('Material Colors', 4),
              createInkWell('HTML Colors', 5),
              createInkWell('Copic Colors', 6),
            ]),
            createCard([
              createInkWell('Color Converter', 7),
            ]),
          ],
        ),
      ),
    );
  }
}
