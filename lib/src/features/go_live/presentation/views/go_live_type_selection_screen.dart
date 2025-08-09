import 'package:amptive/src/features/go_live/presentation/views/choose_or_create_go_live_program_screen.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
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
                leading: const ATXBackBtn(), leadingWidth: 30,
                padding: const EdgeInsets.fromLTRB(7, 0, 15, 0),
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
                  children: <Widget>[
                    Text(
                      maxLines: 3,
                      ATStrings.CHOOSE_2_CREATE_SHOW_OR_EVENT,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ATColors.hexC2C2C2
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: GoLiveTypeSelectionWidget(
                            onTap: (bool isSelected) => blocContext.read<_PrivateBloc>().setValue(
                              isSelected ? null : 0
                            ),
                            isSelected: state == 0,
                            unselectedImgPath: ATImgStrings.CREATE_SHOW_ICON1,
                            selectedImgPath: ATImgStrings.CREATE_SHOW_ICON2,
                            title: ATStrings.CREATE_SHOW,
                            subtitle: ATStrings.CREATE_SHOW_DESC,
                            alphabet: 'S',
                          ),
                        ),
                        const SizedBox(width: 15,),
                        Expanded(
                          child: GoLiveTypeSelectionWidget(
                            onTap: (bool isSelected) => blocContext.read<_PrivateBloc>().setValue(
                              isSelected ? null : 1
                            ),
                            isSelected: state == 1,
                            unselectedImgPath: ATImgStrings.CREATE_EVENT_ICON1,
                            selectedImgPath: ATImgStrings.CREATE_EVENT_ICON2,
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
              
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 30),
                child: ATPlainElevatedBtn(
                  onPressed: isBtnActive ? () => context.pushNamed(
                    ATRoutes.CHOOSE_OR_CREATE_GO_LIVE_PROGRAM_SCREEN,
                    extra: state == 0 ? GoLiveProgramType.show : GoLiveProgramType.event,
                  ) : null,
                  btnTitle: ATStrings.CONTINUE,
                  bgColor: ATColors.white,
                  fgColor: ATColors.black,
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}

class _PrivateBloc extends Cubit<int?>{
  _PrivateBloc(): super(null);

  void setValue(int? value) => emit(value);
}