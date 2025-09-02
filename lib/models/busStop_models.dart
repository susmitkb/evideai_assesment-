// models/busStop_models.dart
class BusStop {
  final String stopname;
  final double latitude;
  final double longitude;
  final int timedifference;
  String? stopTime;

  BusStop({
    required this.stopname,
    required this.latitude,
    required this.longitude,
    required this.timedifference,
    this.stopTime,
  });

  factory BusStop.fromJson(Map<String, dynamic> json) {
    print('Parsing JSON: $json');

    return BusStop(
      stopname: _parseString(json['stopname']),
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      timedifference: _parseInt(json['timedifference']),
      stopTime: _parseString(json['stopTime']),
    );
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'stopname': stopname,
      'latitude': latitude,
      'longitude': longitude,
      'timedifference': timedifference,
      'stopTime': stopTime,
    };
  }
}