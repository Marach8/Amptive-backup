import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/colors.dart';
import '../widgets/go_live_type_selection_widget.dart';

class GoLiveTypeSelectionScreen extends StatelessWidget {
  const GoLiveTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: BlocProvider<_PrivateBloc>(
        create: (_) => _PrivateBloc(),
        child: BlocBuilder<_PrivateBloc, int?>(
            builder: (BuildContext blocContext, int? state) {
          final bool isBtnActive = state != null;
          return Scaffold(
            appBar: ATAppBar(
              centerTitle: true,
              toolbarHeight: 48,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              leadingWidth: 44,
              leading: IconButton(
                onPressed: () => context.pop(),
                tooltip: 'Close',
                iconSize: 24,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                ),
                icon: const Icon(Icons.close),
              ),
              title: const SizedBox.shrink(),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(15, 2, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    ATStrings.createShowOrEvent,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    maxLines: 3,
                    ATStrings.chooseToCreateShowOrEvent,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: ATColors.hexC2C2C2),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GoLiveTypeSelectionWidget(
                          onTap: (bool isSelected) => blocContext
                              .read<_PrivateBloc>()
                              .setValue(isSelected ? null : 0),
                          isSelected: state == 0,
                          unselectedImgPath: ATImgStrings.CREATE_SHOW_ICON1,
                          selectedImgPath: ATImgStrings.createShowSelectedArt,
                          title: ATStrings.createShow,
                          subtitle: ATStrings.CREATE_SHOW_DESC,
                          alphabet: 'S',
                          selectedRotationDegrees: 10.58,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: GoLiveTypeSelectionWidget(
                          onTap: (bool isSelected) => blocContext
                              .read<_PrivateBloc>()
                              .setValue(isSelected ? null : 1),
                          isSelected: state == 1,
                          unselectedImgPath: ATImgStrings.CREATE_EVENT_ICON1,
                          selectedImgPath: ATImgStrings.CREATE_EVENT_ICON2,
                          title: ATStrings.createEvent,
                          subtitle: ATStrings.CREATE_EVENT_DESC,
                          alphabet: 'E',
                          selectedRotationDegrees: -10.58,
                          selectedVerticalOffset: 39,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 50),
              child: ATPlainElevatedBtn(
                onPressed: isBtnActive
                    ? () => context.pushNamed(
                          state == 0
                              ? ATRoutes.listHostedShowsScreen
                              : ATRoutes.listHostedEventsScreen,
                        )
                    : null,
                btnTitle: ATStrings.cContinue,
                bgColor: ATColors.white,
                fgColor: ATColors.black,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ATColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _PrivateBloc extends Cubit<int?> {
  _PrivateBloc() : super(null);

  void setValue(int? value) => emit(value);
}
