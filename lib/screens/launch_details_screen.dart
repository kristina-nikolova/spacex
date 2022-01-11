import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/launch_model.dart';
import '../models/rocket_model.dart';
import '../services/get_data_service.dart';

class ScreenArguments {
  final String id;

  ScreenArguments(this.id);
}

class LaunchDetails extends StatefulWidget {
  static const routeName = '/upcoming-launch-details';

  String? id;

  LaunchDetails({Key? key, this.id}) : super(key: key);

  @override
  State<LaunchDetails> createState() => _LaunchDetailsState();
}

class _LaunchDetailsState extends State<LaunchDetails> {
  LaunchModel? data;
  RocketModel? rocket;

  bool _isInit = true;
  bool _isLoading = true;

  Future<LaunchModel> getLaunchDetails() async {
    final GetDataService api = GetDataService();
    LaunchModel response = await api.getLaunchDetails(widget.id);

    setState(() {
      data = response;
    });
    getRocketDetails(data?.rocket);

    return response;
  }

  Future<RocketModel> getRocketDetails(String? rocketId) async {
    final GetDataService api = GetDataService();
    RocketModel response = await api.getRocketDetails(rocketId);

    setState(() {
      rocket = response;
      _isLoading = false;
    });

    return response;
  }

  void _launchURL() async {
    if (!await launch(data?.links.webcast))
      throw 'Could not launch ${data?.links.webcast}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Upcoming launch details'),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      fit: StackFit.loose,
                      children: [
                        if (data?.links.patch.small != null)
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                      data!.links.patch.small.toString(),
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
                        Container(
                          width: double.infinity,
                          color: Colors.black38,
                          padding: const EdgeInsetsDirectional.all(10),
                          child: Text(
                            '${rocket?.name} Test Flight',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 30),
                          ),
                        ),
                      ]),
                  Card(
                    margin:
                        const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          rocket!.flickr_images[0].toString(),
                                        ),
                                        fit: BoxFit.cover)),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${rocket?.name} Test Flight',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(DateFormat('MMMM dd, yyyy - HH:mm')
                                      .format(DateTime.parse(data!.date_utc))),
                                ],
                              ),
                              if (data?.links.webcast != null)
                                Container(
                                  child: IconButton(
                                    icon: const Icon(
                                        Icons.ondemand_video_rounded),
                                    onPressed: _launchURL,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  width: 50,
                                  height: 50,
                                )
                            ],
                          ),
                        ),
                        if (data?.details != null)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(data?.details),
                          ),
                      ],
                    ),
                  ),
                  Card(
                    margin:
                        const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 20),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('ROCKET',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Model'),
                              Text('${rocket?.name}'),
                            ],
                          ),
                          if (data?.static_fire_date_utc != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Static fire'),
                                Text(DateFormat.yMMMd().format(DateTime.parse(
                                    data?.static_fire_date_utc))),
                              ],
                            ),
                          if (data?.window != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Launch window'),
                                Text('${data?.window}'),
                              ],
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Launch success'),
                              data?.success == true
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : const Icon(
                                      Icons.close_rounded,
                                      color: Colors.red,
                                    )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      widget.id =
          (ModalRoute.of(context)?.settings.arguments as ScreenArguments).id;
      if (widget.id != null) {
        getLaunchDetails();
      }
    }
    _isInit = false;
  }
}
