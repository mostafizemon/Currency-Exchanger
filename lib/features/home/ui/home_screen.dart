import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:currency_exchange/features/home/widgets/currency_listview.dart';
import 'package:currency_exchange/model/currency_model.dart';
import 'package:currency_exchange/services/services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final Services services = Services();

class _HomeScreenState extends State<HomeScreen> {
  String selectedcurrency = "USD";
  late Future<List<CurrencyModel>> futureCurrencyData;

  @override
  void initState() {
    super.initState();
    futureCurrencyData = services.getLatest(selectedcurrency);
  }

  void updateCurrency(String newCurrency) {
    setState(() {
      selectedcurrency = newCurrency;
      futureCurrencyData = services.getLatest(selectedcurrency);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Currency Exchanger",
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: 50,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CountryPickerDropdown(
                  initialValue: 'US',
                  itemBuilder: _buildDropdownItem,
                  onValuePicked: (country) {
                    updateCurrency(country?.currencyCode ?? "USD");
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "All Currency",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          SizedBox(
            height: 16,
          ),
          FutureBuilder(
            future: futureCurrencyData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error occurred",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else if (snapshot.hasData) {
                List<CurrencyModel> currencyModelList = snapshot.data ?? [];
                return Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return CurrencyListview(
                        currencyModel: currencyModelList[index],
                      );
                    },
                    itemCount: currencyModelList.length,
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    "No data found",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
            },
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
          style: const TextStyle(fontSize: 16.0),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
