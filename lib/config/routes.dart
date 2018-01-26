import 'package:fluro/fluro.dart';

import './route_handlers.dart';

class Routes {
  static String speakerRoute = "/speakers/:id";
  static String sessionRoute = "/sessions/:id";

  static void configureRoutes(Router router) {
    router.define(speakerRoute, handler: speakerHandler);
    router.define(sessionRoute, handler: sessionHandler);
  }
}
