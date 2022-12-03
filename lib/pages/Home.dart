import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:paperticker/pages/addTransaction.dart';
import 'package:paperticker/pages/settings_page.dart';
import 'package:paperticker/services/backend/api.dart';
import 'package:paperticker/services/functions/globalFunctions.dart';
import 'package:paperticker/services/models/tabProvider.dart';
import 'package:paperticker/utils/colors.dart';
import 'package:paperticker/utils/constants.dart';
import 'package:provider/provider.dart';

// import '../portfolio/portfolio_Home.dart';
import '../main.dart';
import '../components/portfolio_item.dart';
import '../portfolio/transaction_sheet.dart';
import '../components/market_coin_item.dart';

class Home extends StatefulWidget {
  Home(
      {this.toggleTheme,
      this.savePreferences,
      this.handleUpdate,
      this.darkEnabled,
      this.themeMode,
      this.switchOLED,
      this.darkOLED});

  final Function toggleTheme;
  final Function handleUpdate;
  final Function savePreferences;

  final bool darkEnabled;
  final String themeMode;

  final Function switchOLED;
  final bool darkOLED;

  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TextEditingController _textController = new TextEditingController();
  bool isSearching = false;
  String filter;

  bool sheetOpen = false;

  _handleFilter(value) {
    if (value == null) {
      isSearching = false;
      filter = null;
    } else {
      filter = value;
      isSearching = true;
    }
    _filterMarketData();
    setState(() {});
  }

  _startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  _stopSearch() {
    setState(() {
      isSearching = false;
      filter = null;
      _textController.clear();
      _filterMarketData();
    });
  }

  _handleTabChange() {
    // _tabIndex = _tabController.animation.value.round();
    if (isSearching) {
      _stopSearch();
    } else {
      setState(() {});
    }
  }

  _openTransaction() {
    // setState(() {
    //   sheetOpen = true;
    // });

    // _scaffoldKey.currentState
    //     .showBottomSheet((BuildContext context) {
    //       return new TransactionSheet(
    //         () {
    //           setState(() {
    //             _makePortfolioDisplay();
    //           });
    //         },
    //         marketListData,
    //       );
    //     })
    //     .closed
    //     .whenComplete(() {
    //       setState(() {
    //         sheetOpen = false;
    //       });
    //     });
  }

  _makePortfolioDisplay() {
    print("making portfolio display");
    Map portfolioTotals = {};
    List neededPriceSymbols = [];

    portfolioMap.forEach((coin, transactions) {
      num quantityTotal = 0;
      transactions.forEach((value) {
        quantityTotal += value["quantity"];
      });
      portfolioTotals[coin] = quantityTotal;
      neededPriceSymbols.add(coin);
    });

    portfolioDisplay = [];
    num totalPortfolioValue = 0;
    marketListData.forEach((coin) {
      String symbol = coin["CoinInfo"]["Name"];
      if (neededPriceSymbols.contains(symbol) && portfolioTotals[symbol] != 0) {
        portfolioDisplay.add({
          "symbol": symbol,
          "price_usd": coin["RAW"]["USD"]["PRICE"],
          "percent_change_24h": coin["RAW"]["USD"]["CHANGEPCT24HOUR"],
          "percent_change_1h": coin["RAW"]["USD"]["CHANGEPCTHOUR"],
          "total_quantity": portfolioTotals[symbol],
          "id": coin["CoinInfo"]["Id"],
          "name": coin["CoinInfo"]["FullName"],
          "CoinInfo": coin["CoinInfo"]
        });
        totalPortfolioValue +=
            (portfolioTotals[symbol] * coin["RAW"]["USD"]["PRICE"]);
      }
    });

    num total24hChange = 0;
    num total1hChange = 0;
    portfolioDisplay.forEach((coin) {
      total24hChange += (coin["percent_change_24h"] *
          ((coin["price_usd"] * coin["total_quantity"]) / totalPortfolioValue));
      total1hChange += (coin["percent_change_1h"] *
          ((coin["price_usd"] * coin["total_quantity"]) / totalPortfolioValue));
    });

    totalPortfolioStats = {
      "value_usd": totalPortfolioValue,
      "percent_change_24h": total24hChange,
      "percent_change_1h": total1hChange
    };

    _sortPortfolioDisplay();
  }

