import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamevideai/controllers/busStop_controllers.dart';

class SearchBarWidget extends StatelessWidget {
  final BusStopController busStopController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search bus stops...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onChanged: (value) {
          busStopController.filterStops(value);
        },
      ),
    );
  }
}