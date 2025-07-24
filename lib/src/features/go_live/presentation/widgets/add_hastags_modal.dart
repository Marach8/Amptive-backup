import 'dart:io';
import 'dart:ui';
import 'package:amptive/src/models/hashtag.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../models/host.dart';
import '../../../../services/create_show/create_show_service.dart';
import '../../../../views/widgets/common_widgets/custom_rebuilder_widget.dart';
import '../../../../views/widgets/common_widgets/elevated_button_widget.dart';
import '../../../../config/utils/other_strings.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/dismiss_modal.dart';
import 'package:amptive/src/views/widgets/common_widgets/search_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/host.dart';


Future<void> showTrendingHashtagsModal(BuildContext context) async {
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: ATColors.hex202020,
    builder: (BuildContext dContext) {
      return Stack(
        children: <Widget>[
          BlocProvider<SearchkeyBloc>(
            create: (_) => SearchkeyBloc(),
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.7,
              builder: (BuildContext bContext, ScrollController scrollController) {
                return Container(
                  padding: const EdgeInsets.only(top: kToolbarHeight * 0.5),
                  height: context.screenHeight,
                  width: context.screenWidth,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      const ATModalDismisser(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const SizedBox(width: 100,),
                            Text(
                              '${ATStrings.ADD_HASHTAG}s',
                              style: context.textTheme.bodyLarge
                            ),
                            BlocSelector<HashtagServiceBloc, (List<ATHashtag<bool>>, List<ATHashtag<bool>>), List<ATHashtag<bool>>>(
                              selector: ((List<ATHashtag<bool>>, List<ATHashtag<bool>>) state) => state.$2,
                              builder: (_, List<ATHashtag<bool>> selectedHashtags) {
                                return Text(
                                  '${5 - selectedHashtags.length} remaining',
                                  style: context.textTheme.titleSmall?.copyWith(
                                    color: ATColors.hexC2C2C2
                                  )
                                );
                              }
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Text(
                          ATStrings.ADD_HASHTAG_DESC, maxLines: 4,
                          style: context.textTheme.labelSmall!.copyWith(
                            color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
            
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                        child: SearchFieldWithXSuffix(
                          hintText: ATStrings.SEARCH_4_HASHTAGS,
                          onClear: () => bContext.read<SearchkeyBloc>().resetSearch(),
                          onChanged: (String searchKey){
                            ATHelperFuncs.callDebouncer(
                              500,
                              (){
                                dContext.read<HashtagServiceBloc>().searchHashtags(searchKey);
                                bContext.read<SearchkeyBloc>().updateSearchKey(searchKey);
                              }
                            );
                          },
                        ),
                      ),
                      
                      const SelectedHashtagsRowInModal(),
                      
                      Expanded(child: TrendingHashtagsList(scrollController: scrollController,)),
                    ],
                  )
                );
              },
            ),
          ),

          Positioned(
            bottom: 0, left: 0, right: 0,
            child: BlocSelector<HashtagServiceBloc, (List<ATHashtag<bool>>, List<ATHashtag<bool>>), List<ATHashtag<bool>>>(
              selector: ((List<ATHashtag<bool>>, List<ATHashtag<bool>>) state) => state.$2,
              builder: (_, List<ATHashtag<bool>> selectedHashtags) {
                final bool activateBtn = selectedHashtags.any(
                  (ATHashtag<bool> hashtag) => hashtag.title != null
                );

                return ButtonWithBgBlur(
                  onPressed: activateBtn ? () => dContext.pop() : null,
                  btnTitle: '${ATStrings.ADD_HASHTAG}s',
                );
              }
            ),
          )
        ],
      );
    },
  );
}
