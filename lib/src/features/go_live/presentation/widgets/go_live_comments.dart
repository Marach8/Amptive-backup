
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../services/go_live_service/go_live_service.dart';


class GoLiveComments extends StatelessWidget {
  const GoLiveComments({
    super.key,
    required ScrollController scrollController,
    required this.service,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final GoLiveService service;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
      itemCount: service.coHostsListData.length,
      itemBuilder: (_, int listIndex){
        final ObjectWithNotifier<Host> string = service.coHostsListData.elementAt(listIndex);
        return ListTile(
          horizontalTitleGap: 10,
          minTileHeight: 50,
          leading: ATCircularImage(
            diameter: 35.h,
            imagePath: ATImgStrings.CRIMINAL,
          ),
          title: Text(
            string.obj.name ?? '',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ATColors.hexC2C2C2
            )
          ),
          subtitle: Text(
            string.obj.username ?? '',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: ATFontSizes.size13
            )
          ),
        );
      },
    );
  }
}

