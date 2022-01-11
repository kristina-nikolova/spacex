import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/launch_model.dart';
import '../models/launchpad_model.dart';
import '../providers/launchpad.dart';
import '../services/get_data_service.dart';
import '../widgets/map.dart';

class LaunchpadScreen extends StatefulWidget {
  static const routeName = '/launchpad';

  const LaunchpadScreen({Key? key}) : super(key: key);

  @override
  _LaunchpadScreenState createState() => _LaunchpadScreenState();
}

class _LaunchpadScreenState extends State<LaunchpadScreen> {
  List<LaunchModel> allLaunches = [];
  List<LaunchModel> lounchpadLaunches = [];
  bool _isLoading = true;

  Future<List<LaunchModel>> getAllLaunches() async {
    final GetDataService api = GetDataService();
    List<LaunchModel> response = await api.getPastLaunches();

    setState(() {
      allLaunches = response;
      _isLoading = false;
    });

    return response;
  }

  List<dynamic> findLaunchpadLounches(LaunchpadModel? launchpad) {
    List<dynamic> filteredLaunches = [];

    launchpad?.launches.forEach((launch1) {
      allLaunches.forEach((launch2) {
        if (launch2.id == launch1) {
          filteredLaunches.add(launch2.name);
        }
      });
    });

    return filteredLaunches;
  }

  @override
  Widget build(BuildContext context) {
    final launchpad = Provider.of<LaunchpadProvider>(context).launchpad;
    List<dynamic> launchpadLaunches = findLaunchpadLounches(launchpad);

    return Scaffold(
        appBar: AppBar(
          title: Text('${launchpad?.name} launchpad'),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(children: [
                SizedBox(
                  height: 250,
                  child: MapSample(
                    latitude: launchpad?.latitude as double,
                    longitude: launchpad?.longitude as double,
                  ),
                ),
                Card(
                  margin: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 20),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('LAUNCHPAD INFO',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Full name'),
                                Flexible(
                                  child: Text(
                                    '${launchpad?.full_name}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Launch locality'),
                                Text('${launchpad?.locality}')
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Launch region'),
                                Text('${launchpad?.region}')
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('LAUNCHES',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: launchpadLaunches.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = launchpadLaunches[index];

                    return Column(children: [
                      const Divider(),
                      ListTile(title: Text(item), onTap: () {})
                    ]);
                  },
                )),
              ]));
  }

  @override
  void initState() {
    super.initState();
    getAllLaunches();
  }
}
