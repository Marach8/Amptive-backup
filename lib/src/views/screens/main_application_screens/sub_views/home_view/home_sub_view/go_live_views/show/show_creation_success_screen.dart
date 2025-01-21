import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/animation_widgets/other_animation_widgets/animated_create_show_success_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../../utils/constants/colors.dart';
import '../../../../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../../../../utils/constants/strings/route_strings.dart';
import '../../../../../../../widgets/common_widgets/elevated_button_widget.dart';

class AmptiveCreateShowSuccessScreen extends StatefulWidget {
  final String imageFilePath;

  const AmptiveCreateShowSuccessScreen({super.key, required this.imageFilePath});

  @override
  State<AmptiveCreateShowSuccessScreen> createState() =>
      _AmptiveCreateShowSuccessScreenState();
}

class _AmptiveCreateShowSuccessScreenState
    extends State<AmptiveCreateShowSuccessScreen> {
  BoxFit imageFit = BoxFit.cover;
  final ValueNotifier<double> _normalSize = ValueNotifier(700.0);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      imageFit = BoxFit.contain;
      _normalSize.value = 140.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        appBar: AmptiveAppBar(
          leadingWidth: 20,
          leading: GestureDetector(
              onTap: () {
                context.pop();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 17,
              )),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.check_circle_sharp, size: 45),
              const Gap(15),
              Text(
                  textAlign: TextAlign.center,
                  AmptiveOtherStrings.SHOW_IS_SETUP,
                  style: Theme.of(context).textTheme.headlineLarge),
              const Gap(10),
              Text(
                textAlign: TextAlign.center,
                AmptiveOtherStrings.BEGIN_JOURNEY,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AmptiveColors.subtitleColor),
              ),
              const Gap(30),
              AmptiveRebuilderWidget(
                notifier: _normalSize,
                builder: (_, val, __) {
                  return AnimatedCreateShowSuccessImage(
                    width: val,
                    height: val,
                    imageFit: imageFit,
                    imagePath: widget.imageFilePath,
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AmptiveElevatedButtonWidget(
              onPressed: () async {
                await context.pushNamed(AmptiveRoutes.CREATE_EPISODE_FORM);
              },
              buttonTitle: AmptiveOtherStrings.CREATE_1ST_EPISODE,
              bgColor: AmptiveColors.whiteColor,
              fgColor: AmptiveColors.black,
            ),
            const Gap(10),
            Text(AmptiveOtherStrings.VIEW_SHOW_PAGE,
                style: Theme.of(context).textTheme.headlineMedium),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}
