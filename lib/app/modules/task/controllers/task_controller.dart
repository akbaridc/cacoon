import 'dart:convert';

import 'package:cacoon_mobile/app/data/boat_model.dart';
import 'package:cacoon_mobile/constants/api_endpoint.dart';
import 'package:cacoon_mobile/helpers/session_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TaskController extends GetxController {
 var boats = <Boat>[].obs;
  var currentPage = 1;
  var lastPage = 1;
  var isLoadingMore = false.obs;
  final searchQuery = ''.obs;
  var name = ''.obs;

  final scrollController = ScrollController();

  @override
  void onInit() async{
    super.onInit();
    fetchBoat();
    name.value = await SessionHelper.getName();
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
    String url = '${ApiEndpoint.baseUrl}${ApiEndpoint.vessel}?page=$page&limit=25&type=Loading';
    if (searchQuery.isNotEmpty) {
      url += '&search=$searchQuery'; // Sesuaikan dengan parameter di backend-mu
    }
    String token = await SessionHelper.getAccessToken();

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      var dataList = jsonResult["data"]; 
      currentPage = jsonResult["meta"]["page"]; 
      lastPage = jsonResult["meta"]["last_page"]; 

      List<Boat> fetchedBoats = dataList.map<Boat>((item) => Boat.fromJson(item)).toList();

      if (page == 1) {
        boats.value = fetchedBoats;
      } else {
        boats.addAll(fetchedBoats);
      }
    } else {
      print("Failed to load data: ${response.statusCode}");
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

  void setKeyword(String keyword) {
    searchQuery.value = keyword;
    currentPage = 1;
    boats.clear();
    fetchBoat();
  }
}
