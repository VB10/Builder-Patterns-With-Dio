import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../product/network_manager.dart';

class JsonPlaceView extends StatefulWidget {
  const JsonPlaceView({Key? key}) : super(key: key);

  @override
  _JsonPlaceViewState createState() => _JsonPlaceViewState();
}

class _JsonPlaceViewState extends State<JsonPlaceView> {
  late final Dio networkManager;
  final _baseUrl = 'https://jsonplaceholder.typicode.com';

  String? body;
  @override
  void initState() {
    super.initState();
    networkManager = NetworkDioManager()
        .addBaseUrl(_baseUrl)
        .addBaseHeader(const MapEntry(HttpHeaders.authorizationHeader, '123'))
        .addLoggerRequest()
        .addTimeout(2000)
        .addStatusModels(StatusModels(minumumValue: HttpStatus.ok, maximumValue: HttpStatus.found))
        .build();

    callUsers();
  }

  Future<void> callUsers() async {
    final response = await networkManager.get('/users');

    body = jsonEncode(response.data);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text(body ?? ''),
    );
  }
}
