import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<String?> showEnterDescriptionModal(BuildContext context) async{
  String? description;
  return await showModalBottomSheet<String>(
    backgroundColor: ATColors.hex0D0D0D,
    constraints: BoxConstraints.expand(height: context.screenHeight),
    context: context,
    //useSafeArea: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Column(
        children: <Widget>[
          SizedBox(height: context.screenHeight * 0.15),
          Padding(
            padding: const EdgeInsets.fromLTRB(7, 0, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const ATXBackBtn(),
                Flexible(
                  child: Text(
                    ATStrings.DESCRIPTION,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ATContainer(
                  onTap: () => context.pop(description),
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                  color: ATColors.hex307FE2, radius: 30,
                  child: Text(
                    ATStrings.DONE,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Expanded(
            child: TextFormField(
              maxLines: 100,
              keyboardType: TextInputType.multiline,
              onChanged: (String text) => description = text,
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: ATStrings.TELL_LISTENERS_ABOUT_SHOW,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
          ),
        ],
      );
    },
  );
}
