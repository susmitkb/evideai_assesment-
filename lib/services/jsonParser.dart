import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:teamevideai/models/busStop_models.dart';

class DartDataLoader extends GetxService {
  Future<List<BusStop>> loadStopsFromDartFile() async {
    try {
      print('Loading Dart file from assets...');

      final String fileContent = await rootBundle.loadString('assets/mock/stops.json');

      List<BusStop> allStops = [];

      final tirTOkuttpMatches = RegExp(r"tirTOkuttp\s*=\s*\[(.*?)\];", dotAll: true).allMatches(fileContent);
      if (tirTOkuttpMatches.isNotEmpty) {
        final tirTOkuttpData = _parseArray(tirTOkuttpMatches.first.group(1)!);
        allStops.addAll(tirTOkuttpData.map((json) => BusStop.fromJson(json)));
      }

      final ktklTotirMatches = RegExp(r"ktklTotir\s*=\s*\[(.*?)\];", dotAll: true).allMatches(fileContent);
      if (ktklTotirMatches.isNotEmpty) {
        final ktklTotirData = _parseArray(ktklTotirMatches.first.group(1)!);
        allStops.addAll(ktklTotirData.map((json) => BusStop.fromJson(json)));
      }

      final tirtoktklMatches = RegExp(r"tirtoktkl\s*=\s*\[(.*?)\];", dotAll: true).allMatches(fileContent);
      if (tirtoktklMatches.isNotEmpty) {
        final tirtoktklData = _parseArray(tirtoktklMatches.first.group(1)!);
        allStops.addAll(tirtoktklData.map((json) => BusStop.fromJson(json)));
      }

      print('Total stops loaded: ${allStops.length}');
      return allStops;
    } catch (e, stackTrace) {
      print('Error loading Dart file: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  List<Map<String, dynamic>> _parseArray(String arrayContent) {
    final List<Map<String, dynamic>> result = [];

    final stopMatches = RegExp(r"\{(.*?)\}", dotAll: true).allMatches(arrayContent);

    for (final match in stopMatches) {
      final stopContent = match.group(1)!;
      final Map<String, dynamic> stopData = {};

      final propertyMatches = RegExp(r"'(.*?)'\s*:\s*(.*?)(?=,\s*'|$)").allMatches(stopContent);

      for (final propMatch in propertyMatches) {
        final key = propMatch.group(1)!;
        dynamic value = propMatch.group(2)!;

        value = value.trim();

        if (value.endsWith(',')) {
          value = value.substring(0, value.length - 1);
        }

        if (value.startsWith("'") && value.endsWith("'")) {
          value = value.substring(1, value.length - 1);
        } else if (value.contains(RegExp(r'^-?\d+\.\d+$'))) {
          value = double.parse(value);
        } else if (value.contains(RegExp(r'^-?\d+$'))) {
          value = int.parse(value);
        }

        stopData[key] = value;
      }

      result.add(stopData);
    }

    return result;
  }
}
class JsonParser {
  static Map<String, dynamic> parseDartMapString(String dartCode) {
    try {
      String jsonString = dartCode.replaceAll(RegExp(r'^\s*final\s+\w+\s*=\s*'), '');
      jsonString = jsonString.replaceAll(RegExp(r';\s*$'), '');

      jsonString = jsonString
          .replaceAllMapped(RegExp(r"'([^']+)'"), (match) => '"${match.group(1)}"')
          .replaceAll(RegExp(r'\s+'), ' ')
          .replaceAll(RegExp(r',\s*}'), '}')
          .replaceAll(RegExp(r',\s*]'), ']');

      return _parseToMap('{$jsonString}');
    } catch (e) {
      print('Error parsing custom format: $e');
      return {};
    }
  }

  static Map<String, dynamic> _parseToMap(String jsonString) {
    final Map<String, dynamic> result = {};

    final patterns = [
      RegExp(r'"tirTOkuttp"\s*:\s*\[(.*?)\]', dotAll: true),
      RegExp(r'"ktklTotir"\s*:\s*\[(.*?)\]', dotAll: true),
      RegExp(r'"tirtoktkl"\s*:\s*\[(.*?)\]', dotAll: true),
    ];

    final arrayNames = ['tirTOkuttp', 'ktklTotir', 'tirtoktkl'];

    for (int i = 0; i < patterns.length; i++) {
      final match = patterns[i].firstMatch(jsonString);
      if (match != null) {
        result[arrayNames[i]] = _parseArray(match.group(1)!);
      }
    }

    return result;
  }

  static List<dynamic> _parseArray(String arrayString) {
    final List<dynamic> result = [];
    final items = arrayString.split(RegExp(r'\},\s*\{'));

    for (String item in items) {
      item = item.replaceAll(RegExp(r'^\{\s*'), '').replaceAll(RegExp(r'\s*\}$'), '');

      final Map<String, dynamic> map = {};
      final properties = item.split(',');

      for (String prop in properties) {
        prop = prop.trim();
        if (prop.isEmpty) continue;

        final colonIndex = prop.indexOf(':');
        if (colonIndex > 0) {
          String key = prop.substring(0, colonIndex).trim();
          String value = prop.substring(colonIndex + 1).trim();

          key = key.replaceAll('"', '');

          if (value.startsWith('"') && value.endsWith('"')) {
            value = value.substring(1, value.length - 1);
          } else if (value.contains('.')) {
            value = double.tryParse(value)?.toString() ?? value;
          } else {
            value = int.tryParse(value)?.toString() ?? value;
          }

          map[key] = value;
        }
      }

      result.add(map);
    }

    return result;
  }
}