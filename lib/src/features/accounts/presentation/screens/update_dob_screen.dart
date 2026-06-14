import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'dart:async' show StreamController;
import 'package:intl/intl.dart';

import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UpdateDOBScreen extends StatefulWidget {
  const UpdateDOBScreen({super.key, required this.title});
  final String title;

  @override
  State<UpdateDOBScreen> createState() => _UpdateDOBScreenState();
}

class _UpdateDOBScreenState extends State<UpdateDOBScreen> with ATValidators {
  final TextEditingController _controller = TextEditingController();
  final StreamController<bool> _activateButtonCntrl = StreamController<bool>();
  DateTime? selectedDOB;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      ATHelperFuncs.callDebouncer(
        500,
        () => _activateButtonCntrl.add(
          selectedDOB != null,
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

  Future<void> _selectDOBModal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDOB ??
          DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
    );
    if (picked != null) {
      setState(() {
        selectedDOB = picked;
        _controller.text = DateFormat('MMMM d y').format(picked);
      });
      _activateButtonCntrl.add(true);
    }
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
                hintText: 'Select date of birth',
                keyboardType: TextInputType.datetime,
                readOnly: true,
                maxLines: 1,
                validator: validateDOB,
                onTap: () => _selectDOBModal(context),
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
                            final String formattedDate =
                                DateFormat('yyyy-MM-dd').format(selectedDOB!);
                            final UserProfileData? currentData = context
                                .read<LocalUserDataCubit>()
                                .currentUserData;
                            final UserProfileData updatedData =
                                (currentData ?? const UserProfileData())
                                    .copyWith(dob: formattedDate);
                            context
                                .read<LocalUserDataCubit>()
                                .updateUserDataLocally(updatedData);
                            context.pop(formattedDate);
                          }
                        : null,
                    btnTitle: 'Save Date of Birth',
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
