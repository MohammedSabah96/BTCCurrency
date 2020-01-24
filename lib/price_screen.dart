import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  @override
  void initState() {
    super.initState();
    getPrice();
  }

  DropdownButton<String> androidDropButton() {
    List<DropdownMenuItem<String>> dropDownMenuItem = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownMenuItem.add(newItem);
    }
    return DropdownButton(
      value: selectedCurrency,
      items: dropDownMenuItem,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getPrice();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItem = [];
    for (String currency in currenciesList) {
      pickerItem.add(Text(currency));
    }
    return CupertinoPicker(
      children: pickerItem,
      itemExtent: 32.0,
      backgroundColor: Colors.lightBlue,
      onSelectedItemChanged: (selectedItemIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedItemIndex];
          getPrice();
        });
      },
    );
  }

  Map<String, String> coinsValue = {};
  bool isWaiting = false;
  void getPrice() async {
    isWaiting = true;
    try {
      var data = await CoinData().getDataCoin(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinsValue = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PriceCard(
                selectedCurrency: selectedCurrency,
                priceValue: isWaiting ? '?' : coinsValue['BTC'],
                crypto: 'BTC',
              ),
              PriceCard(
                selectedCurrency: selectedCurrency,
                priceValue: isWaiting ? '?' : coinsValue['ETH'],
                crypto: 'ETH',
              ),
              PriceCard(
                selectedCurrency: selectedCurrency,
                priceValue: isWaiting ? '?' : coinsValue['LTC'],
                crypto: 'LTC',
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropButton(),
          ),
        ],
      ),
    );
  }
}

class PriceCard extends StatelessWidget {
  const PriceCard({this.priceValue, this.selectedCurrency, this.crypto});

  final String priceValue;
  final String selectedCurrency;
  final String crypto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto =$priceValue $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
