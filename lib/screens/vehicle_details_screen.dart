import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/dragon_model.dart';
import '../models/roadster_model.dart';
import '../models/rocket_model.dart';
import '../models/ship_model.dart';
import '../models/vehicle_model.dart';
import '../providers/favorites.dart';
import '../services/get_data_service.dart';

class ScreenArguments {
  final String id;
  final String type;

  ScreenArguments(this.id, this.type);
}

class VehicleDetailsScreen extends StatefulWidget {
  static const routeName = '/vehicle-details';

  String? id;
  String? type;

  VehicleDetailsScreen({Key? key, this.id}) : super(key: key);

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetailsScreen> {
  dynamic data;

  bool _isInit = true;
  bool _isLoading = true;

  Future<RocketModel> getRocketDetails(String? rocketId) async {
    final GetDataService api = GetDataService();
    RocketModel response = await api.getRocketDetails(rocketId);

    setState(() {
      data = response;
      _isLoading = false;
    });

    return response;
  }

  Future<RoadsterModel> getRoadsterDetails() async {
    final GetDataService api = GetDataService();
    RoadsterModel response = await api.getRoadsterDetails();

    setState(() {
      data = response;
      _isLoading = false;
    });

    return response;
  }

  Future<ShipModel> getShipDetails(String? shipId) async {
    final GetDataService api = GetDataService();
    ShipModel response = await api.getShipDetails(shipId);

    setState(() {
      data = response;
      _isLoading = false;
    });

    return response;
  }

  Future<DragonModel> getDragonDetails(String? dragonId) async {
    final GetDataService api = GetDataService();
    DragonModel response = await api.getDragonDetails(dragonId);

    setState(() {
      data = response;
      _isLoading = false;
    });

    return response;
  }

  void _launchURL() async {
    if (!await launch(data?.video)) {
      throw 'Could not launch ${data?.video}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    void togleFavorite(dynamic vehicle) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        if (favoritesProvider.isFavorite(data.id)) {
          favoritesProvider.removeFromFavVehicles(data.id);
        } else {
          VehicleModel _newVehicle = VehicleModel(
              id: vehicle.id, name: vehicle.name, type: widget.type);
          if (data is ShipModel) {
            _newVehicle.image = vehicle.image;
          } else {
            _newVehicle.flickr_images = vehicle.flickr_images;
          }
          if (data is! ShipModel && vehicle.launch_date_utc != null) {
            _newVehicle.first_flight = vehicle.launch_date_utc;
          }

          favoritesProvider.addToFavVehicles(_newVehicle);
        }
      });
      // Store data in SharedPreferences
      final String encodedData =
          VehicleModel.encode(favoritesProvider.favVehicles);
      await prefs.setString('favoriteVehicles', encodedData);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Vehicle details'),
        ),
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
                        Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            fit: StackFit.loose,
                            children: [
                              if (data is ShipModel && data?.image != null)
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            data!.image.toString(),
                                          ),
                                          fit: BoxFit.cover)),
                                )
                              else if (data is! ShipModel &&
                                  data!.flickr_images.isNotEmpty)
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            data!.flickr_images[0].toString(),
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
                                  '${data?.name}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 30),
                                ),
                              ),
                            ]),
                        Card(
                          margin: const EdgeInsetsDirectional.fromSTEB(
                              20, 20, 20, 10),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('DESCRIPTION',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    if (data is! ShipModel)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Launch date',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(DateFormat(
                                                  'MMMM dd, yyyy - HH:mm')
                                              .format(DateTime.parse(
                                                  data!.launch_date_utc))),
                                        ],
                                      ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Launch vehicle',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('${data?.name}'),
                                      ],
                                    ),
                                    if (data is RoadsterModel &&
                                        data?.video != null)
                                      Container(
                                        child: IconButton(
                                          icon: const Icon(
                                              Icons.ondemand_video_rounded),
                                          onPressed: _launchURL,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        width: 50,
                                        height: 50,
                                      )
                                  ],
                                ),
                              ),
                              if (data?.description != null)
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(data!.description),
                                )
                            ],
                          ),
                        ),
                        Card(
                          margin: const EdgeInsetsDirectional.fromSTEB(
                              20, 10, 20, 20),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('VEHICLE',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              if (data is RoadsterModel)
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Weight'),
                                        Text('${data?.launch_mass_kg} kg'),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Speed'),
                                        Text('${data?.speed_mph} km/h'),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Earth distance'),
                                        Text('${data?.earth_distance_mi} km'),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Mars distance'),
                                        Text('${data?.mars_distance_km} km'),
                                      ],
                                    ),
                                  ]),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // not consistent apis
                                      const Text('Weight'),
                                      if (data is RocketModel)
                                        Text('${data?.mass?.kg} kg'),
                                      if (data is ShipModel)
                                        Text('${data?.mass_kg} kg'),
                                      if (data is DragonModel)
                                        Text('${data?.dry_mass_kg} kg'),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        child: IconButton(
                          icon: favoritesProvider.isFavorite(data.id)
                              ? const Icon(Icons.favorite)
                              : const Icon(Icons.favorite_border),
                          onPressed: () => togleFavorite(data),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Theme.of(context).primaryColor,
                        ),
                        width: 50,
                        height: 50,
                      ),
                    )
                  ]));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      widget.id =
          (ModalRoute.of(context)?.settings.arguments as ScreenArguments).id;
      widget.type =
          (ModalRoute.of(context)?.settings.arguments as ScreenArguments).type;

      if (widget.id != null) {
        if (widget.type == 'rocket') getRocketDetails(widget.id);
        if (widget.type == 'roadster') getRoadsterDetails();
        if (widget.type == 'dragon') getDragonDetails(widget.id);
        if (widget.type == 'ship') getShipDetails(widget.id);
      }
    }
    _isInit = false;
  }
}
