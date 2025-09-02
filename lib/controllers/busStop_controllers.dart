import 'dart:async';
import 'package:get/get.dart';
import 'package:teamevideai/models/busStop_models.dart';
import 'package:teamevideai/services/jsonLoader.dart';

class BusStopController extends GetxController {
  final allStops = <BusStop>[].obs;
  final filteredStops = <BusStop>[].obs;

  final searchQuery = ''.obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  final sortMode = Rx<SortMode>(SortMode.nameAsc);
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    Future.microtask(loadStops);
    ever<String>(searchQuery, _debouncedFilter);
    ever<SortMode>(sortMode, (_) => _applyFilters());
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  // Backward-compatible alias for older UI calls
  Future<void> fetchStops() => refreshStops();

  Future<void> refreshStops() async {
    await loadStops(showSnackOnError: false);
  }

  Future<void> loadStops({bool showSnackOnError = true}) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final JsonLoaderService dataLoader = Get.find<JsonLoaderService>();
      final stops = await dataLoader.loadStopsFromDartFile();
      allStops.assignAll(stops);
      _applyFilters();
      if (stops.isEmpty) {
        errorMessage.value = 'No bus stops found. Please check the data format.';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load bus stops: $e';
      if (showSnackOnError) {
        Get.snackbar(
          'Error',
          'Failed to load bus stops',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> retry() => loadStops();

  void filterStops(String query) {
    searchQuery.value = query;
  }

  void clearFilters() {
    searchQuery.value = '';
    _applyFilters();
  }

  void _debouncedFilter(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), _applyFilters);
  }

  void _applyFilters() {
    List<BusStop> list = List<BusStop>.from(allStops);
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((s) => s.stopname.toLowerCase().contains(q)).toList(growable: false);
    }
    list = _sort(list, sortMode.value);
    filteredStops.assignAll(list);
  }

  List<BusStop> _sort(List<BusStop> input, SortMode mode) {
    final list = List<BusStop>.from(input);
    switch (mode) {
      case SortMode.nameAsc:
        list.sort((a, b) => a.stopname.toLowerCase().compareTo(b.stopname.toLowerCase()));
        break;
      case SortMode.nameDesc:
        list.sort((a, b) => b.stopname.toLowerCase().compareTo(a.stopname.toLowerCase()));
        break;
      case SortMode.distanceAsc:
      // Future: requires location; keep order for now
        break;
    }
    return list;
  }
}

enum SortMode { nameAsc, nameDesc, distanceAsc }
