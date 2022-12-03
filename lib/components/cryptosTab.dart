





//   import 'package:flutter/material.dart';
// import 'package:paperticker/services/backend/api.dart';
// import 'package:paperticker/utils/constants.dart';


//   final marketColumnProps = [.32, .35, .28];
//   List filteredMarketData;
//   Map globalData;

//   Future<Null> getGlobalData() async {
//     // var response = await http.get(
//     //     Uri.encodeFull("https://api.coinmarketcap.com/v1/global-metrics/quotes/latest"),
//     //     headers: {"Accept": "application/json"});

//     // globalData = new JsonDecoder().convert(response.body)["data"]["quotes"]["USD"];
//     globalData = null;
//   }

//   Future<Null> _refreshMarketPage() async {
//     await getMarketData();
//     await getGlobalData();
//     makePortfolioDisplay();
//     filterMarketData();
//     setState(() {});
//   }

//   filterMarketData() {
//     print("filtering market data");
//     filteredMarketData = marketListData;
//     if (filter != "" && filter != null) {
//       List tempFilteredMarketData = [];
//       filteredMarketData.forEach((item) {
//         if (item["CoinInfo"]["Name"]
//                 .toLowerCase()
//                 .contains(filter.toLowerCase()) ||
//             item["CoinInfo"]["FullName"]
//                 .toLowerCase()
//                 .contains(filter.toLowerCase())) {
//           tempFilteredMarketData.add(item);
//         }
//       });
//       filteredMarketData = tempFilteredMarketData;
//     }
//     _sortMarketData();
//   }

//   List marketSortType = ["MKTCAP", true];
//   _sortMarketData() {
//     if (filteredMarketData == [] || filteredMarketData == null) {
//       return;
//     }
//     // highest to lowest
//     if (marketSortType[1]) {
//       if (marketSortType[0] == "MKTCAP" ||
//           marketSortType[0] == "TOTALVOLUME24H" ||
//           marketSortType[0] == "CHANGEPCT24HOUR") {
//         print(filteredMarketData);
//         filteredMarketData.sort((a, b) =>
//             (b["RAW"]["USD"][marketSortType[0]] ?? 0)
//                 .compareTo(a["RAW"]["USD"][marketSortType[0]] ?? 0));
//         if (marketSortType[0] == "MKTCAP") {
//           print("adding ranks to filteredMarketData");
//           int i = 1;
//           for (Map coin in filteredMarketData) {
//             coin["rank"] = i;
//             i++;
//           }
//         }
//       } else {
//         // Handle sorting by name
//         filteredMarketData.sort((a, b) =>
//             (b["CoinInfo"][marketSortType[0]] ?? 0)
//                 .compareTo(a["CoinInfo"][marketSortType[0]] ?? 0));
//       }
//       // lowest to highest
//     } else {
//       if (marketSortType[0] == "MKTCAP" ||
//           marketSortType[0] == "TOTALVOLUME24H" ||
//           marketSortType[0] == "CHANGEPCT24HOUR") {
//         filteredMarketData.sort((a, b) =>
//             (a["RAW"]["USD"][marketSortType[0]] ?? 0)
//                 .compareTo(b["RAW"]["USD"][marketSortType[0]] ?? 0));
//       } else {
//         filteredMarketData.sort((a, b) =>
//             (a["CoinInfo"][marketSortType[0]] ?? 0)
//                 .compareTo(b["CoinInfo"][marketSortType[0]] ?? 0));
//       }
//     }
//   }

//     makePortfolioDisplay() {
//     print("making portfolio display");
//     Map portfolioTotals = {};
//     List neededPriceSymbols = [];

//     portfolioMap.forEach((coin, transactions) {
//       num quantityTotal = 0;
//       transactions.forEach((value) {
//         quantityTotal += value["quantity"];
//       });
//       portfolioTotals[coin] = quantityTotal;
//       neededPriceSymbols.add(coin);
//     });

