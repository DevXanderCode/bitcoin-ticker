import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = 'A14B31C8-54F9-48D7-9007-91F437DADD86';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  "NGN",
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = ['BTC', 'ETH', 'LTC', 'BNB'];
Map<String, double> dataMap = {for (String coin in cryptoList) coin: 0.0};

class CoinData {
  Future<Map> getCoinData(String selectedCurrency) async {
    for (String k in cryptoList) {
      Uri uri = Uri.parse('$baseURL/$k/$selectedCurrency?apikey=$apiKey');
      print(uri);
      http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        String data = response.body;
        dataMap[k] = jsonDecode(data)['rate'];
        // return jsonDecode(data)['rate'];
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    // throw ('still testing');
    print(dataMap);
    return dataMap;
  }

  Future getData({String selectedCurrency = 'NGN', String coin = 'BTC'}) async {
    Uri uri = Uri.parse('$baseURL/$coin/$selectedCurrency?apikey=$apiKey');
    // print(uri);
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data)['rate'];
    } else {
      print(response.statusCode);
      throw 'Problem with the get request';
    }
  }
}
