// controllers/busStop_controllers.dart
import 'package:get/get.dart';
import 'package:teamevideai/models/busStop_models.dart';
import 'package:teamevideai/services/jsonLoader.dart'; // Import JsonLoaderService

class BusStopController extends GetxController {
  var allStops = <BusStop>[].obs;
  var filteredStops = <BusStop>[].obs;
  var searchQuery = ''.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Use a slight delay to avoid the "visitChildElements() called during build" error
    Future.delayed(Duration.zero, () {
      loadStops();
    });
  }

  Future<void> loadStops() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('Loading stops using JSON loader...');

      // Get the JSON loader service
      final JsonLoaderService dataLoader = Get.find<JsonLoaderService>();

      // Load stops
      final List<BusStop> stops = await dataLoader.loadStopsFromDartFile();

      // Update the observable lists
      allStops.assignAll(stops);
      filteredStops.assignAll(stops);

      print('Successfully loaded ${stops.length} stops');

      // Debug: Check if data is correct
      if (stops.isNotEmpty) {
        for (int i = 0; i < (stops.length > 5 ? 5 : stops.length); i++) {
          final stop = stops[i];
          print('Stop $i: ${stop.stopname}, Lat: ${stop.latitude}, Lng: ${stop.longitude}');
        }
      } else {
        print('No stops were loaded. This indicates a parsing issue.');
        errorMessage.value = 'No bus stops found. Please check the data format.';
      }
    } catch (e, stackTrace) {
      print('Error loading stops: $e');
      print('Stack trace: $stackTrace');

      errorMessage.value = 'Failed to load bus stops: $e';
      Get.snackbar(
        'Error',
        'Failed to load bus stops',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterStops(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredStops.assignAll(allStops);
    } else {
      filteredStops.assignAll(
          allStops.where((stop) =>
              stop.stopname.toLowerCase().contains(query.toLowerCase())
          ).toList()
      );
    }
  }
}