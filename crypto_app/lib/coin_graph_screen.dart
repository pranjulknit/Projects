import 'dart:convert';

import 'package:crypto_app/app_theme.dart';
import 'package:crypto_app/coin_details_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoinGraphScreen extends StatefulWidget {
  // final String coinId, coinName;
  final CoinDetailsModel coinDetailsModel;
  CoinGraphScreen({Key? key, required this.coinDetailsModel});

  @override
  State<CoinGraphScreen> createState() => _CoinGraphScreenState();
}

class _CoinGraphScreenState extends State<CoinGraphScreen> {
  bool isLoading = true;
  bool isFirstTime = true;
  bool isDarkMode = AppTheme.isDarkModeEnabled;
  List<FlSpot> flSpotList = [];
  double minX = 0.0, minY = 0.0, maxX = 0.0, maxY = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChartData("1");
  }

  void getChartData(String days) async {
    if (isFirstTime) {
      isFirstTime = false;
    } else {
      setState(() {
        isLoading = true;
      });
    }
    String apiUrl =
        "https://api.coingecko.com/api/v3/coins/${widget.coinDetailsModel.id}/market_chart?vs_currency=inr&days=$days";

    Uri uri = Uri.parse(apiUrl);

    final response = await http.get(uri);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> result = json.decode(response.body);

      List rawList = result['prices'];
      List<List> chartData = rawList.map((e) => e as List).toList();
      List<PriceAndTime> priceAndTimeList = chartData
          .map(
              (e) => PriceAndTime(time: e[0]as int, Price: e[1] as double))
          .toList();

      flSpotList = [];
      for (var element in priceAndTimeList) {
        flSpotList
            .add(FlSpot(element.time.toDouble(), element.Price.toDouble()));
      }

      minX = priceAndTimeList.first.time.toDouble();
      maxX = priceAndTimeList.last.time.toDouble();
      priceAndTimeList.sort((a, b) => a.Price.compareTo(b.Price));
      minY = priceAndTimeList.first.Price.toDouble();
      maxY = priceAndTimeList.last.Price.toDouble();

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        //backgroundColor: isDarkMode ? Colors.black : Colors.white,
        backgroundColor: Colors.orangeAccent,
        title: Text(
          widget.coinDetailsModel.name,
          style: TextStyle(color: isDarkMode? Colors.white:Colors.black, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: isLoading==false
          ? SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                            text: "${widget.coinDetailsModel.name} Price\n",
                            style: TextStyle(
                              color: isDarkMode? Colors.white:Colors.black,
                              fontSize: 18,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "Rs.${widget.coinDetailsModel.currentPrice}\n",
                                style: TextStyle(
                                  color: isDarkMode? Colors.white:Colors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "${widget.coinDetailsModel.priceChangePercentage24h}% \n",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              TextSpan(
                                text: "Rs.$maxY",
                                style: TextStyle(
                                  color: isDarkMode? Colors.white:Colors.black,
                                  fontSize: 18,
                                ),
                              )
                            ]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: LineChart(
                      LineChartData(
                        minX: minX,
                        minY: minY,
                        maxX: maxX,
                        maxY: maxY,
                        borderData: FlBorderData(
                          show: false,
                        ),
                        titlesData: FlTitlesData(show: false),
                        gridData: FlGridData(getDrawingVerticalLine: ((value) {
                          return FlLine(strokeWidth: 0);
                        }), getDrawingHorizontalLine: (value) {
                          return FlLine(strokeWidth: 0);
                        }),
                        lineBarsData: [
                          LineChartBarData(
                            spots: flSpotList,
                            dotData: FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       ElevatedButton(
                  //         onPressed: () {
                  //           getChartData("1");
                  //         },
                  //         child: Text("1d"),
                  //       ),
                  //       ElevatedButton(
                  //         onPressed: () {
                  //           getChartData("7");
                  //         },
                  //         child: Text("15d"),
                  //       ),
                  //       ElevatedButton(
                  //         onPressed: () {
                  //           getChartData("30");
                  //         },
                  //         child: Text("30d"),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class PriceAndTime {
  late int time;
  late double Price;

  PriceAndTime({required this.time, required this.Price});
}
