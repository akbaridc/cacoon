import 'package:get/get.dart';

import '../modules/create/bindings/create_binding.dart';
import '../modules/create/views/create_view.dart';
import '../modules/detail_task/bindings/detail_task_binding.dart';
import '../modules/detail_task/views/detail_task_view.dart';
import '../modules/detail_vessel/bindings/detail_vessel_binding.dart';
import '../modules/detail_vessel/views/detail_vessel_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/navigation_bar/bindings/navigation_bar_binding.dart';
import '../modules/navigation_bar/views/navigation_bar_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/search_boat/bindings/search_boat_binding.dart';
import '../modules/search_boat/views/search_boat_view.dart';
import '../modules/splash_page/bindings/splash_page_binding.dart';
import '../modules/splash_page/views/splash_page_view.dart';
import '../modules/task/bindings/task_binding.dart';
import '../modules/task/views/task_view.dart';
import '../modules/verify_otp/bindings/verify_otp_binding.dart';
import '../modules/verify_otp/views/verify_otp_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_PAGE,
      page: () => const SplashPageView(),
      binding: SplashPageBinding(),
    ),
    GetPage(
      name: _Paths.CREATE,
      page: () => const CreateView(),
      binding: CreateBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_BOAT,
      page: () => const SearchBoatView(),
      binding: SearchBoatBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION_BAR,
      page: () => MainNavigationBarView(),
      binding: NavigationBarBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_OTP,
      page: () => const VerifyOtpView(),
      binding: VerifyOtpBinding(),
    ),
    GetPage(
      name: _Paths.TASK,
      page: () => const TaskView(),
      binding: TaskBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_TASK,
      page: () => const DetailTaskView(),
      binding: DetailTaskBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_VESSEL,
      page: () => const DetailVesselView(),
      binding: DetailVesselBinding(),
    ),
  ];
}
