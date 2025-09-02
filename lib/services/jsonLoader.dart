// services/json_loader_service.dart
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:teamevideai/models/busStop_models.dart';

class JsonLoaderService extends GetxService {
  Future<List<BusStop>> loadStopsFromDartFile() async {
    try {
      print('Loading Dart file from assets...');

      // Load the file as text
      final String fileContent = await rootBundle.loadString('assets/mock/stops.json');

      // Parse the Dart code format
      final Map<String, dynamic> parsedData = _parseDartMapString(fileContent);

      print('Dart file parsed successfully. Keys found: ${parsedData.keys.join(', ')}');

      // Extract stops from all routes
      List<BusStop> allStops = [];

      if (parsedData.containsKey('tirTOkuttp')) {
        final tirTOkuttpStops = (parsedData['tirTOkuttp'] as List);
        print('Found ${tirTOkuttpStops.length} stops in tirTOkuttp');

        for (var stopJson in tirTOkuttpStops) {
          try {
            final busStop = BusStop.fromJson(stopJson);
            allStops.add(busStop);
          } catch (e) {
            print('Error parsing stop: $e');
          }
        }
      }

      if (parsedData.containsKey('ktklTotir')) {
        final ktklTotirStops = (parsedData['ktklTotir'] as List);
        print('Found ${ktklTotirStops.length} stops in ktklTotir');

        for (var stopJson in ktklTotirStops) {
          try {
            final busStop = BusStop.fromJson(stopJson);
            allStops.add(busStop);
          } catch (e) {
            print('Error parsing stop: $e');
          }
        }
      }

      if (parsedData.containsKey('tirtoktkl')) {
        final tirtoktklStops = (parsedData['tirtoktkl'] as List);
        print('Found ${tirtoktklStops.length} stops in tirtoktkl');

        for (var stopJson in tirtoktklStops) {
          try {
            final busStop = BusStop.fromJson(stopJson);
            allStops.add(busStop);
          } catch (e) {
            print('Error parsing stop: $e');
          }
        }
      }

      print('Total stops loaded: ${allStops.length}');
      return allStops;
    } catch (e, stackTrace) {
      print('Error loading Dart file: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> _parseDartMapString(String dartCode) {
    try {
      // This is a simplified parser that handles your specific Dart format
      final Map<String, dynamic> result = {};

      // Extract each array using regex
      final tirTOkuttpMatch = RegExp(r"tirTOkuttp\s*=\s*\[(.*?)\];", dotAll: true).firstMatch(dartCode);
      final ktklTotirMatch = RegExp(r"ktklTotir\s*=\s*\[(.*?)\];", dotAll: true).firstMatch(dartCode);
      final tirtoktklMatch = RegExp(r"tirtoktkl\s*=\s*\[(.*?)\];", dotAll: true).firstMatch(dartCode);

      if (tirTOkuttpMatch != null) {
        result['tirTOkuttp'] = _parseArray(tirTOkuttpMatch.group(1)!);
      }

      if (ktklTotirMatch != null) {
        result['ktklTotir'] = _parseArray(ktklTotirMatch.group(1)!);
      }

      if (tirtoktklMatch != null) {
        result['tirtoktkl'] = _parseArray(tirtoktklMatch.group(1)!);
      }

      return result;
    } catch (e) {
      print('Error parsing custom format: $e');
      return {};
    }
  }

  List<Map<String, dynamic>> _parseArray(String arrayContent) {
    final List<Map<String, dynamic>> result = [];

    // Split into individual objects
    final objectPattern = RegExp(r"\{(.*?)\}", dotAll: true);
    final matches = objectPattern.allMatches(arrayContent);

    for (final match in matches) {
      final objectContent = match.group(1)!;
      final Map<String, dynamic> objectMap = {};

      // Parse key-value pairs
      final propertyPattern = RegExp(r"'(.*?)'\s*:\s*(.*?)(?=,\s*'|$)", dotAll: true);
      final propertyMatches = propertyPattern.allMatches(objectContent);

      for (final propertyMatch in propertyMatches) {
        final key = propertyMatch.group(1)!;
        var value = propertyMatch.group(2)!.trim();

        // Remove trailing commas
        if (value.endsWith(',')) {
          value = value.substring(0, value.length - 1);
        }

        // Parse the value based on its content
        if (value.startsWith("'") && value.endsWith("'")) {
          // String value
          objectMap[key] = value.substring(1, value.length - 1);
        } else if (value.contains(RegExp(r'^\d+\.\d+$'))) {
          // Double value
          objectMap[key] = double.parse(value);
        } else if (value.contains(RegExp(r'^\d+$'))) {
          // Integer value
          objectMap[key] = int.parse(value);
        } else {
          // Keep as string (for empty strings, null, etc.)
          objectMap[key] = value;
        }
      }

      result.add(objectMap);
    }

    return result;
  }
}