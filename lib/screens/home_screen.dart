import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/core_model.dart';
import '../models/launch_model.dart';
import '../providers/launchpad.dart';
import '../services/get_data_service.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/home_list_tile.dart';
import 'launchpad_screen.dart';
import 'vehicle_details_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LaunchModel? data;
  List<String> images = [];
  bool _isLoading = true;
  final List<String> defaultCarouselImages = [
    "https://live.staticflickr.com/65535/49635401403_96f9c322dc_o.jpg",
    "https://live.staticflickr.com/65535/49636202657_e81210a3ca_o.jpg",
    "https://live.staticflickr.com/65535/49636202572_8831c5a917_o.jpg",
    "https://live.staticflickr.com/65535/49635401423_e0bef3e82f_o.jpg",
    "https://live.staticflickr.com/65535/49635985086_660be7062f_o.jpg"
  ];

  Future<LaunchModel> getNextLaunch() async {
    final GetDataService api = GetDataService();
    LaunchModel response = await api.getNextLaunch();

    setState(() {
      data = response;
      // No images returned from the server, so added default
      images = data!.links.flickr.original.isNotEmpty
          ? data!.links.flickr.original
          : defaultCarouselImages;

      Provider.of<LaunchpadProvider>(context, listen: false)
          .getLaunchpad(data?.launchpad);

      _isLoading = false;
    });

    return response;
  }

  Future<CoreModel> getCore(String coreId) async {
    final GetDataService api = GetDataService();
    CoreModel response = await api.getCore(coreId);

    setState(() {
      _isLoading = false;
    });

    return response;
  }

  onVehicleTileClick() {
    Navigator.pushNamed(context, VehicleDetailsScreen.routeName,
        arguments: ScreenArguments(data!.rocket, 'rocket'));
  }

  onLaunchpadTileClick() {
    Navigator.pushNamed(context, LaunchpadScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final launchpadProvider = Provider.of<LaunchpadProvider>(context);

    void _dismissDialog() {
      Navigator.pop(context);
    }

    void _showMaterialDialog(coreId) {
      // override coreId, because in most cases it is null
      coreId = '5e9e28a6f35918c0803b265c';
      getCore(coreId).then((core) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Core ${core.serial}'),
                content: Column(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Status'),
                              Text(core.status),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Launches'),
                              Text(core.launches.length.toString()),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('RTLS Landing'),
                              Text(
                                  '${core.rtls_landings}\\${core.rtls_attempts}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('ASDS Landing'),
                              Text(
                                  '${core.asds_landings}\\${core.asds_attempts}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Block'),
                              Text(core.block.toString()),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Reuse count'),
                              Text(core.reuse_count.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(core.last_update)
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        _dismissDialog();
                      },
                      child: const Text('Close')),
                ],
              );
            });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const CustomDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                fit: StackFit.loose,
                children: [
                  Container(
                    color: Colors.black,
                    width: double.infinity,
                    height: 200,
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                        autoPlay: true, viewportFraction: 2, height: 200),
                    items: images
                        .map(
                          (item) => Center(
                              child: Image.network(
                            item,
                            fit: BoxFit.fill,
                            width: double.infinity,
                          )),
                        )
                        .toList(),
                  ),
                  if (data?.date_utc != null)
                    SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(70, 10, 70, 0),
                        child: CountdownTimer(
                          endTime: DateTime.parse(data!.date_utc)
                              .millisecondsSinceEpoch,
                          widgetBuilder: (_, time) {
                            if (time == null) {
                              return Text(
                                  DateFormat('MMMM dd, yyyy - HH:mm')
                                      .format(DateTime.parse(data!.date_utc)),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 40));
                            }
                            return Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text('${time.days ?? 0}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 40)),
                                      const Text('days',
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text('${time.hours}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 40)),
                                      const Text('hours',
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text('${time.min}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 40)),
                                      const Text('min',
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text('${time.sec}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 40)),
                                      const Text('sec',
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  Container(
                    width: double.infinity,
                    color: Colors.black38,
                    padding: const EdgeInsetsDirectional.all(10),
                    child: Column(
                      children: [
                        Text('Next launch: ${data?.name}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 30))
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    HomeListTile(
                        title: 'Launched by who',
                        description: 'It will carry ${data?.name} to IIS orbit',
                        icon: Icons.public,
                        showArrow: true,
                        onTileClicked: onVehicleTileClick),
                    HomeListTile(
                        title: 'Launch date',
                        description: data?.date_utc != null
                            ? 'Sheduled for ${DateFormat('MMMM dd, yyyy - HH:mm').format(DateTime.parse(data!.date_utc))}'
                            : 'Not sheduled yet',
                        icon: Icons.date_range,
                        showArrow: false,
                        onTileClicked: () {}),
                    HomeListTile(
                        title: 'Launchpad',
                        description:
                            'Launch will happen on ${launchpadProvider.launchpad?.name}',
                        icon: Icons.pin_drop_rounded,
                        showArrow: true,
                        onTileClicked: onLaunchpadTileClick),
                    HomeListTile(
                        title: 'Static fire',
                        description: data?.static_fire_date_utc != null
                            ? 'Sheduled for ${DateFormat.yMMMd().format(DateTime.parse(data?.static_fire_date_utc))}'
                            : 'This event is not dated yet',
                        icon: Icons.alarm,
                        showArrow: false,
                        onTileClicked: () {}),
                    Column(
                      children: [
                        for (var core in data!.cores)
                          // if (core.core != null)
                          HomeListTile(
                              title: 'Core ${data!.cores.indexOf(core) + 1}',
                              icon: Icons.adb,
                              showArrow: true,
                              onTileClicked: () =>
                                  _showMaterialDialog(core.core))
                      ],
                    ),
                  ],
                ),
              )
            ]),
    );
  }

  @override
  void initState() {
    super.initState();
    getNextLaunch();
  }
}