  @override
  void initState() {
    super.initState();
    // _tabController = new TabController(length: 2, vsync: this);
    // _tabController.animation.addListener(() {
    //   if (_tabController.animation.value.round() != _tabIndex) {
    //     _handleTabChange();
    //   }
    // });

    _makePortfolioDisplay();
    _filterMarketData();
    _refreshMarketPage();
  }

  @override
  void dispose() {
    // _tabController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List _tabs = [
      marketPage(context),
      portfolioPage(context),
      SettingsPage(
        savePreferences: widget.savePreferences,
        toggleTheme: widget.toggleTheme,
        darkEnabled: widget.darkEnabled,
        themeMode: widget.themeMode,
        switchOLED: widget.switchOLED,
        darkOLED: widget.darkOLED,
      )
    ];
    return Consumer<TabProvider>(
      builder: (context, model, child) => new Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(model.selectedIndex == 0
              ? 'Cryptos'
              : model.selectedIndex == 1
                  ? 'My Wallet'
                  : 'Manage'),
        ),
        // endDrawer: new Drawer(
        //     child: new Scaffold(
        //         bottomNavigationBar: new Container(
        //             decoration: new BoxDecoration(
        //                 border: new Border(
        //               top: new BorderSide(
        //                   color: Theme.of(context).bottomAppBarColor),
        //             )),
        //             child: new ListTile(
        //               onTap: widget.toggleTheme,
        //               leading: new Icon(
        //                   widget.darkEnabled
        //                       ? Icons.brightness_3
        //                       : Icons.brightness_7,
        //                   color: Theme.of(context).buttonColor),
        //               title: new Text(widget.themeMode,
        //                   style: Theme.of(context)
        //                       .textTheme
        //                       .bodyText2
        //                       .apply(color: Theme.of(context).buttonColor)),
        //             )),
        //         body: new ListView(
        //           children: <Widget>[
        //             new ListTile(
        //               leading: new Icon(Icons.settings),
        //               title: new Text("Settings"),
        //               onTap: () => Navigator.pushNamed(context, "/settings"),
        //             ),
        //             new ListTile(
        //               leading: new Icon(Icons.timeline),
        //               title: new Text("Portfolio Timeline"),
        //               // onTap: () => Navigator.push(
        //               //     context,
        //               //     new MaterialPageRoute(
        //               //         builder: (context) =>
        //               //             new PortfolioHome(0, _makePortfolioDisplay))),
        //             ),
        //             new ListTile(
        //               leading: new Icon(Icons.pie_chart_outline),
        //               title: new Text("Portfolio Breakdown"),
        //               // onTap: () => Navigator.push(
        //               //     context,
        //               //     new MaterialPageRoute(
        //               //         builder: (context) =>
        //               //             new PortfolioHome(1, _makePortfolioDisplay))),
        //             ),
        //             new Container(
        //               decoration: new BoxDecoration(
        //                   border: new Border(
        //                       bottom: new BorderSide(
        //                           color: Theme.of(context).bottomAppBarColor,
        //                           width: 1.0))),
        //               padding: const EdgeInsets.symmetric(vertical: 4.0),
        //             ),
        //             new ListTile(
        //               leading: new Icon(Icons.short_text),
        //               title: new Text("Abbreviate Numbers"),
        //               trailing: new Switch(
        //                   activeColor: Theme.of(context).accentColor,
        //                   value: shortenOn,
        //                   onChanged: (onOff) {
        //                     setState(() {
        //                       shortenOn = onOff;
        //                     });
        //                     widget.savePreferences();
        //                   }),
        //               onTap: () {
        //                 setState(() {
        //                   shortenOn = !shortenOn;
        //                 });
        //                 widget.savePreferences();
        //               },
        //             ),
        //             new ListTile(
        //               leading: new Icon(Icons.opacity),
        //               title: new Text("OLED Dark Mode"),
        //               trailing: new Switch(
        //                 activeColor: Theme.of(context).accentColor,
        //                 value: widget.darkOLED,
        //                 onChanged: (onOff) {
        //                   widget.switchOLED(state: onOff);
        //                 },
        //               ),
        //               onTap: widget.switchOLED,
        //             ),
        //           ],
        //         ))),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: model.selectedIndex,
            onTap: (clickedIndex) async {
              model.changeIndex(clickedIndex);
            },
            selectedItemColor:
                widget.themeMode == "Light" ? AppColors.black : AppColors.white,
            unselectedItemColor: widget.themeMode == "Light"
                ? Colors.grey.shade500
                : Colors.grey.shade600,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            backgroundColor:
                Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.money,
                  ),
                  label: 'Cryptos'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.account_balance_wallet_outlined,
                  ),
                  label: 'Wallet'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.build_outlined,
                  ),
                  label: 'Manage'),
            ]),

        body: _tabs[model.selectedIndex],
        key: _scaffoldKey,

        floatingActionButton:
            model.selectedIndex == 1 ? _transactionFAB(context) : null,
      ),
    );
  }

  Widget _transactionFAB(BuildContext context) {
    return
        // sheetOpen
        //     ? new FloatingActionButton(
        //         onPressed: () => Navigator.of(context).pop(),
        //         child: Icon(Icons.close),
        //         foregroundColor: Theme.of(context).iconTheme.color,
        //         // backgroundColor: Theme.of(context).accentIconTheme.color,
        //         elevation: 4.0,
        //         tooltip: "Close Transaction",
        //       )
        //     :
        new FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddTransaction(
                      editMode: false,
                      loadPortfolio: () {
                        setState(() {
                          _makePortfolioDisplay();
                        });
                      },
                      marketListData: marketListData,
                    )));
      },
      icon: Icon(Icons.arrow_forward),
      label: new Text(
        "Add Transaction",
        style: TextStyle(letterSpacing: 0),
      ),
      foregroundColor: widget.themeMode == 'Dark' ? Colors.black : Colors.white,
      backgroundColor:
          widget.themeMode == 'Light' ? Colors.black : Colors.white,
      tooltip: "Add Transaction",
    );
  }

  final portfolioColumnProps = [.25, .35, .3];

  Future<Null> _refreshPortfolioPage() async {
    await getMarketData();
    getGlobalData();
    _makePortfolioDisplay();
    _filterMarketData();
    setState(() {});
  }

  List portfolioSortType = ["holdings", true];
  List sortedPortfolioDisplay;
  _sortPortfolioDisplay() {
    sortedPortfolioDisplay = portfolioDisplay;
    if (portfolioSortType[1]) {
      if (portfolioSortType[0] == "holdings") {
        sortedPortfolioDisplay.sort((a, b) =>
            (b["price_usd"] * b["total_quantity"])
                .toDouble()
                .compareTo((a["price_usd"] * a["total_quantity"]).toDouble()));
      } else {
        sortedPortfolioDisplay.sort((a, b) =>
            b[portfolioSortType[0]].compareTo(a[portfolioSortType[0]]));
      }
    } else {
      if (portfolioSortType[0] == "holdings") {
        sortedPortfolioDisplay.sort((a, b) =>
            (a["price_usd"] * a["total_quantity"])
                .toDouble()
                .compareTo((b["price_usd"] * b["total_quantity"]).toDouble()));
      } else {
        sortedPortfolioDisplay.sort((a, b) =>
            a[portfolioSortType[0]].compareTo(b[portfolioSortType[0]]));
      }
    }
  }

  final PageStorageKey _marketKey = new PageStorageKey("market");
  final PageStorageKey _portfolioKey = new PageStorageKey("portfolio");

  Widget portfolioPage(BuildContext context) {
    return new RefreshIndicator(
        key: _portfolioKey,
        onRefresh: _refreshPortfolioPage,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: new CustomScrollView(
            slivers: <Widget>[
              new SliverList(
                  delegate: new SliverChildListDelegate(<Widget>[
                Container(
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.grey.shade400.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10)),
                    child: new Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Text("Total Portfolio Value",
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(fontSize: 15)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  new Text(
                                      "\$" +
                                          numCommaParse(
                                              totalPortfolioStats["value_usd"]
                                                  .toStringAsFixed(2)),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          )
                                          .apply(fontSizeFactor: 2.1)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Text("1h Change",
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(fontSize: 13)),
                                  new Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1.0)),
                                  new Text(
                                      totalPortfolioStats[
                                                  "percent_change_1h"] >=
                                              0
                                          ? "+" +
                                              totalPortfolioStats[
                                                      "percent_change_1h"]
                                                  .toStringAsFixed(2) +
                                              "%"
                                          : totalPortfolioStats[
                                                      "percent_change_1h"]
                                                  .toStringAsFixed(2) +
                                              "%",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyText2
                                          .apply(
                                            color: totalPortfolioStats[
                                                        "percent_change_1h"] >=
                                                    0
                                                ? Colors.green
                                                : Colors.red,
                                            fontSizeFactor: 1.4,
                                          ))
                                ],
                              ),
                              new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Text("24h Change",
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(fontSize: 13)),
                                  new Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1.0)),
                                  new Text(
                                      totalPortfolioStats[
                                                  "percent_change_24h"] >=
                                              0
                                          ? "+" +
                                              totalPortfolioStats[
                                                      "percent_change_24h"]
                                                  .toStringAsFixed(2) +
                                              "%"
                                          : totalPortfolioStats[
                                                      "percent_change_24h"]
                                                  .toStringAsFixed(2) +
                                              "%",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyText2
                                          .apply(
                                              color: totalPortfolioStats[
                                                          "percent_change_24h"] >=
                                                      0
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontSizeFactor: 1.4))
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(left: 6.0, right: 6.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          bottom: new BorderSide(
                              color: Theme.of(context).dividerColor,
                              width: 1.0))),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new InkWell(
                        onTap: () {
                          if (portfolioSortType[0] == "symbol") {
                            portfolioSortType[1] = !portfolioSortType[1];
                          } else {
                            portfolioSortType = ["symbol", false];
                          }
                          setState(() {
                            _sortPortfolioDisplay();
                          });
                        },
                        child: new Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          width: MediaQuery.of(context).size.width *
                              portfolioColumnProps[0],
                          child: portfolioSortType[0] == "symbol"
                              ? new Text(
                                  portfolioSortType[1] == true
                                      ? "Currency " + upArrow
                                      : "Currency " + downArrow,
                                  // style: Theme.of(context).textTheme
                                )
                              : new Text(
                                  "Currency",
                                  // style: Theme.of(context)
                                  //     .textTheme
                                  //     .bodyText2
                                  //     .apply(color: Theme.of(context).hintColor),
                                ),
                        ),
                      ),
                      new InkWell(
                        onTap: () {
                          if (portfolioSortType[0] == "holdings") {
                            portfolioSortType[1] = !portfolioSortType[1];
                          } else {
                            portfolioSortType = ["holdings", true];
                          }
                          setState(() {
                            _sortPortfolioDisplay();
                          });
                        },
                        child: new Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          width: MediaQuery.of(context).size.width *
                              portfolioColumnProps[1],
                          child: portfolioSortType[0] == "holdings"
                              ? new Text(
                                  portfolioSortType[1] == true
                                      ? "Holdings " + downArrow
                                      : "Holdings " + upArrow,
                                  style: Theme.of(context).textTheme.bodyText2)
                              : new Text("Holdings",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .apply(
                                          color: Theme.of(context).hintColor)),
                        ),
                      ),
                      new InkWell(
                        onTap: () {
                          if (portfolioSortType[0] == "percent_change_24h") {
                            portfolioSortType[1] = !portfolioSortType[1];
                          } else {
                            portfolioSortType = ["percent_change_24h", true];
                          }
                          setState(() {
                            _sortPortfolioDisplay();
                          });
                        },
                        child: new Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          width: MediaQuery.of(context).size.width *
                              portfolioColumnProps[2],
                          child: portfolioSortType[0] == "percent_change_24h"
                              ? new Text(
                                  portfolioSortType[1] == true
                                      ? "Price/24h " + downArrow
                                      : "Price/24h " + upArrow,
                                  style: Theme.of(context).textTheme.bodyText2)
                              : new Text("Price/24h",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .apply(
                                          color: Theme.of(context).hintColor)),
                        ),
                      ),
                    ],
                  ),
                ),
              ])),
              portfolioMap.isNotEmpty
                  ? new SliverList(
                      delegate: new SliverChildBuilderDelegate(
                          (context, index) => new PortfolioListItem(
                              sortedPortfolioDisplay[index],
                              portfolioColumnProps),
                          childCount: sortedPortfolioDisplay != null
                              ? sortedPortfolioDisplay.length
                              : 0))
                  : new SliverFillRemaining(
                      child: new Container(
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                  height: 150,
                                  width: 150,
                                  child: Image.asset(
                                      'assets/images/no-money.png')),
                              SizedBox(
                                height: 20,
                              ),
                              new Text("Your wallet is empty",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22)),
                              SizedBox(
                                height: 10,
                              ),
                              new Text(
                                  "Add a transaction to show it up \non your wallet",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.grey.shade600,
                                          fontSize: 16)),

                              new Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0)),
                              // new ElevatedButton(
                              //   onPressed: _openTransaction,
                              //   child: new Text("New Transaction",
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .bodyText2
                              //           .apply(
                              //               color: Theme.of(context)
                              //                   .iconTheme
                              //                   .color)),
                              // )
                            ],
                          ))),
            ],
          ),
        ));
  }

  final marketColumnProps = [.32, .35, .28];
  List filteredMarketData;
  Map globalData;

  Future<Null> getGlobalData() async {
    // var response = await http.get(
    //     Uri.encodeFull("https://api.coinmarketcap.com/v1/global-metrics/quotes/latest"),
    //     headers: {"Accept": "application/json"});

    // globalData = new JsonDecoder().convert(response.body)["data"]["quotes"]["USD"];
    globalData = null;
  }

  Future<Null> _refreshMarketPage() async {
    await getMarketData();
    await getGlobalData();
    _makePortfolioDisplay();
    _filterMarketData();
    setState(() {});
  }

  _filterMarketData() {
    print("filtering market data");
    filteredMarketData = marketListData;
    if (filter != "" && filter != null) {
      List tempFilteredMarketData = [];
      filteredMarketData.forEach((item) {
        if (item["CoinInfo"]["Name"]
                .toLowerCase()
                .contains(filter.toLowerCase()) ||
            item["CoinInfo"]["FullName"]
                .toLowerCase()
                .contains(filter.toLowerCase())) {
          tempFilteredMarketData.add(item);
        }
      });
      filteredMarketData = tempFilteredMarketData;
    }
    _sortMarketData();
  }

  List marketSortType = ["MKTCAP", true];
  _sortMarketData() {
    if (filteredMarketData == [] || filteredMarketData == null) {
      return;
    }
    // highest to lowest
    if (marketSortType[1]) {
      if (marketSortType[0] == "MKTCAP" ||
          marketSortType[0] == "TOTALVOLUME24H" ||
          marketSortType[0] == "CHANGEPCT24HOUR") {
        print(filteredMarketData);
        filteredMarketData.sort((a, b) =>
            (b["RAW"]["USD"][marketSortType[0]] ?? 0)
                .compareTo(a["RAW"]["USD"][marketSortType[0]] ?? 0));
        if (marketSortType[0] == "MKTCAP") {
          print("adding ranks to filteredMarketData");
          int i = 1;
          for (Map coin in filteredMarketData) {
            coin["rank"] = i;
            i++;
          }
        }
      } else {
        // Handle sorting by name
        filteredMarketData.sort((a, b) =>
            (b["CoinInfo"][marketSortType[0]] ?? 0)
                .compareTo(a["CoinInfo"][marketSortType[0]] ?? 0));
      }
      // lowest to highest
    } else {
      if (marketSortType[0] == "MKTCAP" ||
          marketSortType[0] == "TOTALVOLUME24H" ||
          marketSortType[0] == "CHANGEPCT24HOUR") {
        filteredMarketData.sort((a, b) =>
            (a["RAW"]["USD"][marketSortType[0]] ?? 0)
                .compareTo(b["RAW"]["USD"][marketSortType[0]] ?? 0));
      } else {
        filteredMarketData.sort((a, b) =>
            (a["CoinInfo"][marketSortType[0]] ?? 0)
                .compareTo(b["CoinInfo"][marketSortType[0]] ?? 0));
      }
    }
  }

  Widget marketPage(BuildContext context) {
    return filteredMarketData != null
        ? new RefreshIndicator(
            key: _marketKey,
            onRefresh: () => _refreshMarketPage(),
            child: new CustomScrollView(
              slivers: <Widget>[
                new SliverList(
                    delegate: new SliverChildListDelegate(<Widget>[
                  globalData != null && isSearching != true
                      ? new Container(
                          // color: Colors.red,
                          padding: const EdgeInsets.all(14.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text("Total Market Cap",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .apply(
                                              color:
                                                  Theme.of(context).hintColor)),
                                  new Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1.0)),
                                  new Text("Total 24h Volume",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .apply(
                                              color:
                                                  Theme.of(context).hintColor)),
                                ],
                              ),
                              new Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 1.0)),
                              new Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  new Text(
                                      "\$" +
                                          normalizeNum(
                                              globalData["total_market_cap"]),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .apply(
                                              fontSizeFactor: 1.2,
                                              fontWeightDelta: 2)),
                                  new Text(
                                      "\$" +
                                          normalizeNum(
                                              globalData["total_volume_24h"]),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .apply(
                                              fontSizeFactor: 1.2,
                                              fontWeightDelta: 2)),
                                ],
                              )
                            ],
                          ))
                      : new Container(),
                  new Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: new BoxDecoration(
                        // color: Colors.red,
                        border: new Border(
                            bottom: new BorderSide(
                                color: Colors.grey.shade400, width: 1.0))),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new InkWell(
                          onTap: () {
                            if (marketSortType[0] == "Name") {
                              marketSortType[1] = !marketSortType[1];
                            } else {
                              marketSortType = ["Name", false];
                            }
                            setState(() {
                              _sortMarketData();
                            });
                          },
                          child: new Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14.0,
                            ),
                            // width: MediaQuery.of(context).size.width *
                            //     marketColumnProps[0],
                            child: marketSortType[0] == "Name"
                                ? new Text(
                                    marketSortType[1]
                                        ? "Currency " + upArrow
                                        : "Currency " + downArrow,
                                    style:
                                        Theme.of(context).textTheme.bodyText2)
                                : new Text("Currency",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .apply(
                                            color:
                                                Theme.of(context).hintColor)),
                          ),
                        ),
                        new Container(
                          // color: Colors.red,
                          // width: MediaQuery.of(context).size.width *
                          //     marketColumnProps[1],
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new InkWell(
                                  onTap: () {
                                    if (marketSortType[0] == "MKTCAP") {
                                      marketSortType[1] = !marketSortType[1];
                                    } else {
                                      marketSortType = ["MKTCAP", true];
                                    }
                                    setState(() {
                                      _sortMarketData();
                                    });
                                  },
                                  child: new Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: marketSortType[0] == "MKTCAP"
                                        ? new Text(
                                            marketSortType[1]
                                                ? "Market Cap " + downArrow
                                                : "Market Cap " + upArrow,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2)
                                        : new Text("Market Cap",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .apply(
                                                    color: Theme.of(context)
                                                        .hintColor)),
                                  )),
                              new Text("/",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .apply(
                                          color: Theme.of(context).hintColor)),
                              new InkWell(
                                onTap: () {
                                  if (marketSortType[0] == "TOTALVOLUME24H") {
                                    marketSortType[1] = !marketSortType[1];
                                  } else {
                                    marketSortType = ["TOTALVOLUME24H", true];
                                  }
                                  setState(() {
                                    _sortMarketData();
                                  });
                                },
                                child: new Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: marketSortType[0] == "TOTALVOLUME24H"
                                      ? new Text(
                                          marketSortType[1]
                                              ? "24h " + downArrow
                                              : "24h " + upArrow,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2)
                                      : new Text("24h",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .apply(
                                                  color: Theme.of(context)
                                                      .hintColor)),
                                ),
                              )
                            ],
                          ),
                        ),
                        new InkWell(
                          onTap: () {
                            if (marketSortType[0] == "CHANGEPCT24HOUR") {
                              marketSortType[1] = !marketSortType[1];
                            } else {
                              marketSortType = ["CHANGEPCT24HOUR", true];
                            }
                            setState(() {
                              _sortMarketData();
                            });
                          },
                          child: new Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            // width: MediaQuery.of(context).size.width *
                            //     marketColumnProps[2],
                            child: marketSortType[0] == "CHANGEPCT24HOUR"
                                ? new Text(
                                    marketSortType[1] == true
                                        ? "Price/24h " + downArrow
                                        : "Price/24h " + upArrow,
                                    style:
                                        Theme.of(context).textTheme.bodyText2)
                                : new Text("Price/24h",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .apply(
                                            color:
                                                Theme.of(context).hintColor)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ])),
                filteredMarketData.isEmpty
                    ? new SliverList(
                        delegate: new SliverChildListDelegate(<Widget>[
                        new Container(
                          padding: const EdgeInsets.all(30.0),
                          alignment: Alignment.topCenter,
                          child: new Text("No results found",
                              style: Theme.of(context).textTheme.caption),
                        )
                      ]))
                    : Container(
                        child: new SliverList(
                            delegate: new SliverChildBuilderDelegate(
                                (BuildContext context, int index) =>
                                    new CoinListItem(filteredMarketData[index],
                                        marketColumnProps),
                                childCount: filteredMarketData == null
                                    ? 0
                                    : filteredMarketData.length)),
                      )
              ],
            ))
        : new Container(
            child: new Center(child: new CircularProgressIndicator()),
          );
  }
}
