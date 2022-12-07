import 'dart:convert';
import 'dart:ffi';

import 'package:crypto_app/app_theme.dart';
import 'package:crypto_app/coin_graph_screen.dart';
import 'package:crypto_app/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'coin_details_model.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String url =
      "https://api.coingecko.com/api/v3/coins/markets?vs_currency=inr&order=market_cap_desc&per_page=100&page=1&sparkline=false";
  String name = "", email = "";
  bool isDarkMode = AppTheme.isDarkModeEnabled;
  bool isFirstTimeDataAcess = true;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  List<CoinDetailsModel> coinDetailsList = [];
  late Future<List<CoinDetailsModel>> coinDetailsFuture;

  @override
  void initState() {
    super.initState();
    getUserDetails();

    coinDetailsFuture = getCoinsDetails();
  }

  void getUserDetails() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    setState(() {
      name = _prefs.getString('name') ?? "";
      email = _prefs.getString('email') ?? "";
    });
  }

  Future<List<CoinDetailsModel>> getCoinsDetails() async {
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200 || response.statusCode == 201) {
      List coinsData = json.decode(response.body);
      List<CoinDetailsModel> data =
          coinsData.map((e) => CoinDetailsModel.fromJson(e)).toList();
      return data;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _globalKey.currentState!.openDrawer();
          },
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.orangeAccent,
        title: Text(
          'Crypto Currency App',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      drawer: Drawer(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
              ),
              accountName: Text(
               name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              accountEmail: Text(
                email,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              currentAccountPicture: Icon(
                Icons.account_circle,
                size: 50,
                color: Colors.white,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateProfileScreen()));
              },
              title: Text(
                "Update Profile",
                style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 17),
              ),
              leading: Icon(Icons.account_box,
                  color: isDarkMode ? Colors.white : Colors.black),
            ),
            ListTile(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                setState(() {
                  isDarkMode = !isDarkMode;
                });
                AppTheme.isDarkModeEnabled = isDarkMode;
                await prefs.setBool(('isDarkMode'), isDarkMode);
              },
              title: Text(
                isDarkMode ? "Light Mode" : "Dark Mode",
                style: TextStyle(
                    fontSize: 17,
                    color: isDarkMode ? Colors.white : Colors.black),
              ),
              leading: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            )
          ],
        ),
      ),
      body: FutureBuilder(
          future: coinDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (isFirstTimeDataAcess) {
                coinDetailsList = snapshot.data!;
                isFirstTimeDataAcess = false;
              }

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    child: TextField(
                      onChanged: ((query) {
                        List<CoinDetailsModel> searchResult =
                            snapshot.data!.where((element) {
                          String coinName = element.name;

                          bool isFound = coinName.contains(query);
                          return isFound;
                        }).toList();
                        setState(() {
                          coinDetailsList = searchResult;
                        });
                      }),
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: isDarkMode ? Colors.white : Colors.grey,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          hintText: "Search for a coin",
                          hintStyle: TextStyle(
                            color: isDarkMode ? Colors.white : null,
                          )),
                    ),
                  ),
                  Expanded(
                    child: coinDetailsList.isEmpty
                        ? Center(
                            child: Text("No Coin Found"),
                          )
                        : ListView.builder(
                            itemCount: coinDetailsList.length,
                            itemBuilder: (context, index) {
                              return coinDetails(coinDetailsList[index]);
                            }),
                  )
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget coinDetails(CoinDetailsModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CoinGraphScreen(coinDetailsModel: model)));
        },
        leading:
            SizedBox(height: 50, width: 50, child: Image.network(model.image)),
        title: Text(
          "${model.name}\n${model.symbol}",
          style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w500),
        ),
        trailing: RichText(
          textAlign: TextAlign.end,
          text: TextSpan(
              text: "Rs${model.currentPrice}\n",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              children: [
                TextSpan(
                  text: "${model.priceChangePercentage24h}%",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
