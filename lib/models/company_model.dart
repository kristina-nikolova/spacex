class CompanyModel {
  final String id;
  final String name;
  final String summary;
  final String founder;
  final int founded;
  final int employees;
  final int vehicles;
  final LinksModel links;

  CompanyModel({
    required this.id,
    required this.name,
    required this.summary,
    required this.founder,
    required this.founded,
    required this.employees,
    required this.vehicles,
    required this.links,
  });

  factory CompanyModel.jsonParse(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      name: json['name'],
      summary: json['summary'],
      founder: json['founder'],
      founded: json['founded'],
      employees: json['employees'],
      vehicles: json['vehicles'],
      links: LinksModel.jsonParse(json['links']),
    );
  }
}

class LinksModel {
  final String website;
  final String flickr;
  final String twitter;
  final String elon_twitter;

  LinksModel(
      {required this.website,
      required this.flickr,
      required this.twitter,
      required this.elon_twitter});

  factory LinksModel.jsonParse(Map<String, dynamic> json) {
    return LinksModel(
        website: json['website'],
        flickr: json['flickr'],
        twitter: json['twitter'],
        elon_twitter: json['elon_twitter']);
  }
}
