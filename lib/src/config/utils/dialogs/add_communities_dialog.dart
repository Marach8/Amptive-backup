import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/models/community.dart';
import 'package:amptive/src/views/widgets/common_widgets/dismiss_modal.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/rich_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../services/create_show/create_show_service.dart';


Future<Community?> showCommunitiesDialog(BuildContext context) async {
  CreateShowService service = GetIt.I<CreateShowService>();
  final List<Community> communities = service.generateCommunities();

  return await showModalBottomSheet<Community>(
    context: context,
    isScrollControlled: true,
    backgroundColor: ATColors.hex202020,
    builder: (BuildContext dContext) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (_, ScrollController scrollController) {
          return Container(
            padding: const EdgeInsets.fromLTRB(15, kToolbarHeight * 0.5, 15, 15),
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
                Text(
                  ATStrings.ADD_COMMUNITY,
                  style: Theme.of(context).textTheme.bodyLarge
                ),
                const SizedBox(height: 15),
                ATRichText(
                  maxLines: 4,
                  items: <String, TextStyle>{
                    ATStrings.ADD_COMMUNITY_DESC: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                    ),
                    ATStrings.LEARN_MORE: Theme.of(context).textTheme.labelSmall!
                  },
                  textOnTap: (String text){
                    if(text == ATStrings.LEARN_MORE){

                    }
                  },
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: LayoutBuilder(
                    builder: (_, BoxConstraints kst) {
                      return ATScrollBar(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: communities.length,
                          itemBuilder: (_, int index){
                            final Community com = communities.elementAt(index);
                            return GestureDetector(
                              onTap: () => dContext.pop(com),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  children: <Widget>[
                                    ATImgLoader(
                                      width: 70, height: 50,
                                      imgPath: com.coverPic!,
                                      boxFit: BoxFit.cover
                                    ),
                                    const SizedBox(width: 15,),
                                    Flexible(
                                      child: Text(
                                        com.name!,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          fontSize: ATFontSizes.size15
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      );
                    }
                  ),
                ),
              ],
            )
          );
        },
      );
    },
  );
}
