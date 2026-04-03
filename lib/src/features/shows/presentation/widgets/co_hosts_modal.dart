import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/cubits/users_cubits.dart';
import 'package:amptive/src/features/discover/data/models/response/all_users_response_model.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
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
    backgroundColor: ATColors.hex202020,
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
              initialChildSize: 0.7,
              builder: (_, ScrollController scrollController) {
                return _SelectCohostModal(scrollController: scrollController);
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
        const ATModalDismisser(),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(width: 70),
              Text(ATStrings.addCohost, style: context.textTheme.bodyLarge),
              BlocBuilder<SelectedCohostsCubit, List<User>>(
                  builder: (_, List<User> selectedCoHosts) {
                return Text('${selectedCoHosts.length} selected',
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
          child: BlocBuilder<AllUsersCubit, ATAppState<AllUsersResponseModel>>(
              builder: (_, ATAppState<AllUsersResponseModel> state) {
            final List<User> currentUsers =
                context.read<AllUsersCubit>().currentUsersData?.data ??
                    <User>[];
            final bool disableTextfield = currentUsers.isEmpty;

            return AbsorbPointer(
              absorbing: disableTextfield,
              child: SearchFieldWithXSuffix(
                hintText: ATStrings.searchForCohost,
                onClear: () {
                  context.read<SearchkeyCubit>().resetSearch();
                  context.read<AllUsersCubit>().resetSearch();
                },
                onChanged: (String searchKey) {
                  ATHelperFuncs.callDebouncer(500, () {
                    context.read<AllUsersCubit>().searchUsers(searchKey);
                    context.read<SearchkeyCubit>().updateSearchKey(searchKey);
                  });
                },
              ),
            );
          }),
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
