import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesController extends GetxController {
  var favoriteStops = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favorites = prefs.getStringList('favoriteStops');
    if (favorites != null) {
      favoriteStops.assignAll(favorites);
    }
  }

  Future<void> toggleFavorite(String stopName) async {
    final prefs = await SharedPreferences.getInstance();
    if (favoriteStops.contains(stopName)) {
      favoriteStops.remove(stopName);
    } else {
      favoriteStops.add(stopName);
    }
    await prefs.setStringList('favoriteStops', favoriteStops);
  }

  bool isFavorite(String stopName) {
    return favoriteStops.contains(stopName);
  }
}