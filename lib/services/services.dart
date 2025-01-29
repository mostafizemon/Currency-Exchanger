import 'dart:convert';
import 'package:currency_exchange/app/constant.dart';
import 'package:currency_exchange/model/currency_model.dart';
import 'package:http/http.dart' as http;

class Services {
  Future<List<CurrencyModel>> getLatest(String baseCurrency) async {
    List<CurrencyModel> currencyModelList = [];

    String url = '${Constant.baseUrl}&base_currency=$baseCurrency';

    try {
      final response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        Map<String, dynamic> body = json['data'];

        body.forEach((key, value) {
          CurrencyModel currencyModel = CurrencyModel.fromJson(value);
          currencyModelList.add(currencyModel);
        });
        return currencyModelList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<CurrencyModel>> getExchange(String baseCurrency,String targetCurrency) async {
    List<CurrencyModel> currencyModelList = [];

    String url = '${Constant.baseUrl}&base_currency=$baseCurrency&currencies=$targetCurrency';

    try {
      final response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        Map<String, dynamic> body = json['data'];

        body.forEach((key, value) {
          CurrencyModel currencyModel = CurrencyModel.fromJson(value);
          currencyModelList.add(currencyModel);
        });
        return currencyModelList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
