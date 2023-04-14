import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/style/style.dart';

class BukuLogListArg {
  final bool showOSHE;
  final Projek projek;

  BukuLogListArg(this.showOSHE, this.projek);
}

class BukuLogListScreen extends StatefulWidget {
  const BukuLogListScreen({super.key, required this.showOSHE, required this.projek});
  final bool showOSHE;
  final Projek projek;
  static const routeName = '/buku-logs';
  @override
  State<BukuLogListScreen> createState() => _BukuLogListScreenState();
}

class _BukuLogListScreenState extends State<BukuLogListScreen> {
  @override
  Widget build(BuildContext context) {
    var bukuLogOSHEController = context.watch<BukuLogOSHEController>();
    var bukuLogController = context.watch<BukuLogController>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.primary,
          title: widget.showOSHE ? Text('Buku Log OSHE ${widget.projek.nama}') : Text('Buku Log ${widget.projek.nama}'),
        ),
        body: SizedBox(
            height: SizeConfig(context).scaledHeight(),
            width: SizeConfig(context).scaledWidth(),
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      if (widget.showOSHE) Column(),
                      if (!widget.showOSHE)
                        StreamBuilder<List<BukuLogQuality>>(
                            stream: bukuLogController.readByProjek(widget.projek.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var bukulogs = snapshot.requireData;

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
                                          leading: Text('$no'),
                                          title: Text(bukuLog.projekId),
                                        ),
                                      );
                                    });
                              } else if (snapshot.hasError) {
                                return Text('Error ${snapshot.error}');
                              } else {
                                return const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
                              }
                            })
                    ]))))));
  }
}
