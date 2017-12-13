import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../components/speakers/speaker_component.dart';

var demoRouteHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return new Text("lol");
});

var speakerHandler = new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return new SpeakerPage();
});
