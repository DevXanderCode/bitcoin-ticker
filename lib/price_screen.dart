import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'package:intl/intl.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  late String btcUsd = '?';
  CoinData coinData = CoinData('USD');

  void updateUi() async {
    var formatter = NumberFormat('#,##,000');
    var btcPrice = await getPrice();
    setState(() {
      btcUsd = formatter.format(btcPrice.toInt());
    });
  }

  DropdownButton androidDropDownButton() {
    List<DropdownMenuItem<String>> dropDownList = [];
    for (String item in currenciesList) {
      dropDownList.add(
        DropdownMenuItem(
          child: Text(item),
          value: item,
        ),
      );
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownList,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerList = [];
    for (String item in currenciesList) {
      pickerList.add(
        Text(item),
      );
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerList,
    );
  }

  Widget getPickerOrDropdown() =>
      Platform.isIOS ? iosPicker() : androidDropDownButton();

  @override
  void initState() {
    super.initState();
    updateUi();
  }

  dynamic getPrice() async {
    return await coinData.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 28.0,
                ),
                child: Text(
                  '1 BTC = $btcUsd USD',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPickerOrDropdown(),
          )
        ],
      ),
    );
  }
}
