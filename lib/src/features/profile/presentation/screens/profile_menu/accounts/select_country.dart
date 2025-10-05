import 'package:amptive/src/bloc/main_app/profile/profile_menu/select_country_bloc.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ATSelectCountryScreen extends StatelessWidget {
  const ATSelectCountryScreen({
    super.key,
    this.selectedCountry,
    required this.countries
  });
  final String? selectedCountry;
  final List<String> countries;

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(7, kToolbarHeight, 15, 15),
              child: Row(
                children: <Widget>[
                  ATCircleAvatar(
                    onTap: () => context.pop(),
                    diameter: 30, color: ATColors.transparent,
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  const Spacer(),
                  Text(
                    ATStrings.SELECT_COUNTRY,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Icon(Icons.keyboard_arrow_left, color: ATColors.transparent),
                ],
              ),
            ),

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: countries.map(
                  (String country){
                    return BlocBuilder<ATSelectCountryBloc, String?>(
                      builder: (_, String? state) {
                        final bool isSelected = country == (state ?? selectedCountry ?? '');
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: GestureDetector(
                            onTap: () => context.read<ATSelectCountryBloc>().selectCountry(country),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    country,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: ATColors.hexC2C2C2
                                    )
                                  ),
                                ),
                                ATContainer(
                                  height: 15, width: 15, boxShape: BoxShape.circle,
                                  padding: const EdgeInsets.all(5),
                                  color: isSelected ? ATColors.hex307FE2 : ATColors.transparent,
                                  border: Border.all(
                                    color: isSelected ? ATColors.hex307FE2 : ATColors.white,
                                    strokeAlign: 5.0
                                  ),
                                  child: const SizedBox.shrink()
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  }
                ).toList()
              ),
            )
          ],
        ),
      ),
    );
  }
}