import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
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
    var userController = context.watch<UserController>();
    // var projectController = context.watch<ProjectController>();
    var fbUser = context.watch<User?>();

    if (fbUser == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.primary,
        // title: Text(header.elementAt(currentIndex)),
        title: const Text('Utama'),
      ),
      // body: screens.elementAt(currentIndex),
      body: const HomeScreen(),
      drawer: Drawer(
        child: StreamBuilder<List<SplebUser>>(
            stream: userController.readOne(fbUser.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.requireData.isEmpty) {
                  return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch, children: const [Text('Sorry there are problems')]));
                }
                var splebUser = snapshot.requireData.first;
                return ListView(children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    height: 200,
                    color: CustomColor.primary,
                    child:
                        Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  if (splebUser.role.name == 'Pengurus Projek' || splebUser.role.name == 'Pegawai')
                    ListTile(
                      title: const Text('Urus Projek'),
                      trailing: const Icon(
                        Icons.file_copy,
                        color: CustomColor.primary,
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(UrusProjek.routeName, arguments: splebUser);
                      },
                    ),
                  ListTile(
                    title: const Text('Projek'),
                    trailing: const Icon(
                      Icons.file_copy,
                      color: CustomColor.primary,
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(ProjectScreen.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text('Buku Log'),
                    trailing: const Icon(
                      Icons.book,
                      color: CustomColor.primary,
                    ),
                    onTap: () async {
                      Navigator.of(context)
                          .pushNamed(BukuLogListScreen.routeName, arguments: BukuLogListArg(ShowBook.both, null));
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
                ]);
              } else if (snapshot.hasError) {
                return Text('Error ${snapshot.error}');
              } else {
                return const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
              }
            }),
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
