import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:currency_exchange/model/currency_model.dart';
import 'package:currency_exchange/services/services.dart';
import 'package:flutter/material.dart';

class Exchange extends StatefulWidget {
  Exchange({super.key});

  @override
  State<Exchange> createState() => _ExchangeState();
}

final Services services = Services();

class _ExchangeState extends State<Exchange> {
  String selectedBaseCurrency = "USD";
  String selectedTargetCurrency = "GBP";
  String total = "";
  bool isConverted = false;
  late Future<List<CurrencyModel>> futureCurrencyData;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureCurrencyData = services.getLatest(selectedBaseCurrency);
  }

  void updateCurrency({String? baseCurrency, String? targetCurrency}) {
    setState(() {
      if (baseCurrency != null) selectedBaseCurrency = baseCurrency;
      if (targetCurrency != null) selectedTargetCurrency = targetCurrency;
      futureCurrencyData = services.getLatest(selectedBaseCurrency);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Currency Exchanger",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // Base Currency Picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                width: double.infinity,
                child: CountryPickerDropdown(
                  initialValue: 'US',
                  itemBuilder: _buildDropdownItem,
                  onValuePicked: (country) {
                    updateCurrency(baseCurrency: country?.currencyCode);
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Amount Input Field
          SizedBox(
            width: 200,
            child: TextField(
              controller: textEditingController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Enter Your Amount",
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Target Currency Picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                width: double.infinity,
                child: CountryPickerDropdown(
                  initialValue: 'GB',
                  itemBuilder: _buildDropdownItem,
                  onValuePicked: (country) {
                    updateCurrency(targetCurrency: country?.currencyCode);
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Exchange Button
          ElevatedButton(
            onPressed: () async {
              if (textEditingController.text.isNotEmpty) {
                await services.getExchange(selectedBaseCurrency, selectedTargetCurrency).then((onValue) {
                  double value = double.parse(textEditingController.text);
                  double exchangeRate = double.parse(onValue[0].value.toString());
                  double totalAmount = value * exchangeRate;

                  setState(() {
                    total = totalAmount.toStringAsFixed(2);
                    isConverted = true; // Show the text after conversion
                  });
                });
              }
            },
            style: ButtonStyle(
              alignment: Alignment.center,
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: const Text(
              "Exchange",
              style: TextStyle(color: Colors.black),
            ),
          ),

          const SizedBox(height: 16),

          // Exchange Result (Only shown after button click)
          if (isConverted)
            Text(
              "$total $selectedTargetCurrency",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdownItem(Country country) {
    return Row(
      children: [
        CountryPickerUtils.getDefaultFlagImage(country),
        const SizedBox(width: 8.0),
        Text(
          '${country.name} (${country.currencyCode})',
          maxLines: 1,
          style: const TextStyle(fontSize: 16.0),
          overflow: TextOverflow.ellipsis, // Prevents overflow
        ),
      ],
    );
  }
}
