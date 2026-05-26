import 'package:amptive/src/features/profile/bloc/profile_bloc_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/radio_button.dart';
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({super.key});

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  String? _selectedCategory;

  final List<String> _categories = const [
    'AI & Machine Learning',
    'Music',
    'Technology',
    'Finance & Investing',
    'Health & Wellness',
    'Education & Learning',
    'Gaming',
    'Comedy & Entertainment',
    'Business & Entrepreneurship',
    'Fashion & Lifestyle',
    'Sports',
    'Art & Design',
    'Travel',
    'Food & Cooking',
    'Science & Nature',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isCreator = context.read<AccountTypeBloc>().state;
    final bool canProceed = _selectedCategory != null;

    return ATAnnotatedRegion(
      child: Scaffold(
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
                            padding: const EdgeInsets.fromLTRB(7, 0, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const ATRoundedBackBtn(),
                                Text(
                                  isCreator ? ATStrings.AMPTIVE_4_CREATORS : ATStrings.AMPTIVE_4_BIZ,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(width: 30),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Text(ATStrings.SELECT_CAT,
                                style: Theme.of(context).textTheme.headlineLarge),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
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
                            padding: const EdgeInsets.fromLTRB(13, 0, 15, 0),
                            child: ATTextFormField(
                              onChanged: (_) {},
                              fillColor: ATColors.white.withValues(alpha: 0.1),
                              textInputAction: TextInputAction.done,
                              hintText: ATStrings.SEARCH_CAT,
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: ATColors.transparent),
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(ATColors.white, BlendMode.srcATop),
                                  child: const ATImgLoader(
                                    height: 25, width: 25,
                                    imgPath: ATImgStrings.outlinedSearch,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: _categories.length,
                    (_, int index) {
                      final String cat = _categories[index];
                      final bool selected = _selectedCategory == cat;

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 18, 20),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Text(cat,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(fontSize: ATSizes.size16)),
                              ),
                              ATRadioBtn(isSelected: selected),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Builder(builder: (context) {
          final double bottom = MediaQuery.viewInsetsOf(context).bottom == 0 ? 50.0 : 15.0;

          return Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, bottom),
            child: ATPlainElevatedBtn(
              onPressed: canProceed
                  ? () => context.pushNamed(
                        ATRoutes.creatorSubPlanSetup,
                        extra: _selectedCategory,   // ← passing the category
                      )
                  : null,
              btnTitle: ATStrings.setupSubPlan,
            ),
          );
        }),
      ),
    );
  }
}
