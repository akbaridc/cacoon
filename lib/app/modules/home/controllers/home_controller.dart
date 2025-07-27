import 'dart:convert';
import 'package:cacoon_mobile/app/data/vessel_post_model.dart';
import 'package:cacoon_mobile/constants/api_endpoint.dart';
import 'package:cacoon_mobile/helpers/session_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final stories = [
    {'name': 'Your Story', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Ethan', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Olivia', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Noah', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Emma', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Liam', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Sophia', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Mason', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Ava', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Lucas', 'profileImage': 'https://placehold.co/100x100'},
  ];

  var vesselPostData = <VesselPost>[].obs;
  var currentPage = 1;
  var lastPage = 1;
  var isLoadingMore = false.obs;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchData();
    print("Fetching data for the first time");
    scrollController.addListener(_scrollListener);
  }

  Future<void> refreshBoat() async {
    currentPage = 1;
    vesselPostData.clear();
    await fetchData();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore.value && currentPage < lastPage) {
        loadMore();
      }
    }
  }

Future<void> fetchData({int page = 1}) async {
  try {
    var url = '${ApiEndpoint.baseUrl}${ApiEndpoint.postVessel}?page=$page';
    String token = await SessionHelper.getAccessToken();

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final jsonResult = json.decode(response.body);

      // ✅ Validasi bahwa "data" adalah List
      if (jsonResult is! Map || jsonResult['data'] is! List) {
        return;
      }

      // ✅ Ambil pagination dari "meta"
      final meta = jsonResult['meta'];
      currentPage = meta['page'] ?? 1;
      lastPage = meta['last_page'] ?? 1;

      final List<dynamic> dataList = jsonResult['data'];

      List<VesselPost> fetchVesselPost = dataList
          .map<VesselPost>((item) => VesselPost.fromJson(item))
          .toList();

      if (page == 1) {
        vesselPostData.value = fetchVesselPost;
      } else {
        vesselPostData.addAll(fetchVesselPost);
      }
    } else if (response.statusCode == 401) {
      Get.snackbar('Unauthorized', 'Please login again');
      SessionHelper.clearSession();
      Get.offAllNamed('/login');
    } else {
      print("Failed to fetch data. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print('Error during fetchData: $e');
  }
}

  Future<void> loadMore() async {
    if (currentPage < lastPage) {
      isLoadingMore.value = true;
      await fetchData(page: currentPage + 1);
      isLoadingMore.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
