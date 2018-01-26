import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../components/speakers/speaker_component.dart';
import '../components/schedule/session_component.dart';

var speakerHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return new SpeakerPage(id: params['id']);
});

var sessionHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return new SessionPage(id: params['id']);
});
