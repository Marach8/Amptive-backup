import 'package:amptive/src/features/discover/cubits/users_cubits.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/search_filter_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import '../../../../shared/global_model_objects.dart';

enum CohostSelectionMode {single, multiple,}

Future<List<User>?> showAvailableCoHostsModal({
  required BuildContext context,
  CohostSelectionMode selectionMode = CohostSelectionMode.multiple,
  required AllUsersCubit allUsersCubit,
  List<User>? selectedCoHosts,
}) async {
  return await showModalBottomSheet<List<User>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    // Same treatment as the community modal: transparent sheet, corners and
    // fill come from the ClipRRect + Material inside.
    backgroundColor: Colors.transparent,
    barrierColor: ATColors.black.withValues(alpha: 0.5),
    builder: (BuildContext dContext) {
      return MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider<AllUsersCubit>.value(value: allUsersCubit),
          BlocProvider<SearchkeyCubit>(create: (_) => SearchkeyCubit()),
          BlocProvider<SelectedCohostsCubit>(
              create: (_) =>
                  SelectedCohostsCubit(initialCohosts: selectedCoHosts)),
        ],
        child: Stack(
          children: <Widget>[
            DraggableScrollableSheet(
              expand: false,
              // Open nearly full-height, like the community modal.
              initialChildSize: 0.94,
              minChildSize: 0.5,
              maxChildSize: 0.94,
              builder: (_, ScrollController scrollController) {
                return ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30)),
                  child: Material(
                    color: const Color(0xFF1C1C1E),
                    child:
                        _SelectCohostModal(scrollController: scrollController),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BlocBuilder<SelectedCohostsCubit, List<User>>(
                  builder: (_, List<User> selectedCoHosts) {
                final bool activateBtn = selectedCoHosts.isNotEmpty;
                return ATBlurredBgBtn(
                  onPressed:
                      activateBtn ? () => dContext.pop(selectedCoHosts) : null,
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

class _SelectCohostModal extends StatefulWidget {
  const _SelectCohostModal({
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<_SelectCohostModal> createState() => _SelectCohostModalState();
}

class _SelectCohostModalState extends State<_SelectCohostModal> {
  @override
  void initState(){
    super.initState();
    widget.scrollController.addListener(_onCohostsScrollToEnd);
    // Page through until the Suggestions list has enough users with an avatar.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AllUsersCubit>().loadSuggestionsWithAvatars();
      }
    });
  }

  void _onCohostsScrollToEnd() {
    const double threshHold = 50;
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent + threshHold) {
      context.read<AllUsersCubit>().fetchAllUsers();
    }
  }

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
                ATStrings.addCohost,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.39,
                ),
              ),
              BlocBuilder<SelectedCohostsCubit, List<User>>(
                  builder: (_, List<User> selectedCoHosts) {
                return SizedBox(
                  width: 70,
                  child: Text('${selectedCoHosts.length} selected',
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
            ATStrings.addCohostDesc,
            maxLines: 2,
            style: context.textTheme.labelSmall!
                .copyWith(color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          // Search always stays interactive — it queries the backend directly,
          // so it must never lock up just because the current results are
          // empty (which was freezing the field after a no-match search).
          child: SearchFieldWithXSuffix(
            hintText: ATStrings.searchForCohost,
            onClear: () {
              context.read<SearchkeyCubit>().resetSearch();
              context.read<AllUsersCubit>().resetSearch();
            },
            onChanged: (String searchKey) {
              // 300ms matches the discover search and the ~250–350ms
              // global norm for search-as-you-type.
              ATHelperFuncs.callDebouncer(300, () {
                context.read<AllUsersCubit>().searchUsers(searchKey);
                context.read<SearchkeyCubit>().updateSearchKey(searchKey);
              });
            },
          ),
        ),
        const SelectedCohostsRow(),
        Expanded(
          child: AvailableCohostsList(
            scrollController: widget.scrollController,
            selectionMode: CohostSelectionMode.multiple
          )
        ),
      ],
    );
  }
}
