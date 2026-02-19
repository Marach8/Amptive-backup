import 'package:amptive/src/models/community.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:get_it/get_it.dart';
import '../../../../services/create_show/create_show_service.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/modal_dismisser.dart';

Future<void> showTopCreationCommunitiesModal(BuildContext context) async {
  CreateShowService service = GetIt.I<CreateShowService>();
  final List<UnusedCommunity> communities = service.generateCommunities();

  return await showModalBottomSheet(
    backgroundColor: ATColors.hex202020,
    context: context, useSafeArea: true,
    isScrollControlled: true,
    barrierColor: ATColors.black.withValues(alpha:0.6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15), topRight: Radius.circular(15),
    )),
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (_, ScrollController scrollController) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ATModalDismisser(),
                const SizedBox(height: 5),
                Text(
                  ATStrings.TOP_CREATOR_IN,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 25,),
                Expanded(
                  child: ListView.builder(
                    itemCount: communities.length,
                    controller: scrollController,
                    itemBuilder: (_, int index){
                      final UnusedCommunity community = communities[index];                        
                      return _RenderACommunity(community);
                    },
                  ),
                )
              ]
            ),
          );
        }
      );
    }
  );
}



class _RenderACommunity extends StatelessWidget {
  const _RenderACommunity(this.community);
  final UnusedCommunity? community;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      margin: const EdgeInsets.only(bottom: 20),
      width: ATHelperFuncs.getScreenWidth(context),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 50, width: 70,
            child: ATImgLoader(imgPath: community?.coverPic ?? ''),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              community?.name ?? '',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          AmptiveElevatedButtonWidget(
            onPressed: (){},
            bgColor: ATColors.hex307FE2,
            buttonTitle: ATStrings.VIEW,
          )
        ],
      ),
    );
  }
}
