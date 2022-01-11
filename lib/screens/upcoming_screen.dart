import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/launch_model.dart';
import '../services/get_data_service.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/filter_button.dart';
import 'launch_details_screen.dart';

class UpcomingScreen extends StatefulWidget {
  static const routeName = '/upcoming-launches';

  const UpcomingScreen({Key? key}) : super(key: key);

  @override
  State<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  List<LaunchModel> data = [];
  List<LaunchModel> originalData = [];
  List<String>? selectedLaunchesList = [];
  bool _isLoading = true;

  Future<List<LaunchModel>> getUpcommingLaunches() async {
    final GetDataService api = GetDataService();
    List<LaunchModel> response = await api.getUpcommingLaunches();

    setState(() {
      data = response;
      originalData = response;
      _isLoading = false;
    });

    return response;
  }

  LaunchModel? getFirstImage() {
    return data.firstWhereOrNull((item) => item.links.patch.small != null);
  }

  void filterResults(List<String> selected) {
    List<LaunchModel> filteredLaunches = [];

    selectedLaunchesList = selected;

    if (selectedLaunchesList!.isEmpty) {
      setState(() {
        data = originalData;
      });
    } else if (selectedLaunchesList!.isNotEmpty) {
      selectedLaunchesList?.forEach((selected) {
        originalData.forEach((launch) {
          if (launch.name == selected) {
            filteredLaunches.add(launch);
          }
        });
      });
    }

    if (filteredLaunches.isNotEmpty) {
      setState(() {
        data = filteredLaunches;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Upcoming launches'),
        ),
        drawer: const CustomDrawer(),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                alignment: AlignmentDirectional.bottomEnd,
                fit: StackFit.loose,
                children: [
                    Column(
                      children: [
                        if (getFirstImage() != null)
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                      getFirstImage()?.links.patch.small,
                                    ),
                                    fit: BoxFit.cover)),
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            height: 200,
                            child: Image.asset(
                              'assets/images/Rocket.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        Expanded(
                            child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = data[index];

                            return Column(children: [
                              ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item.name),
                                      Text(DateFormat('MMMM dd, yyyy - HH:mm')
                                          .format(
                                              DateTime.parse(item.date_utc))),
                                    ],
                                  ),
                                  leading: item.links.patch.small != null
                                      ? Container(
                                          width: 44.0,
                                          height: 44.0,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    item.links.patch.small
                                                        .toString(),
                                                  ),
                                                  fit: BoxFit.cover)),
                                        )
                                      : const SizedBox(
                                          width: 44.0,
                                          height: 44.0,
                                          child: Icon(Icons.adb)),
                                  trailing: Text(
                                      '# ${item.flight_number.toString()}'),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, LaunchDetails.routeName,
                                        arguments: ScreenArguments(item.id));
                                  }),
                              const Divider()
                            ]);
                          },
                        )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: FilterButton(
                          data: originalData
                              .map((launch) => launch.name)
                              .toList(),
                          selected: selectedLaunchesList,
                          filterResults: (selected) => filterResults(selected)),
                    )
                  ]));
  }

  @override
  void initState() {
    super.initState();
    getUpcommingLaunches();
  }
}
