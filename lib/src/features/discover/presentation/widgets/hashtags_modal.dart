import 'package:amptive/src/features/discover/cubits/hashtags_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/search_filter_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // Same treatment as the community/cohost modals: transparent sheet, the
    // corners and fill come from the ClipRRect + Material inside.
    backgroundColor: Colors.transparent,
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
              initialChildSize: 0.94,
              minChildSize: 0.5,
              maxChildSize: 0.94,
              builder: (BuildContext bContext, ScrollController scrollController) {
                return ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30)),
                  child: Material(
                    color: const Color(0xFF1C1C1E),
                    child: _SelectHashtagsModal(
                        scrollController: scrollController),
                  ),
                );
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
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        Center(
          child: Container(
            width: 38,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(width: 70),
              Text(
                ATStrings.addHashtags,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.39,
                ),
              ),
              BlocBuilder<SelectedHashTagsCubit, List<HashTag>>(
                  builder: (_, List<HashTag> selectedHashtags) {
                return SizedBox(
                  width: 70,
                  child: Text('${selectedHashtags.length} selected',
                      textAlign: TextAlign.end,
                      style: context.textTheme.titleSmall
                          ?.copyWith(color: ATColors.hexC2C2C2)),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Text(
            ATStrings.addHashtagsDesc,
            maxLines: 2,
            style: context.textTheme.labelSmall!
                .copyWith(color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          // Search always stays interactive — never lock the field just
          // because the current results are empty.
          child: SearchFieldWithXSuffix(
            hintText: ATStrings.searchForHashtag,
            onClear: () {
              context.read<SearchkeyCubit>().resetSearch();
              context.read<AllHashtagsCubit>().resetSearch();
            },
            onChanged: (String searchKey) {
              ATHelperFuncs.callDebouncer(300, () {
                context.read<AllHashtagsCubit>().searchHashtags(searchKey);
                context.read<SearchkeyCubit>().updateSearchKey(searchKey);
              });
            },
          ),
        ),
        const SelectedHashtagsRow(),
        Expanded(
          child: AvailableHashtagsList(
            scrollController: widget.scrollController,)),
      ],
    );
  }
}
