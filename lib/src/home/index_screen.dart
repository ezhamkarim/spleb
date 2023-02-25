import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spleb/src/root/screens.dart';
import 'package:spleb/src/style/style.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});
  static const routeName = '/index';
  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  List<Widget> screens = [const HomeScreen(), const ProjectScreen(), const TetapanScreen()];

  var items = [
    const BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.house), label: 'Utama'),
    const BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.diagramProject), label: 'Project'),
    const BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.gear), label: 'Tetapan')
  ];
  var header = ['Utama', 'Project', 'Tetapan'];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.primary,
          title: Text(header.elementAt(currentIndex)),
        ),
        body: screens.elementAt(currentIndex),
        bottomNavigationBar: BottomNavigationBar(
            elevation: 4,
            currentIndex: currentIndex,
            selectedIconTheme: IconThemeData(color: CustomColor.primary.shade700),
            unselectedIconTheme: const IconThemeData(color: Colors.grey),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: CustomColor.primary.shade700,
            unselectedItemColor: Colors.grey,
            onTap: (i) {
              setState(() {
                currentIndex = i;
              });
            },
            items: items));
  }
}
