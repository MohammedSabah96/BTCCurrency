import 'package:http/http.dart' as http;
import 'dart:convert';

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

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
String coin = 'USD';
const requestUrl = 'https://apiv2.bitcoinaverage.com/indices/global/ticker';

class CoinData {
  Future<Map<String, String>> getDataCoin(String slectedCurrency) async {
    Map<String, String> coinsValue = {};
    for (String crypto in cryptoList) {
      String url = '$requestUrl/$crypto$slectedCurrency';
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        var getData = json.decode(response.body);
        double lastPrice = getData['last'];
        coinsValue[crypto] = lastPrice.toString();
      } else {
        print(response.statusCode);
        throw ('something went wrong');
      }
    }
    return coinsValue;
  }
}
