import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/root/screens.dart';
import 'package:spleb/src/root/services.dart';
import 'package:spleb/src/style/style.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});
  static const routeName = '/index';
  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  // List<Widget> screens = [const HomeScreen(), const ProjectScreen(), const TetapanScreen()];

  // var items = [
  //   const BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.house), label: 'Utama'),
  //   const BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.diagramProject), label: 'Project'),
  //   const BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.gear), label: 'Tetapan')
  // ];
  // var header = ['Utama', 'Project', 'Tetapan'];
  // int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    var authService = context.watch<AuthService>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.primary,
        // title: Text(header.elementAt(currentIndex)),
        title: const Text('Utama'),
      ),
      // body: screens.elementAt(currentIndex),
      body: const HomeScreen(),
      drawer: Drawer(
        child: ListView(children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: 200,
            color: CustomColor.primary,
            child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/ic_launcher_spleb.png',
                  height: 80,
                ),
              )
            ]),
          ),
          ListTile(
            title: const Text('Utama'),
            trailing: const Icon(
              Icons.home,
              color: CustomColor.primary,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Projek'),
            trailing: const Icon(
              Icons.file_copy,
              color: CustomColor.primary,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/projek-list');
            },
          ),
          ListTile(
            title: const Text('Buku Log'),
            trailing: const Icon(
              Icons.book,
              color: CustomColor.primary,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/buku-log');
            },
          ),
          ListTile(
            title: const Text('Buku Panduan'),
            trailing: const Icon(
              Icons.book_online,
              color: CustomColor.primary,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/buku-panduan');
            },
          ),
          ListTile(
            title: const Text('Log Keluar'),
            trailing: const Icon(
              Icons.logout,
              color: CustomColor.primary,
            ),
            onTap: () async {
              DialogHelper.dialogWithAction(context, 'Log Keluar', 'Anda pasti untuk log keluar?', onPressed: () async {
                await authService.logout();
              });
            },
          ),
        ]),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //     elevation: 4,
      //     currentIndex: currentIndex,
      //     selectedIconTheme: IconThemeData(color: CustomColor.primary.shade700),
      //     unselectedIconTheme: const IconThemeData(color: Colors.grey),
      //     showSelectedLabels: true,
      //     showUnselectedLabels: true,
      //     selectedItemColor: CustomColor.primary.shade700,
      //     unselectedItemColor: Colors.grey,
      //     onTap: (i) {
      //       setState(() {
      //         currentIndex = i;
      //       });
      //     },
      //     items: items)
    );
  }
}
