import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

var demoRouteHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return new Text("lol");
});

