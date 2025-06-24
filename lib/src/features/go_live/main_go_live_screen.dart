import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../utils/constants/colors.dart';
import '../../views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/widgets_in_go_live/create_show_or_event_selection_widget.dart';

class AmptiveGoLiveScreen extends StatefulWidget {
  const AmptiveGoLiveScreen({super.key});

  @override
  State<AmptiveGoLiveScreen> createState() => _AmptiveGoLiveScreenState();
}

class _AmptiveGoLiveScreenState extends State<AmptiveGoLiveScreen> {
  ValueNotifier<bool> activateButton = ValueNotifier(false);
  ValueNotifier<bool> eventSelected = ValueNotifier(false);
  ValueNotifier<bool> showSelected = ValueNotifier(false);
  
  @override 
  void dispose(){
    activateButton.dispose();
    eventSelected.dispose();
    showSelected.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: ATAppBar(
          leading: GestureDetector(
            onTap: (){context.pop();},
            child: const Icon(Icons.close, size: 20,)
          ),
          leadingWidth: 20,
          title: Text(
            ATStrings.CREATE_SHOW_OR_EVENT,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                maxLines: 3,
                ATStrings.CHOOSE_2_CREATE_SHOW_OR_EVENT,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ATColors.hexC2C2C2
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: AmptiveCreateShowOrEventSelectionWidget(
                      activateBtn: activateButton,
                      eventSelected: eventSelected,
                      showSelected: showSelected,
                      onSelectedImagePath: ATImgStrings.CREATE_SHOW_ICON,
                      title: ATStrings.CREATE_SHOW,
                      subtitle: ATStrings.CREATE_SHOW_DESC,
                      alphabet: 'S',
                    ),
                  ),
                  const Gap(15),
                  Expanded(
                    child: AmptiveCreateShowOrEventSelectionWidget(
                      activateBtn: activateButton,
                      eventSelected: eventSelected,
                      showSelected: showSelected,
                      onSelectedImagePath: ATImgStrings.CREATE_EVENT_ICON,
                      title: ATStrings.CREATE_EVENT,
                      subtitle: ATStrings.CREATE_EVENT_DESC,
                      alphabet: 'E',
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        
        bottomNavigationBar: AmptiveRebuilderWidget(
          notifier: activateButton,
          builder: (_, activate, __) => AmptiveElevatedButtonWidget(
            onPressed: activate ? (){
              showSelected.value ?
                context.pushNamed(ATRoutes.CHOOSE_OR_CREATE_SHOW_SCREEN)
              : context.pushNamed(ATRoutes.CHOOSE_OR_CREATE_EVENT_SCREEN);
            }: null,
            buttonTitle: ATStrings.CONTINUE,
            bgColor: ATColors.white,
            fgColor: ATColors.black,
          ),
        ),
      ),
    );
  }
}