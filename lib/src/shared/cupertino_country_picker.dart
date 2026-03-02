import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


Future<Country?> showCupertinoCountryPickerModal({
  required BuildContext context,
  required Country initialCountry,
}) async{
  Country? selectedCountry;

  return await showCupertinoModalPopup<Country>(
    context: context,
    builder: (_) => SizedBox(
      height: 300,
      child: Column(
        children: <Widget>[
          Container(
            color: ATColors.hex434343,
            alignment: Alignment.centerRight,
            child: CupertinoButton(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text(
                'Done',
                style: context.textTheme.labelSmall?.copyWith(
                  fontSize: ATSizes.size16, height: 1.5
                )
              ),
              onPressed: () {
                context.pop(selectedCountry);
              },
            ),
          ),

          Expanded(
            child: CupertinoTheme(
              data: const CupertinoThemeData(
                brightness: Brightness.dark,
              ),
              child: CountryPickerCupertino(
                backgroundColor: ATColors.black.withValues(alpha: 0.8),
                initialCountry: initialCountry,
                pickerItemHeight: 50,
                itemBuilder: (Country country) =>
                    _CupertinoCountryItem(country: country),
                onValuePicked: (Country country) {
                  selectedCountry = country;
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _CupertinoCountryItem extends StatelessWidget {
  const _CupertinoCountryItem({
    required this.country,
  });

  final Country country;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: <Widget>[
          ATImgLoader(
            imgPath: CountryPickerUtils.getFlagImageAssetPath(country.isoCode),
            height: 30, width: 41,
            boxFit: BoxFit.fill,
            package: ATStrings.countryPickers,
          ),
          const SizedBox(width: 23),
          Expanded(
            child: Text(
              country.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                  ),
            ),
          ),
          Text(
            '+${country.phoneCode}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }
}
