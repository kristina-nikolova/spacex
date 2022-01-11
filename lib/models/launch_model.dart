class LaunchModel {
  final String id;
  final String date_utc;
  final dynamic details;
  final dynamic static_fire_date_utc;
  final List<CoreShortModel> cores;
  final String launchpad;
  final String name;
  final int flight_number;
  final String rocket;
  final dynamic success;
  final LinksModel links;
  final dynamic window;

  LaunchModel(
      {required this.id,
      required this.date_utc,
      this.details,
      this.static_fire_date_utc,
      required this.cores,
      required this.launchpad,
      required this.name,
      required this.flight_number,
      required this.rocket,
      this.success,
      required this.links,
      this.window});

  factory LaunchModel.jsonParse(Map<String, dynamic> json) {
    List<CoreShortModel> _convertCoreModel(List<dynamic> list) {
      return list.map((e) => CoreShortModel.jsonParse(e)).toList();
    }

    return LaunchModel(
        id: json['id'],
        date_utc: json['date_utc'],
        details: json['details'],
        static_fire_date_utc: json['static_fire_date_utc'],
        cores: _convertCoreModel(json['cores']),
        name: json['name'],
        launchpad: json['launchpad'],
        flight_number: json['flight_number'],
        rocket: json['rocket'],
        success: json['success'],
        links: LinksModel.jsonParse(json['links']),
        window: json['window']);
  }
}

class LinksModel {
  final PatchModel patch;
  final RedditModel reddit;
  final FlickrModel flickr;
  final dynamic webcast;

  LinksModel(
      {required this.patch,
      required this.reddit,
      required this.flickr,
      this.webcast});

  factory LinksModel.jsonParse(Map<String, dynamic> json) {
    return LinksModel(
        patch: PatchModel.jsonParse(json['patch']),
        reddit: RedditModel.jsonParse(json['reddit']),
        flickr: FlickrModel.jsonParse(json['flickr']),
        webcast: json['webcast']);
  }
}

class PatchModel {
  final dynamic small;
  final dynamic large;

  PatchModel({required this.small, required this.large});

  factory PatchModel.jsonParse(Map<String, dynamic> json) {
    return PatchModel(small: json['small'], large: json['large']);
  }
}

class RedditModel {
  final dynamic campaign;
  final dynamic launch;

  RedditModel({required this.campaign, required this.launch});

  factory RedditModel.jsonParse(Map<String, dynamic> json) {
    return RedditModel(campaign: json['campaign'], launch: json['launch']);
  }
}

class FlickrModel {
  final List<String> small;
  final List<String> original;

  FlickrModel({required this.small, required this.original});

  factory FlickrModel.jsonParse(Map<String, dynamic> json) {
    List<String> _convertList(List<dynamic> list) {
      return list.map((e) => e as String).toList();
    }

    return FlickrModel(
        small: _convertList(json['small']),
        original: _convertList(json['original']));
  }
}

class CoreShortModel {
  String? core;

  CoreShortModel({required this.core});

  factory CoreShortModel.jsonParse(Map<String, dynamic> json) {
    return CoreShortModel(core: json['core']);
  }
}
