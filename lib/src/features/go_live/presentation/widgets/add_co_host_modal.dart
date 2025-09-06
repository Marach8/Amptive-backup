import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/dismiss_modal.dart';
import 'package:amptive/src/views/widgets/common_widgets/search_filter_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/host.dart';


enum CohostSelectionMode {single, multiple,}

Future<ATCohost<bool>?> showAvailableCoHostsModal({
  required BuildContext context,
  CohostSelectionMode selectionMode = CohostSelectionMode.multiple,
}) async {
  return await showModalBottomSheet(
    context: context, isScrollControlled: true,
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
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      const ATModalDismisser(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Opacity(
                              opacity: 0.0,
                              child: Text(
                                '3 selected',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: ATColors.hexC2C2C2
                                )
                              ),
                            ),
                            Text(
                              ATStrings.ADD_CO_HOST,
                              style: Theme.of(context).textTheme.bodyLarge
                            ),
                            BlocSelector<CohostServiceBloc, (List<ATCohost<bool>>, List<ATCohost<bool>>), List<ATCohost<bool>>>(
                              selector: ((List<ATCohost<bool>>, List<ATCohost<bool>>) state) => state.$2,
                              builder: (_, List<ATCohost<bool>> selectedCoHosts) {
                                final Iterable<ATCohost<bool>> realCohosts = selectedCoHosts.where(
                                  (ATCohost<bool> coHost) => coHost.profilePicture != null
                                );
                                return Text(
                                  '${realCohosts.length} selected',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                          ATStrings.ADD_COHOST_DESC, maxLines: 2,
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
            
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                        child: SearchFieldWithXSuffix(
                          hintText: ATStrings.SEARCH_4_COHOSTS,
                          onClear: (){
                            bContext.read<SearchkeyBloc>().resetSearch();
                            dContext.read<CohostServiceBloc>().resetCohostSearch();
                          },
                          onChanged: (String searchKey){
                            ATHelperFuncs.callDebouncer(
                              500,
                              (){
                                dContext.read<CohostServiceBloc>().searchCoHosts(searchKey);
                                bContext.read<SearchkeyBloc>().updateSearchKey(searchKey);
                              }
                            );
                          },
                        ),
                      ),                
                      
                      const SelectedCohostsRow(),
                      
                      Expanded(child: AvailableCohostsList(
                        scrollController: scrollController,
                        selectionMode: selectionMode,
                      )),
                    ],
                  )
                );
              },
            ),
          ),

          Positioned(
            bottom: 0, left: 0, right: 0,
            child: BlocSelector<CohostServiceBloc, (List<ATCohost<bool>>, List<ATCohost<bool>>), List<ATCohost<bool>>>(
              selector: ((List<ATCohost<bool>>, List<ATCohost<bool>>) state) => state.$2,
              builder: (_, List<ATCohost<bool>> selectedCoHosts) {
                final bool activateBtn = selectedCoHosts.any(
                  (ATCohost<bool> coHost) => coHost.profilePicture != null
                );

                return ATBlurredBgBtn(
                  onPressed: activateBtn ? () => dContext.pop() : null,
                  btnTitle: ATStrings.CONTINUE,
                );
              }
            ),
          )
        ],
      );
    },
  );
}
