import 'dart:convert';

import 'package:cacoon_mobile/app/data/boat_model.dart';
import 'package:get/get.dart';
import 'package:cacoon_mobile/constants/api_endpoint.dart';
import 'package:cacoon_mobile/helpers/session_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchBoatController extends GetxController {
  var boats = <Boat>[].obs;
  var currentPage = 1;
  var lastPage = 1;
  var isLoadingMore = false.obs;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchBoat();
    scrollController.addListener(_scrollListener);
  }

  Future<void> refreshBoat() async {
    currentPage = 1;
    boats.clear();
    await fetchBoat();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore.value && currentPage < lastPage) {
        loadMore();
      }
    }
  }

  Future<void> fetchBoat({int page = 1}) async {
    try {
      var url = '${ApiEndpoint.baseUrl}${ApiEndpoint.boat}?page=$page';
      String token = await SessionHelper.getAccessToken();

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        var data = jsonResult["data"];
        var dataList = data["data"];
        currentPage = data["current_page"];
        lastPage = data["last_page"];

        List<Boat> fetchedBoats = dataList.map<Boat>((item) => Boat.fromJson(item)).toList();

        if (page == 1) {
          boats.value = fetchedBoats;
        } else {
          boats.addAll(fetchedBoats);
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> loadMore() async {
    if (currentPage < lastPage) {
      isLoadingMore.value = true;
      await fetchBoat(page: currentPage + 1);
      isLoadingMore.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
