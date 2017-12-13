import 'package:fluro/fluro.dart';

import './route_handlers.dart';

class Routes {
  static String demoSimple = "/demo";
  static String speakerRoute = "/speakers/:id";

  static void configureRoutes(Router router) {
    router.define(demoSimple, handler: demoRouteHandler);
    router.define(speakerRoute, handler: speakerHandler);
  }
}
