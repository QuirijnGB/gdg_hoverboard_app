import 'package:fluro/fluro.dart';

import './route_handlers.dart';

class Routes {
  static String demoSimple = "/demo";

  static void configureRoutes(Router router) {
    router.define(demoSimple, handler: demoRouteHandler);
  }
}