//     portfolioDisplay = [];
//     num totalPortfolioValue = 0;
//     marketListData.forEach((coin) {
//       String symbol = coin["CoinInfo"]["Name"];
//       if (neededPriceSymbols.contains(symbol) && portfolioTotals[symbol] != 0) {
//         portfolioDisplay.add({
//           "symbol": symbol,
//           "price_usd": coin["RAW"]["USD"]["PRICE"],
//           "percent_change_24h": coin["RAW"]["USD"]["CHANGEPCT24HOUR"],
//           "percent_change_1h": coin["RAW"]["USD"]["CHANGEPCTHOUR"],
//           "total_quantity": portfolioTotals[symbol],
//           "id": coin["CoinInfo"]["Id"],
//           "name": coin["CoinInfo"]["FullName"],
//           "CoinInfo": coin["CoinInfo"]
//         });
//         totalPortfolioValue +=
//             (portfolioTotals[symbol] * coin["RAW"]["USD"]["PRICE"]);
//       }
//     });

//     num total24hChange = 0;
//     num total1hChange = 0;
//     portfolioDisplay.forEach((coin) {
//       total24hChange += (coin["percent_change_24h"] *
//           ((coin["price_usd"] * coin["total_quantity"]) / totalPortfolioValue));
//       total1hChange += (coin["percent_change_1h"] *
//           ((coin["price_usd"] * coin["total_quantity"]) / totalPortfolioValue));
//     });

//     totalPortfolioStats = {
//       "value_usd": totalPortfolioValue,
//       "percent_change_24h": total24hChange,
//       "percent_change_1h": total1hChange
//     };

//     _sortPortfolioDisplay();
//   }

