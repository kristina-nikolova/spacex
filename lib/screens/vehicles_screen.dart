import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/vehicle_model.dart';
import '../providers/favorites.dart';
import '../services/get_data_service.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/filter_button.dart';
import 'vehicle_details_screen.dart';

enum FilterOptions {
  favorites,
  all,
}

class VehiclesScreen extends StatefulWidget {
  static const routeName = '/vehicles';

  const VehiclesScreen({Key? key}) : super(key: key);

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  List<VehicleModel> data = [];
  List<VehicleModel> originalData = [];
  List<VehicleModel> favorites = [];
  List<String>? selectedVehiclesList = [];
  bool _isLoading = true;
  bool _showOnlyFavorites = false;

  Future<List<VehicleModel>> getVehicles() async {
    final GetDataService api = GetDataService();
    List<VehicleModel> response = await api.getVehicles();

    setState(() {
      data = response;
      data.sort((a, b) =>
          (a.first_flight.toString()).compareTo(b.first_flight.toString()));
      originalData = data;

      _isLoading = false;
    });

    return response;
  }

  Widget getAvatar(imageUrl) {
    return Container(
      width: 44.0,
      height: 44.0,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                imageUrl,
              ),
              fit: BoxFit.cover)),
    );
  }

  VehicleModel? getFirstImage() {
    return data.firstWhereOrNull((item) => item.image != null);
  }

  void filterResults(List<String> selected) {
    List<VehicleModel> filteredVehicles = [];

    selectedVehiclesList = selected;

    if (selectedVehiclesList!.isEmpty) {
      setState(() {
        data = originalData;
      });
    } else if (selectedVehiclesList!.isNotEmpty) {
      selectedVehiclesList?.forEach((selected) {
        originalData.forEach((launch) {
          if (launch.name == selected) {
            filteredVehicles.add(launch);
          }
        });
      });
    }

    if (filteredVehicles.isNotEmpty) {
      setState(() {
        data = filteredVehicles;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    Future<List<VehicleModel>> getFavorites() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<VehicleModel> decodedData = [];

      // prefs.remove("favoriteVehicles");
      // print(prefs.containsKey("favoriteVehicles"));

      if (prefs.containsKey("favoriteVehicles")) {
        // Get data from SharedPreferences
        String encodedData = prefs.getString('favoriteVehicles') as String;
        decodedData = VehicleModel.decode(encodedData);

        favoritesProvider.updateFavVehicles(decodedData);
      }

      favorites = decodedData;
      return decodedData;
    }

    getFavorites();

    return Scaffold(
      appBar: AppBar(
        title: _showOnlyFavorites
            ? const Text('Favorites Vehicles')
            : const Text('All Vehicles'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.favorites,
              ),
              const PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.all,
              ),
            ],
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Center(
          child: _isLoading
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
                                        getFirstImage()?.image as String,
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
                          if (_showOnlyFavorites && favorites.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child:
                                  Text('You have no favorites vehicles added'),
                            ),
                          Expanded(
                              child: ListView.builder(
                            itemCount: _showOnlyFavorites
                                ? favorites.length
                                : data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = _showOnlyFavorites
                                  ? favorites[index]
                                  : data[index];

                              return Column(children: [
                                ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item.name),
                                        if (item.first_flight != null)
                                          Text(DateFormat(
                                                  'MMMM dd, yyyy - HH:mm')
                                              .format(DateTime.parse(
                                                  item.first_flight as String)))
                                      ],
                                    ),
                                    leading: item.image != null
                                        ? getAvatar(item.image)
                                        : item.flickr_images != null
                                            ? getAvatar(item.flickr_images?[0])
                                            : const SizedBox(
                                                width: 44.0,
                                                height: 44.0,
                                                child: Icon(Icons.adb)),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          VehicleDetailsScreen.routeName,
                                          arguments: ScreenArguments(
                                              item.id, item.type.toString()));
                                    }),
                                const Divider()
                              ]);
                            },
                          )),
                        ],
                      ),
                      if (!_showOnlyFavorites)
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: FilterButton(
                              data: originalData
                                  .map((vehicle) => vehicle.name)
                                  .toList(),
                              selected: selectedVehiclesList,
                              filterResults: (selected) =>
                                  filterResults(selected)),
                        )
                    ])),
    );
  }

  @override
  void initState() {
    super.initState();
    getVehicles();
  }
}
