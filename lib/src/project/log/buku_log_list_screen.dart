import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/helper/log_helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/root/screens.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/widget/custom_widget.dart';

enum ShowBook { oshe, quality, both }

class BukuLogListArg {
  final ShowBook showBook;
  final Projek? projek;

  BukuLogListArg(this.showBook, this.projek);
}

class BukuLogListScreen extends StatefulWidget {
  const BukuLogListScreen({super.key, required this.showBook, required this.projek});
  final ShowBook showBook;
  final Projek? projek;
  static const routeName = '/buku-logs';
  @override
  State<BukuLogListScreen> createState() => _BukuLogListScreenState();
}

class _BukuLogListScreenState extends State<BukuLogListScreen> {
  @override
  Widget build(BuildContext context) {
    var bukuLogOSHEController = context.watch<BukuLogOSHEController>();
    var bukuLogController = context.watch<BukuLogController>();
    var userController = context.watch<UserController>();
    var fbUser = context.watch<User?>();
    if (fbUser == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.primary,
          title: widget.showBook == ShowBook.oshe
              ? Text('Buku Log OSHE ${widget.projek?.nama ?? ''}')
              : Text('Buku Log ${widget.projek?.nama ?? ''}'),
        ),
        body: SizedBox(
            height: SizeConfig(context).scaledHeight(),
            width: SizeConfig(context).scaledWidth(),
            child: StreamBuilder<List<SplebUser>>(
                stream: userController.readOne(fbUser.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var splebUser = snapshot.requireData.first;
                    return SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Form(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                              if (widget.showBook == ShowBook.oshe)
                                StreamBuilder<List<BukuLogOSHE>>(
                                    stream: bukuLogOSHEController.readByProjek(id: widget.projek?.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var bukulogs = snapshot.requireData;
                                        if (bukulogs.isEmpty) return const Text('Tiada Buku Log OSHE');
                                        logError('buku logs OSHE:$bukulogs');
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            physics: const ClampingScrollPhysics(),
                                            itemCount: bukulogs.length,
                                            itemBuilder: (c, i) {
                                              var no = i + 1;
                                              var bukuLog = bukulogs[i];
                                              return Container(
                                                margin: const EdgeInsets.all(8),
                                                color: Colors.grey.shade400,
                                                child: ListTile(
                                                  onTap: () {
                                                    Navigator.of(context).pushNamed(BukuLogOSHEScreen.routeName,
                                                        arguments: BukuLogScreenArg(widget.projek, splebUser, null, bukuLog,
                                                            viewOnly: true));
                                                  },
                                                  leading: Text('$no'),
                                                  title: Text(bukuLog.id),
                                                ),
                                              );
                                            });
                                      } else if (snapshot.hasError) {
                                        return Text('Error ${snapshot.error}');
                                      } else {
                                        return const Center(
                                            child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
                                      }
                                    }),
                              if (widget.showBook == ShowBook.quality)
                                StreamBuilder<List<BukuLogQuality>>(
                                    stream: bukuLogController.readByProjek(id: widget.projek?.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var bukulogs = snapshot.requireData;

                                        if (bukulogs.isEmpty) return const Text('Tiada Buku Log Quality');
                                        logError('buku logs :$bukulogs');
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            physics: const ClampingScrollPhysics(),
                                            itemCount: bukulogs.length,
                                            itemBuilder: (c, i) {
                                              var no = i + 1;
                                              var bukuLog = bukulogs[i];
                                              return Container(
                                                margin: const EdgeInsets.all(8),
                                                color: Colors.grey.shade400,
                                                child: ListTile(
                                                  onTap: () {
                                                    Navigator.of(context).pushNamed(BukuLogScreen.routeName,
                                                        arguments: BukuLogScreenArg(widget.projek, splebUser, bukuLog, null,
                                                            viewOnly: true));
                                                  },
                                                  leading: Text('$no'),
                                                  title: Text(bukuLog.id),
                                                ),
                                              );
                                            });
                                      } else if (snapshot.hasError) {
                                        return Text('Error ${snapshot.error}');
                                      } else {
                                        return const Center(
                                            child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
                                      }
                                    }),
                              if (widget.showBook == ShowBook.both)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    CustomButton(
                                        titleButton: 'OSHE',
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(BukuLogListScreen.routeName,
                                              arguments: BukuLogListArg(ShowBook.oshe, widget.projek));
                                        }),
                                    SizedBoxHelper.sizedboxH16,
                                    CustomButton(
                                        titleButton: 'Quality',
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(BukuLogListScreen.routeName,
                                              arguments: BukuLogListArg(ShowBook.quality, widget.projek));
                                        })
                                  ],
                                )
                            ]))));
                  } else if (snapshot.hasError) {
                    return Text('Error ${snapshot.error}');
                  } else {
                    return const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
                  }
                })));
  }
}
