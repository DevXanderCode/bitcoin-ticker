import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'coin_data.dart';
import 'package:intl/intl.dart';
import 'components/crypto_card.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  late String bitcoinValue = '?';
  Map coinDataMap = {};
  var formatter = NumberFormat('#,###,000');

  void updateUi() async {
    try {
      // var formatter = NumberFormat('#,###,000');
      Map dataMap = await CoinData().getCoinData(selectedCurrency);
      setState(() {
        // bitcoinValue = formatter.format(btcPrice.toInt());
        coinDataMap = dataMap;
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
          coinDataMap = {};
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
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          updateUi();
        });
      },
      children: pickerList,
    );
  }

  List<Widget> getPriceUI() {
    List<Widget> columnChildren = [];
    List<Widget> cryptoCards = [];
    late Widget cryptoCardColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );

    coinDataMap.forEach((key, value) {
      cryptoCards.add(
        CryptoCard(
            coin: key,
            coinValue: formatter.format(value.toInt()),
            selectedCurrency: selectedCurrency),
      );
    });
    columnChildren.add(cryptoCardColumn);
    columnChildren.add(
      Container(
        height: 150.0,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(bottom: 30.0),
        color: Colors.lightBlue,
        child: getPickerOrDropdown(),
      ),
    );

    return columnChildren;
  }

  Widget getPickerOrDropdown() =>
      Platform.isIOS ? iosPicker() : androidDropDownButton();

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
      body: coinDataMap.isEmpty
          ? const Center(
              child: SpinKitPouringHourGlassRefined(
                color: Colors.blue,
                size: 50.0,
                // controller: AnimationController(
                //   vsync: this,
                //   duration: const Duration(milliseconds: 1200),
                // ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: getPriceUI(),
            ),
    );
  }
}
