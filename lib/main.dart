import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'package:intl/date_symbol_data_local.dart';
void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Geolocator.requestPermission();
  await initializeDateFormatting('id_ID', null);
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: Routes.SPLASH_PAGE,
      getPages: AppPages.routes,
    ),
  );
}
