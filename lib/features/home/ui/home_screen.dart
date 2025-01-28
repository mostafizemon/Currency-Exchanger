import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  RxString selectedcurrency = "US".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
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
                    selectedcurrency.value = country?.currencyName ?? "";
                  },
                ),
              ),
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
          style: const TextStyle(fontSize: 16.0),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
