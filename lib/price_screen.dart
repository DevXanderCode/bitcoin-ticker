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
  String selectedCurrency = 'AUD';
  late String btcUsd = '?';

  void updateUi() async {
    CoinData coinData = CoinData(selectedCurrency);
    try {
      var formatter = NumberFormat('#,##,000');
      double btcPrice = await coinData.getData();
      setState(() {
        btcUsd = formatter.format(btcPrice.toInt());
      });
    } catch (e) {
      print(e);
    }
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
          updateUi();
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
      looping: true,
      onSelectedItemChanged: (selectedIndex) {
        CoinData coinData = CoinData(selectedCurrency);
        print(selectedIndex);
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          updateUi();
        });
      },
      children: pickerList,
    );
  }

  Widget getPickerOrDropdown() =>
      Platform.isAndroid ? iosPicker() : androidDropDownButton();

  @override
  void initState() {
    super.initState();
    updateUi();
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
                  '1 BTC = $btcUsd $selectedCurrency',
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
