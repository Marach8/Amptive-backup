import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class ATSelectCountryScreen extends StatelessWidget {
  const ATSelectCountryScreen(
      {super.key, this.selectedCountry, required this.countries});

  final String? selectedCountry;
  final List<String> countries;

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    // return ATAnnotatedRegion(
    //   child: Scaffold(
    //     appBar: const ATAppBar(
    //       leadingWidth: 30,
    //       padding: EdgeInsets.only(left: 7),
    //       leading: ATRoundedBackBtn(),
    //       titleText: ATStrings.SELECT_COUNTRY,
    //     ),
    //     body: SingleChildScrollView(
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: countries.map(
    //           (String country){
    //             final bool isSelected = country == (selectedCountry ?? '');
    //             return ATContainer(
    //               onTap: (){
    //                 context.pop(country);
    //               },
    //               padding: const EdgeInsets.all(15),
    //               radius: 0,
    //               child: Row(
    //                 children: <Widget>[
    //                   Expanded(
    //                     child: Text(
    //                       country,
    //                       style: context.textTheme.titleMedium
    //                     ),
    //                   ),
    //                   ATRadioBtn(isSelected: isSelected)
    //                 ],
    //               ),
    //             );
    //           }
    //         ).toList()
    //       ),
    //     ),
    //   ),
    // );
  }
}
