import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:quote_flip/model/quote_model.dart';
import 'package:quote_flip/utils/logger_helper.dart';

class QuoteService {
  static Future<QuoteModel> getQuotes(final String url) async {
    try {
      LoggerHelper.log(url);

      http.Response response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));

      final Map<String, dynamic> result = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return QuoteModel.fromJson(result);
      } else {
        throw result['message'];
      }
    } on FormatException catch (e, s) {
      LoggerHelper.log(e, s);

      if (kDebugMode) {
        throw 'Unable To Format Data!';
      }

      throw 'Something went wrong, please try again';
    } on SocketException catch (e, s) {
      LoggerHelper.log(e, s);

      throw 'Unable to connect to server please check your network and try again!';
    } on TimeoutException catch (e, s) {
      LoggerHelper.log(e, s);

      throw 'Request Timeout, Unable to connect to server please check your network and try again!';
    } catch (e) {
      throw e.toString();
    }
  }
}
