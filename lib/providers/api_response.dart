import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mobile/config/app.dart';

class ApiResponse {
  static Status status = Status.LOADING;
  static String message = "";

  static handleApiResponse(http.Response response) {
    var logger = Logger();
    logger.wtf(response.headers);
    logger.wtf(response.body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      ApiResponse.status = Status.ERROR;

      if (statusCode == 401 &&
          !response.request!.url.toString().contains('login')) {
        App.logout();
      } else {
        final data = jsonDecode(response.body);

        if (data['message'] != null) {
          ApiResponse.message = data['message'];
        }

        if (ApiResponse.message.isEmpty) {
          ApiResponse.message = "Error while fetching data";
        }
        return;
      }
    }

    ApiResponse.status = Status.COMPLETED;
    return json.decode(response.body);
  }

  static void showLoader(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.05,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Text(message),
                ],
              ),
            ),
          );
        });
  }
}

enum Status { LOADING, COMPLETED, ERROR }
