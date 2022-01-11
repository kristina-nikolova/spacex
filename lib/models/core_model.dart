class CoreModel {
  final String id;
  final String status;
  final String serial;
  final String last_update;
  final int asds_landings;
  final int asds_attempts;
  final int rtls_landings;
  final int rtls_attempts;
  final int reuse_count;
  final int block;
  final List<String> launches;

  CoreModel({
    required this.id,
    required this.status,
    required this.serial,
    required this.last_update,
    required this.asds_landings,
    required this.asds_attempts,
    required this.rtls_landings,
    required this.rtls_attempts,
    required this.reuse_count,
    required this.block,
    required this.launches,
  });

  factory CoreModel.jsonParse(Map<String, dynamic> json) {
    List<String> _convertList(List<dynamic> list) {
      return list.map((e) => e as String).toList();
    }

    return CoreModel(
      id: json['id'],
      status: json['status'],
      serial: json['serial'],
      last_update: json['last_update'],
      asds_landings: json['asds_landings'],
      asds_attempts: json['asds_attempts'],
      rtls_landings: json['rtls_landings'],
      rtls_attempts: json['rtls_attempts'],
      reuse_count: json['reuse_count'],
      block: json['block'],
      launches: _convertList(json['launches']),
    );
  }
}
