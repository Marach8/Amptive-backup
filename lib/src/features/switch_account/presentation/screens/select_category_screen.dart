import 'package:amptive/src/features/profile/bloc/profile_bloc_export.dart';
import 'package:amptive/src/features/profile/data/models/request/create_professional_profile_request.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/radio_button.dart';
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../switch_acct/switch_acct_export.dart';

class SelectCategoryScreen extends StatelessWidget {
  const SelectCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isCreator = context.read<AccountTypeBloc>().state;
    int? selectedIndex;

    // Replace with actual categories if you have them available
    final List<String> categories = [
      "AI & Machine Learning",
      "Media and Entertaninment",
      "Personal Blog",
      "Home, Furniture & Appliances",
      "Food & Beverage",
      "Gaming",
      "Machinery & Equipment",
      "Health & Wellness",
      "Professional Services",
      "Pets",
      "Public Administration",
      "Real Estate",
      "Software & Apps",
      "Restaurant & Bars",
      "Shopping & Retail",
      "Sports, Fitness & Outdoors",
      "Travel & Tourism",
      "Finance & Investing",
      "Education & Training",
      "Electronics",
      "Clothing & Accesories",
      "Baby",
      "Automotitive & Transportation"
    ];

    return ATAnnotatedRegion(
      child: StatefulBuilder(builder: (_, StateSetter setter) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  0, kToolbarHeight * 0.3, 0, kBottomNavigationBarHeight),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverPersistentHeader(
                      floating: true,
                      delegate: ATSliverHDelegate(
                          maxExt: 210,
                          minExt: 210,
                          child: Material(
                            color: ATColors.black,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(7, 0, 15, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Material(
                                          color: ATColors.black,
                                          child: const ATRoundedBackBtn()),
                                      Text(
                                          isCreator
                                              ? ATStrings.AMPTIVE_4_CREATORS
                                              : ATStrings.AMPTIVE_4_BIZ,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                      const Visibility(
                                          visible: false,
                                          child: ATRoundedBackBtn()),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Text(
                                    ATStrings.SELECT_CAT,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 8, 15, 0),
                                  child: Text(
                                    ATStrings.CAT_WONT_BE_SHOWN,
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(color: ATColors.hexCDCDCD),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(13, 0, 15, 0),
                                  child: ATTextFormField(
                                    onChanged: (String input) {},
                                    fillColor:
                                        ATColors.white.withValues(alpha: 0.1),
                                    textInputAction: TextInputAction.done,
                                    hintText: ATStrings.SEARCH_CAT,
                                    contentPadding: EdgeInsets.zero,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                            color: ATColors.transparent)),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                            ATColors.white, BlendMode.srcATop),
                                        child: const ATImgLoader(
                                          height: 25,
                                          width: 25,
                                          imgPath: ATImgStrings.outlinedSearch,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, int index) {
                        final bool isSelected = selectedIndex == index;
                        final String title = categories[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 18, 20),
                          child: InkWell(
                            onTap: () {
                              setter(() => selectedIndex = index);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(fontSize: ATSizes.size16),
                                  ),
                                ),
                                ATRadioBtn(isSelected: isSelected)
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: categories.length,
                    ),
                  )
                ],
              ),
            ),
          ),
          bottomSheet: Builder(builder: (BuildContext context) {
            final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;
            final double bottom = bottomInset == 0 ? 50.0 : 15.0;
            return Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, bottom),
              child: ATPlainElevatedBtn(
                onPressed: selectedIndex == null
                    ? null
                    : () {
                        ProfessionalProfileData()
                            .copyWith(category: categories[selectedIndex!]);

                        const SubscriptionPlanData incoming =
                            SubscriptionPlanData(
                                entryPoint: SubPlanScreenEntryPoint
                                    .creatorProfileSetup);

                        context.pushNamed(ATRoutes.creatorSubPlanSetup,
                            extra: incoming);
                      },
                btnTitle: ATStrings.setupSubPlan,
              ),
            );
          }),
        );
      }),
    );
  }
}