// Widget marketPage(BuildContext context) {
//     return filteredMarketData != null
//         ? new RefreshIndicator(
//             key: _marketKey,
//             onRefresh: () => _refreshMarketPage(),
//             child: new CustomScrollView(
//               slivers: <Widget>[
//                 new SliverList(
//                     delegate: new SliverChildListDelegate(<Widget>[
//                   globalData != null && isSearching != true
//                       ? new Container(
//                           padding: const EdgeInsets.all(10.0),
//                           child: new Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               new Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   new Text("Total Market Cap",
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodyText2
//                                           .apply(
//                                               color:
//                                                   Theme.of(context).hintColor)),
//                                   new Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 1.0)),
//                                   new Text("Total 24h Volume",
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodyText2
//                                           .apply(
//                                               color:
//                                                   Theme.of(context).hintColor)),
//                                 ],
//                               ),
//                               new Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 1.0)),
//                               new Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   new Text(
//                                       "\$" +
//                                           normalizeNum(
//                                               globalData["total_market_cap"]),
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodyText2
//                                           .apply(
//                                               fontSizeFactor: 1.2,
//                                               fontWeightDelta: 2)),
//                                   new Text(
//                                       "\$" +
//                                           normalizeNum(
//                                               globalData["total_volume_24h"]),
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodyText2
//                                           .apply(
//                                               fontSizeFactor: 1.2,
//                                               fontWeightDelta: 2)),
//                                 ],
//                               )
//                             ],
//                           ))
//                       : new Container(),
//                   new Container(
//                     margin: const EdgeInsets.only(left: 6.0, right: 6.0),
//                     decoration: new BoxDecoration(
//                         border: new Border(
//                             bottom: new BorderSide(
//                                 color: Theme.of(context).dividerColor,
//                                 width: 1.0))),
//                     child: new Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         new InkWell(
//                           onTap: () {
//                             if (marketSortType[0] == "Name") {
//                               marketSortType[1] = !marketSortType[1];
//                             } else {
//                               marketSortType = ["Name", false];
//                             }
//                             setState(() {
//                               _sortMarketData();
//                             });
//                           },
//                           child: new Container(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             width: MediaQuery.of(context).size.width *
//                                 marketColumnProps[0],
//                             child: marketSortType[0] == "Name"
//                                 ? new Text(
//                                     marketSortType[1]
//                                         ? "Currency " + upArrow
//                                         : "Currency " + downArrow,
//                                     style:
//                                         Theme.of(context).textTheme.bodyText2)
//                                 : new Text("Currency",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyText2
//                                         .apply(
//                                             color:
//                                                 Theme.of(context).hintColor)),
//                           ),
//                         ),
//                         new Container(
//                           width: MediaQuery.of(context).size.width *
//                               marketColumnProps[1],
//                           child: new Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: <Widget>[
//                               new InkWell(
//                                   onTap: () {
//                                     if (marketSortType[0] == "MKTCAP") {
//                                       marketSortType[1] = !marketSortType[1];
//                                     } else {
//                                       marketSortType = ["MKTCAP", true];
//                                     }
//                                     setState(() {
//                                       _sortMarketData();
//                                     });
//                                   },
//                                   child: new Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 8.0),
//                                     child: marketSortType[0] == "MKTCAP"
//                                         ? new Text(
//                                             marketSortType[1]
//                                                 ? "Market Cap " + downArrow
//                                                 : "Market Cap " + upArrow,
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodyText2)
//                                         : new Text("Market Cap",
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodyText2
//                                                 .apply(
//                                                     color: Theme.of(context)
//                                                         .hintColor)),
//                                   )),
//                               new Text("/",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyText2
//                                       .apply(
//                                           color: Theme.of(context).hintColor)),
//                               new InkWell(
//                                 onTap: () {
//                                   if (marketSortType[0] == "TOTALVOLUME24H") {
//                                     marketSortType[1] = !marketSortType[1];
//                                   } else {
//                                     marketSortType = ["TOTALVOLUME24H", true];
//                                   }
//                                   setState(() {
//                                     _sortMarketData();
//                                   });
//                                 },
//                                 child: new Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 8.0),
//                                   child: marketSortType[0] == "TOTALVOLUME24H"
//                                       ? new Text(
//                                           marketSortType[1]
//                                               ? "24h " + downArrow
//                                               : "24h " + upArrow,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodyText2)
//                                       : new Text("24h",
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodyText2
//                                               .apply(
//                                                   color: Theme.of(context)
//                                                       .hintColor)),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         new InkWell(
//                           onTap: () {
//                             if (marketSortType[0] == "CHANGEPCT24HOUR") {
//                               marketSortType[1] = !marketSortType[1];
//                             } else {
//                               marketSortType = ["CHANGEPCT24HOUR", true];
//                             }
//                             setState(() {
//                               _sortMarketData();
//                             });
//                           },
//                           child: new Container(
//                             alignment: Alignment.centerRight,
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             width: MediaQuery.of(context).size.width *
//                                 marketColumnProps[2],
//                             child: marketSortType[0] == "CHANGEPCT24HOUR"
//                                 ? new Text(
//                                     marketSortType[1] == true
//                                         ? "Price/24h " + downArrow
//                                         : "Price/24h " + upArrow,
//                                     style:
//                                         Theme.of(context).textTheme.bodyText2)
//                                 : new Text("Price/24h",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyText2
//                                         .apply(
//                                             color:
//                                                 Theme.of(context).hintColor)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ])),
//                 filteredMarketData.isEmpty
//                     ? new SliverList(
//                         delegate: new SliverChildListDelegate(<Widget>[
//                         new Container(
//                           padding: const EdgeInsets.all(30.0),
//                           alignment: Alignment.topCenter,
//                           child: new Text("No results found",
//                               style: Theme.of(context).textTheme.caption),
//                         )
//                       ]))
//                     : new SliverList(
//                         delegate: new SliverChildBuilderDelegate(
//                             (BuildContext context, int index) =>
//                                 new CoinListItem(filteredMarketData[index],
//                                     marketColumnProps),
//                             childCount: filteredMarketData == null
//                                 ? 0
//                                 : filteredMarketData.length))
//               ],
//             ))
//         : new Container(
//             child: new Center(child: new CircularProgressIndicator()),
//           );
//   }