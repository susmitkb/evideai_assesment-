import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamevideai/models/busStop_models.dart';

class FavoritesController extends GetxController {
  var favoriteStopIds = <String>[].obs; // Changed to store IDs instead of names

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favorites = prefs.getStringList('favoriteStopIds');
    if (favorites != null) {
      favoriteStopIds.assignAll(favorites);
    }
  }

  Future<void> toggleFavorite(String stopId) async {
    final prefs = await SharedPreferences.getInstance();
    if (favoriteStopIds.contains(stopId)) {
      favoriteStopIds.remove(stopId);
    } else {
      favoriteStopIds.add(stopId);
    }
    await prefs.setStringList('favoriteStopIds', favoriteStopIds);
  }

  bool isFavorite(String stopId) {
    return favoriteStopIds.contains(stopId);
  }

  // Helper method to get favorite status by BusStop object
  bool isFavoriteStop(BusStop stop) {
    return isFavorite(stop.id);
  }

  // Helper method to toggle favorite by BusStop object
  Future<void> toggleFavoriteStop(BusStop stop) async {
    await toggleFavorite(stop.id);
  }
}