import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:paperticker/utils/constants.dart';
import 'package:path_provider/path_provider.dart';

Future<Null> getMarketData() async {
  int pages = 5;
  List tempMarketListData = [];

  Future<Null> _pullData(page) async {
    var response = await http.get(
        Uri.parse(
            "https://min-api.cryptocompare.com/data/top/mktcapfull?tsym=USD&limit=100" +
                "&page=" +
                page.toString() +
                '&api_key=17ace7f16147ad775b5e54eb96b3e33597bba5cde726ad512d0b6717ad859978'),
        headers: {"Accept": "application/json"});

    List rawMarketListData = new JsonDecoder().convert(response.body)["Data"];
    tempMarketListData.addAll(rawMarketListData);
  }

  List<Future> futures = [];
  for (int i = 0; i < pages; i++) {
    futures.add(_pullData(i));
  }
  await Future.wait(futures);

  marketListData = [];
  // Filter out lack of financial data
  for (Map coin in tempMarketListData) {
    if (coin.containsKey("RAW") && coin.containsKey("CoinInfo")) {
      marketListData.add(coin);
    }
  }

  getApplicationDocumentsDirectory().then((Directory directory) async {
    File jsonFile = new File(directory.path + "/marketData.json");
    jsonFile.writeAsStringSync(json.encode(marketListData));
  });
  print("Got new market data.");

  lastUpdate = DateTime.now().millisecondsSinceEpoch;
}
