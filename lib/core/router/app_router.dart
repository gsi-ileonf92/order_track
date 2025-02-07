import 'package:go_router/go_router.dart';
import 'package:order_track/features/allocator/domain/entities/order.dart';
import 'package:order_track/features/allocator/presentation/pages/home_allocator_page.dart';
import 'package:order_track/features/allocator/presentation/pages/order_details_allocator_page.dart';
import 'package:order_track/features/auth/presentation/pages/login_page.dart';
import 'package:order_track/features/client/presentation/pages/client_home_page.dart';
import 'package:order_track/features/client/presentation/pages/client_order_details_page.dart';
import 'package:order_track/features/client/presentation/pages/qr_scanner_page.dart';
import 'package:order_track/features/distributor/presentation/pages/distributor_home_page.dart';
import 'package:order_track/features/distributor/presentation/pages/distributor_order_details_page.dart';

class AppRoutes {
  //* Auth Routes
  static const String login = '/';

  //* Client Routes
  static const String clientHome = '/clientHome';
  static const String clientOrderDetails = '/clientOrderDetails/$id';
  static const String clientQrScan = '/clientQr';

  //* Allocator Routes
  static const String allocatorHome = '/allocatorHome';
  static const String id = ':id';
  static const String allocatorOrder = '/allocatorOrder/$id';

  //* Distributor Routes
  static const String distributorHome = '/distributorHome';
  static const String distributorOrder = '/distributorOrder/$id';
}

final GoRouter router = GoRouter(
  routes: [
    //* Auth Routes
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => LoginPage(),
    ),

    //* Allocator Routes
    GoRoute(
      path: AppRoutes.allocatorHome,
      builder: (context, state) => AllocatorHomePage(),
    ),
    GoRoute(
      path: AppRoutes.allocatorOrder,
      builder: (context, state) {
        final order = state.extra as Order;
        return OrderDetailsPage(order: order);
      },
    ),

    //* Client Routes
    GoRoute(
      path: AppRoutes.clientHome,
      builder: (context, state) => ClientHomePage(),
    ),
    GoRoute(
      path: AppRoutes.clientOrderDetails,
      builder: (context, state) {
        final order = state.extra as Order;
        return ClientOrderDetailsPage(order: order);
      },
    ),
    GoRoute(
      path: AppRoutes.clientQrScan,
      builder: (context, state) {
        // final order = state.extra as Order;
        return QRScannerPage(/* order: order */);
      },
    ),

    //* Distributor Routes
    GoRoute(
      path: AppRoutes.distributorHome,
      builder: (context, state) => DistributorHomePage(),
    ),
    GoRoute(
      path: AppRoutes.distributorOrder,
      builder: (context, state) {
        final order = state.extra as Order;
        return DistributorOrderDetailsPage(order: order);
      },
    ),
  ],
);
