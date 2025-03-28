import 'dart:io';

import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/dialogs/image_source_selection_dialog.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/divider_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(context) {
    Uint8List? imageBytes;
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: AmptiveAppBar(
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: const SizedBox(
              height: 30, width: 30,
              child: Icon(Icons.keyboard_arrow_left_outlined),
            ),
          ),
          leadingWidth: 30,
          title: Text(
            ATStrings.EDIT_PROFILE,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatefulBuilder(
              builder: (context, setter) {
                return GestureDetector(
                  onTap: () async{
                    File? file;
                    final status = await showImageSourceOptions(context);
                    if(status == null){return;}
                    else if(context.mounted && status){
                      file = await ATHelperFuncs.getImageFromGallery();
                    }
                    else if(context.mounted){
                      file = await ATHelperFuncs.getImageFromCamera();
                    }

                    if(file == null) return;
                    if(context.mounted){
                      final imageData = await context
                        .pushNamed(ATRoutes.PROFILE_BG_CROP, extra: file) as MemoryImage?;
                      if(imageData != null){
                        setter(() => imageBytes = imageData.bytes);
                      }
                    }
                  },
                  child: imageBytes == null ? ATImgLoader(
                    height: 150, boxFit: BoxFit.cover,
                    width: ATHelperFuncs.getScreenWidth(context),
                    imgPath: ATImgStrings.weCanDoHardThingsBgImage
                  ) : Image.memory(
                    imageBytes!,
                    //frameBuilder: ,
                    height: 150, fit: BoxFit.cover,
                    width: ATHelperFuncs.getScreenWidth(context),
                  )
                );
              }
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const _MenuHeading(text: ATStrings.ABT_U),
                    const SizedBox(height: 10),

                    _MenuItem(
                      title: ATStrings.NAME,
                      value: 'Alieu Baba',
                      onTap: (){}
                    ),
                    const SizedBox(height: 20),
                    _MenuItem(
                      title: ATStrings.USERNAME,
                      value: 'AlieuBaba',
                      onTap: (){}
                    ),
                    const SizedBox(height: 20),
                    _MenuItem(
                      title: ATStrings.BIO,
                      value: 'Author of UNTAMED & LOVE IS IN THE AIR',
                      onTap: (){}
                    ),

                    const SizedBox(height: 15),
                    const ATDivider(),
                    const SizedBox(height: 15),

                    const _MenuHeading(text: ATStrings.LINKS),
                    const SizedBox(height: 10),
                    _MenuItem(
                      title: ATStrings.INSTAGRAM, isLink: true,
                      value: 'www.instagram.com/alieubaba1',
                      onTap: (){}
                    ),
                    const SizedBox(height: 20),
                    _MenuItem(
                      title: 'X',isLink: true,
                      value: 'www.x.com/alieubaba',
                      onTap: (){}
                    ),
                    const SizedBox(height: 20),
                    _MenuItem(
                      title: ATStrings.LINKEDIN, isLink: true,
                      value: 'www.linkedIn.com/alieubaba',
                      onTap: (){}
                    ),
                    const SizedBox(height: 20),
                    _MenuItem(
                      title: ATStrings.WEBSITE, isLink: true,
                      value: 'www.palbucks.co',
                      onTap: (){}
                    ),

                    const SizedBox(height: 15),
                    const ATDivider(),
                    const SizedBox(height: 15),

                    const _MenuHeading(text: ATStrings.ACCT),
                    const SizedBox(height: 10),
                    _MenuItem(
                      title: ATStrings.SWITCH_ACCT,
                      value: 'Audience',
                      onTap: (){}
                    ),
                  
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _MenuHeading extends StatelessWidget {
  const _MenuHeading({required this.text});

  final String text;

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: ATColors.hexC2C2C2,
          fontSize: ATFontSizes.size13
        ),
      ),
    );
  }
}


class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.title,
    required this.value,
    required this.onTap,
    this.isLink = false
  });

  final String title, value;
  final bool isLink;
  final void Function() onTap;

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(width: ATHelperFuncs.getScreenWidth(context) * 0.3),
          Expanded(
            child: Text(
              value, textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isLink ? ATColors.white.withValues(alpha: 0.4) : null
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_right)
        ],
      ),
    );
  }
}