import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/search_filter_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/host.dart';


class AvailableCohostsList extends StatelessWidget {
  const AvailableCohostsList({
    super.key,
    required this.scrollController,
    required this.selectionMode,
  });

  final ScrollController scrollController;
  final CohostSelectionMode selectionMode;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CohostServiceBloc, (List<ATCohost<bool>>, List<ATCohost<bool>>), List<ATCohost<bool>>>(
      selector: ((List<ATCohost<bool>>, List<ATCohost<bool>>) state) => state.$1,
      builder: (_, List<ATCohost<bool>> coHosts) {
        if(coHosts.isEmpty){
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  ATStrings.NO_SUGGESTIONS,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: ATFontSizes.size16
                  )
                ),
                const SizedBox(height: 5,),
                Text(
                  maxLines: 2,
                  ATStrings.SEARCH_UR_COHOSTS,
                  style: context.textTheme.bodySmall?.copyWith(color: ATColors.hexC2C2C2),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (_, BoxConstraints kst) {
            return ATScrollBar(
              child: ListView.builder(
                controller: scrollController,
                itemCount: coHosts.length + 1,
                padding: const EdgeInsets.only(right: 10, bottom: 20),
                itemBuilder: (_, int index){
                  if(index == 0){
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Text(
                        ATStrings.SUGGESTIONS,
                        style: context.textTheme.bodySmall?.copyWith(
                          fontSize: ATFontSizes.size16
                        )
                      ),
                    );
                  }

                  final ATCohost<bool> coHost = coHosts.elementAt(index - 1);
                  return CohostWithCheckIconWidget(coHost: coHost, selectionMode: selectionMode,);
                },
              )
            );
          }
        );
      }
    );
  }
}



class CohostWithCheckIconWidget extends StatelessWidget {
  const CohostWithCheckIconWidget({
    super.key,
    required this.coHost,
    this.selectionMode = CohostSelectionMode.multiple,
  });

  final ATCohost<bool> coHost;
  final CohostSelectionMode selectionMode;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      radius: 10,
      onTap: (){
        if(selectionMode == CohostSelectionMode.single){
          context.pop(coHost);
        }

        else{
          if(coHost.notifier.value ?? false){
            context.read<CohostServiceBloc>().removeCohost(coHost);
          }
          else{
            context.read<CohostServiceBloc>().addCohost(coHost);
          }
        }
      },
      padding: const EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: ATImgLoader(
              height: 50, width: 50,
              boxFit: BoxFit.cover,
              imgPath: coHost.profilePicture!
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ATFilterWidget<SearchkeyBloc>(
                  title: coHost.name ?? '',
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: ATFontSizes.size15
                  )
                ),
                ATFilterWidget<SearchkeyBloc>(
                  title: coHost.username ?? '',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: ATColors.hexC2C2C2
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<bool?>(
            valueListenable: coHost.notifier,
            builder: (_, bool? isSelected, __) {
              return ATContainer(
                duration: 200,
                color: (isSelected ?? false) ? ATColors.white : ATColors.trsprnt,
                border: Border.all(color: ATColors.white),
                boxShape: BoxShape.circle,
                height: 24, width: 24,
                child: Icon(
                  Icons.check, size: 20,
                  color: (isSelected ?? false) ? ATColors.hex0D0D0D : ATColors.trsprnt
                )
              );
            }
          )
        ],
      ),
    );
  }
}
