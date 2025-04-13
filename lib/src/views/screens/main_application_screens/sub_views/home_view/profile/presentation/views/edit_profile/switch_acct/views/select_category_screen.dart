import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/presentation/profile_prez_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/radio_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';


class SelectCategoryScreen extends StatelessWidget {
  const SelectCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isCreator = AccountStatusProvider.of(context)?.isCreator ?? false;
    return ATAnnotatedRegion(
      child: Scaffold(     
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, kToolbarHeight * 0.3, 0, kBottomNavigationBarHeight),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  floating: true,
                  delegate: ATSliverHDelegate(
                    maxExt: 210, minExt: 210,
                    child: Material(
                      color: ATColors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(7, 0, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Material(
                                  color: ATColors.black,
                                  child: const ATRoundedBackBtn()
                                ),
                                Text(
                                  isCreator ? ATStrings.AMPTIVE_4_CREATORS : ATStrings.AMPTIVE_4_BIZ,
                                  style: Theme.of(context).textTheme.bodyMedium
                                ),
                                const Visibility(visible: false, child: ATRoundedBackBtn()),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Text(
                              ATStrings.SELECT_CAT,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Text(
                              ATStrings.CAT_WONT_BE_SHOWN, maxLines: 2,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: ATColors.hexCDCDCD
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(13, 0, 15, 0),
                            child: ATTextFormField(
                              onChanged: (input){},
                              fillColor: ATColors.white.withValues(alpha: 0.1),
                              textInputAction: TextInputAction.done,
                              disableBlueBorder: true,
                              hintText: ATStrings.SEARCH_CAT,
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: ATColors.trsprnt)
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(Iconsax.search_normal_14),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                ),
            
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: 30,
                    (_, index){
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 18, 20),
                        child: GestureDetector(
                          onTap: (){},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'AI & Machine Learning',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: ATFontSizes.size16
                                  ),
                                ),
                              ),
                              const ATRadioButton(isSelected: false)
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                )
              ],
            ),
          ),
        ),
      
        bottomSheet: ATContainer(
          color: ATColors.black,
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
          child: ATPlainElevatedBtn(
            onPressed: () => context.pushNamed(ATRoutes.CREATOR_SUB_PLAN),
            btnTitle: ATStrings.SETUP_SUB_PLAN
          ),
        ),
      ),
    );
  }
}