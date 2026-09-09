import 'dart:async' show StreamController;

import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UpdateNameScreen extends StatefulWidget {
  const UpdateNameScreen({super.key, required this.title});
  final String title;

  @override
  State<UpdateNameScreen> createState() => _UpdateNameScreenState();
}

class _UpdateNameScreenState extends State<UpdateNameScreen> with ATValidators {
  final TextEditingController _controller = TextEditingController();
  final StreamController<bool> _activateButtonCntrl = StreamController<bool>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      ATHelperFuncs.callDebouncer(
        500,
        () => _activateButtonCntrl.add(
          validateField(_controller.text) == null,
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _activateButtonCntrl.close();
    ATHelperFuncs.disposeDebouncer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: ATAppBar(
          leadingWidth: 30,
          padding: const EdgeInsets.only(left: 7),
          leading: const ATRoundedBackBtn(),
          titleText: widget.title,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ATTextFormField(
                controller: _controller,
                hintText: 'Enter your name',
                keyboardType: TextInputType.name,
                prefixIcon: const SizedBox(width: 10),
              ),
            ],
          ),
        ),
        bottomSheet: Builder(
          builder: (BuildContext context) {
            final double bottom = MediaQuery.viewInsetsOf(context).bottom;
            final double bottomPadding = bottom == 0 ? 60 : 15;

            return Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, bottomPadding),
              child: StreamBuilder<bool>(
                stream: _activateButtonCntrl.stream,
                builder: (_, AsyncSnapshot<bool> snapshot) {
                  final bool isActive =
                      snapshot.hasData && snapshot.data == true;

                  return ATPlainElevatedBtn(
                    onPressed: isActive
                        ? () {
                            // Update LocalUserDataCubit directly
                            final ProfileData? currentData = context
                                .read<LocalUserDataCubit>()
                                .currentUserData;
                            final ProfileData updatedData =
                                (currentData ?? const ProfileData())
                                    .copyWith(name: _controller.text.trim());
                            context
                                .read<LocalUserDataCubit>()
                                .updateUserDataLocally(updatedData);
                            context.pop(_controller.text.trim());
                          }
                        : null,
                    btnTitle: 'Save Name',
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
