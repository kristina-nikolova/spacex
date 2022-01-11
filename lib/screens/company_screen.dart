import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/company_model.dart';
import '../services/get_data_service.dart';
import '../widgets/custom_drawer.dart';

class CompanyScreen extends StatefulWidget {
  static const routeName = '/company';

  const CompanyScreen({Key? key}) : super(key: key);

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  CompanyModel? data;
  bool _isLoading = true;

  Future<CompanyModel> getCompany() async {
    final GetDataService api = GetDataService();
    CompanyModel response = await api.getCompany();

    setState(() {
      data = response;
      _isLoading = false;
    });

    return response;
  }

  void _launchURL(String? url) async {
    if (!await launch(url as String)) {
      throw 'Could not launch ${url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Company'),
        ),
        drawer: const CustomDrawer(),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(children: [
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Image.asset(
                      'assets/images/Company.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(children: [
                    Card(
                      margin:
                          const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('COMPANY',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Name'),
                                    Text('${data?.name}'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Founder'),
                                    Text('${data?.founder}'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Founded at'),
                                    Text('${data?.founded}'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Employees count'),
                                    Text('${data?.employees}'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Vehicle count'),
                                    Text('${data?.vehicles}'),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                        margin: const EdgeInsetsDirectional.fromSTEB(
                            20, 10, 20, 20),
                        child: Column(children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('SUMMARY',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('${data?.summary}'),
                          )
                        ])),
                    Card(
                        margin: const EdgeInsetsDirectional.fromSTEB(
                            20, 10, 20, 20),
                        child: Column(children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('LINKS',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Column(children: [
                            ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Website'),
                                  ],
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => _launchURL(data?.links.website)),
                            const Divider(),
                            ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Flickr'),
                                  ],
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => _launchURL(data?.links.flickr)),
                            const Divider(),
                            ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('SpaceX Twitter'),
                                  ],
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => _launchURL(data?.links.twitter)),
                            const Divider(),
                            ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Elon Musk Twitter'),
                                  ],
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () =>
                                    _launchURL(data?.links.elon_twitter)),
                          ])
                        ]))
                  ])
                ]),
              ));
  }

  @override
  void initState() {
    super.initState();
    getCompany();
  }
}
