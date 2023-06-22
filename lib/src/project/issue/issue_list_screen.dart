import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/root/screens.dart';
import 'package:spleb/src/style/style.dart';

class IssueListScreen extends StatefulWidget {
  const IssueListScreen({super.key, required this.projek});
  static const routeName = '/issue-list';
  final Projek projek;
  @override
  State<IssueListScreen> createState() => _IssueListScreenState();
}

class _IssueListScreenState extends State<IssueListScreen> {
  @override
  Widget build(BuildContext context) {
    var issueController = context.watch<IssueController>();
    var userController = context.watch<UserController>();
    var fbUser = context.watch<User?>();
    if (fbUser == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return StreamBuilder<List<SplebUser>>(
        stream: userController.readOne(fbUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.requireData.isEmpty) {
              return SizedBox(
                  height: SizeConfig(context).scaledHeight(),
                  width: SizeConfig(context).scaledWidth(),
                  child: const Padding(
                      padding: EdgeInsets.all(24.0),
                      child:
                          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text('Sorry there are problems')])));
            }
            // var splebUser = snapshot.requireData.first;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: CustomColor.primary,
                title: const Text('Senarai Isu'),
                actions: [
                  IconButton(
                      onPressed: () async {
                        Navigator.of(context).pushNamed(DaftarIssue.routeName, arguments: widget.projek);
                      },
                      icon: const Icon(Icons.add))
                ],
              ),
              body: SizedBox(
                height: SizeConfig(context).scaledHeight(),
                width: SizeConfig(context).scaledWidth(),
                child: StreamBuilder<List<Issue>>(
                    stream: issueController.readByProjek(id: widget.projek.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var issues = snapshot.requireData;
                        return SingleChildScrollView(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: issues.length,
                                itemBuilder: (c, i) {
                                  var isu = issues[i];
                                  var no = i + 1;
                                  return Container(
                                    margin: const EdgeInsets.all(8),
                                    color: Colors.grey.shade400,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(IssueScreen.routeName, arguments: isu);
                                      },
                                      leading: Text('$no'),
                                      title: Text(isu.name),
                                    ),
                                  );
                                })
                          ],
                        ));
                      } else if (snapshot.hasError) {
                        return Text('Error ${snapshot.error}');
                      } else {
                        return const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
                      }
                    }),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          } else {
            return const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
          }
        });
  }
}

class IssueScreen extends StatefulWidget {
  const IssueScreen({super.key, required this.issue});
  final Issue issue;
  static const routeName = '/issue-screen';
  @override
  State<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Issue : ${widget.issue.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [const Text('Description'), SizedBoxHelper.sizedboxH16, Text(widget.issue.description)],
        ),
      ),
    );
  }
}
