import 'dart:async';
import 'dart:convert';

import 'package:cacoon_mobile/app/data/boat_model.dart';
import 'package:cacoon_mobile/app/services/error_logging_service.dart';
import 'package:cacoon_mobile/constants/api_endpoint.dart';
import 'package:cacoon_mobile/helpers/session_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TaskController extends GetxController {
  // Error logging service
  final ErrorLoggingService _errorLoggingService = ErrorLoggingService();
  
  var boats = <Boat>[].obs;
  var currentPage = 1;
  var lastPage = 1;
  var isLoadingMore = false.obs;
  final searchQuery = ''.obs;
  var name = ''.obs;

  final scrollController = ScrollController();
  Timer? _debounceTimer;

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
      // Log server error
      await _errorLoggingService.logError(
        errorType: ErrorLoggingService.SERVER_ERROR,
        errorMessage: 'Failed to load task boat data with status ${response.statusCode}',
        feature: 'task_boat_fetch',
        additionalData: {
          'statusCode': response.statusCode,
          'page': page,
          'searchQuery': searchQuery.value,
          'responseBody': response.body,
        },
        statusCode: response.statusCode,
      );
      
      print("Failed to load data: ${response.statusCode}");
    }
  } catch (e) {
    // Determine error type and log using ErrorLoggingService
    final errorType = _errorLoggingService.determineErrorType(e);
    
    await _errorLoggingService.logError(
      errorType: errorType,
      errorMessage: e.toString(),
      feature: 'task_boat_fetch',
      additionalData: {
        'page': page,
        'searchQuery': searchQuery.value,
      },
      stackTrace: StackTrace.current.toString(),
    );
    
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
    _debounceTimer?.cancel();
    super.onClose();
  }

  void setKeyword(String keyword) {
    searchQuery.value = keyword;
    
    // Cancel previous timer if it exists
    _debounceTimer?.cancel();
    
    // Create new timer with 500ms delay
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      print("Searching for: $keyword");
      currentPage = 1;
      boats.clear();
      fetchBoat();
    });
  }
}
