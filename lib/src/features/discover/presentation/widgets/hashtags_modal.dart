import 'package:amptive/src/features/discover/cubits/hashtags_cubit.dart';
import 'package:amptive/src/features/discover/data/models/response/all_hashtags_response_model.dart';
import 'package:go_router/go_router.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:amptive/src/shared/search_filter_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:nested/nested.dart';
import '../../../../shared/global_model_objects.dart';



Future<List<HashTag>?> showNewHashTagsModal({
  required BuildContext context,
  required AllHashtagsCubit allHashTagsCubit,
  required SelectedHashTagsCubit selectedHashTagsCubit,
  List<HashTag>? selectedHashtags,
}) async {
  return await showModalBottomSheet<List<HashTag>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: ATColors.black.withValues(alpha: 0.5),
    backgroundColor: ATColors.hex202020,
    builder: (BuildContext dContext) {
      return MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider<AllHashtagsCubit>.value(value: allHashTagsCubit),
          BlocProvider<SearchkeyCubit>(create: (_) => SearchkeyCubit()),
          BlocProvider<SelectedHashTagsCubit>.value(value: selectedHashTagsCubit),
        ],
        child: Stack(
          children: <Widget>[
            DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.7,
              builder:
                  (BuildContext bContext, ScrollController scrollController) {
                return _SelectHashtagsModal(scrollController: scrollController);
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BlocBuilder<SelectedHashTagsCubit, List<HashTag>>(
                  builder: (_, List<HashTag> selectedHashtags) {
                final bool activateBtn = selectedHashtags.isNotEmpty;
                return ATBlurredBgBtn(
                  onPressed:
                      activateBtn ? () => dContext.pop(selectedHashtags) : null,
                  btnTitle: ATStrings.cContinue,
                );
              }),
            )
          ],
        ),
      );
    },
  );
}

class _SelectHashtagsModal extends StatefulWidget {
  const _SelectHashtagsModal({
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<_SelectHashtagsModal> createState() => _SelectHashtagsModalState();
}

class _SelectHashtagsModalState extends State<_SelectHashtagsModal> {
  @override 
  void initState(){
    super.initState();
    widget.scrollController.addListener(_onHashTagsScrollToEnd);
  }

  void _onHashTagsScrollToEnd() {
    const double threshHold = 80;
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent + threshHold) {
      context.read<AllHashtagsCubit>().fetchHashTags();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const ATModalDismisser(),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(width: 70),
              Text(ATStrings.addHashtags, style: context.textTheme.bodyLarge),
              BlocBuilder<SelectedHashTagsCubit, List<HashTag>>(
                  builder: (_, List<HashTag> selectedHashtags) {
                return Text('${selectedHashtags.length} selected',
                    style: context.textTheme.titleSmall
                        ?.copyWith(color: ATColors.hexC2C2C2));
              }),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Text(
            ATStrings.addCohostDesc,
            maxLines: 2,
            style: context.textTheme.labelSmall!
                .copyWith(color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: BlocBuilder<AllHashtagsCubit, ATAppState<AllHashtagsResponseModel>>(
              builder: (_, ATAppState<AllHashtagsResponseModel> state) {
            final List<HashTag> currentHashtags =
                context.read<AllHashtagsCubit>().currentTagsData?.hashtags ??
                    <HashTag>[];
            final bool disableTextfield = currentHashtags.isEmpty;

            return AbsorbPointer(
              absorbing: disableTextfield,
              child: SearchFieldWithXSuffix(
                hintText: ATStrings.searchForCohost,
                onClear: () {
                  context.read<SearchkeyCubit>().resetSearch();
                  context.read<AllHashtagsCubit>().resetSearch();
                },
                onChanged: (String searchKey) {
                  ATHelperFuncs.callDebouncer(500, () {
                    context.read<AllHashtagsCubit>().searchHashtags(searchKey);
                    context.read<SearchkeyCubit>().updateSearchKey(searchKey);
                  });
                },
              ),
            );
          }),
        ),
        const SelectedHashtagsRow(),
        Expanded(
          child: AvailableHashtagsList(
            scrollController: widget.scrollController,)),
      ],
    );
  }
}
