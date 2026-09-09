import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/wallet/bloc/wallet_bloc_export.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:amptive/src/shared/radio_button.dart';
import 'package:amptive/src/shared/search_filter_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';

Future<String?> selectWithdrawalBankDialog(BuildContext context) {
  final TextEditingController cntrl = TextEditingController();
  bool showCancelIcon = false;

  return showCupertinoModalPopup<String>(
    context: context,
    barrierColor: ATColors.black,
    builder: (BuildContext dialogContext) {
      return MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider(create: (_) => WithdrawalBanksBloc()),
          BlocProvider(create: (_) => SearchkeyCubit())
        ],
        child: Material(
          color: ATColors.transparent,
          child: Builder(builder: (BuildContext context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<WithdrawalBanksBloc>().add(FetchBanksEvent());
            });

            return SizedBox(
              height: context.screenHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7, 48, 15, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const ATRoundedBackBtn(),
                        Text('Bank', style: context.textTheme.bodyMedium),
                        const SizedBox(width: 30),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 8),
                    child: Text(
                      maxLines: 2,
                      'Choose your bank',
                      style: context.textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 16),
                    child: Text(
                      maxLines: 2,
                      ATStrings.selectBankDesc,
                      style: context.textTheme.bodySmall
                          ?.copyWith(color: ATColors.hexC2C2C2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                    child: StatefulBuilder(builder: (_, setter) {
                      return ATTextFormField(
                        controller: cntrl,
                        maxLines: 1,
                        fillColor: ATColors.white.withValues(alpha: 0.1),
                        hintText: ATStrings.searchForBank,
                        disableBlueBorder: true,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: ATImgLoader(
                              height: 20,
                              width: 20,
                              imgPath: ATImgStrings.outlinedSearch),
                        ),
                        suffixIcon: showCancelIcon
                            ? IconButton(
                                onPressed: () => setter(() {
                                  context
                                      .read<WithdrawalBanksBloc>()
                                      .add(ResetBanksSearchEvent());
                                  context
                                      .read<SearchkeyCubit>()
                                      .updateSearchKey('');
                                  cntrl.clear();
                                  showCancelIcon = false;
                                }),
                                icon: const Icon(
                                  Icons.close,
                                  size: 20,
                                ),
                              )
                            : null,
                        onChanged: (String text) {
                          if (text.isEmpty && showCancelIcon) {
                            setter(() => showCancelIcon = false);
                          } else if (text.isNotEmpty && !showCancelIcon) {
                            setter(() => showCancelIcon = true);
                          }
                          ATHelperFuncs.callDebouncer(500, () {
                            context
                                .read<SearchkeyCubit>()
                                .updateSearchKey(text);
                            context
                                .read<WithdrawalBanksBloc>()
                                .add(SearchBanksEvent(text));
                          });
                        },
                      );
                    }),
                  ),
                  Expanded(
                    child: LayoutBuilder(builder: (_, BoxConstraints kst) {
                      return BlocBuilder<WithdrawalBanksBloc,
                              WithdrawalBanksState>(
                          builder: (_, WithdrawalBanksState state) {
                        if (state is SearchingBanks) {
                          return const Center(child: ATLoadingIndicator());
                        }
                        if (state is WithdrawalBanksInitial) {
                          return Center(
                              child: Text(
                            ATStrings.noMatchingResults,
                            style: context.textTheme.bodyMedium,
                          ));
                        }

                        List<String>? banks;
                        String? selectedBank;
                        final bool isFetchingBanks = state is FetchingBanks;
                        if (isFetchingBanks) {
                          return const Center(child: ATLoadingIndicator());
                        }

                        final bool hasBanks = state is WithdrawalBanksData;
                        if (hasBanks) {
                          banks = state.banks;
                          selectedBank = state.selectedBank;
                        }

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          itemCount: banks?.length ?? (kst.maxHeight ~/ 40),
                          itemBuilder: (_, int index) {
                            final String? bank = banks?[index];
                            return InkWell(
                              onTap: isFetchingBanks
                                  ? null
                                  : () => context
                                      .read<WithdrawalBanksBloc>()
                                      .add(SelectBankEvent(
                                          selectedBank == bank ? null : bank)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 16, 15, 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: ATFilterWidget<SearchkeyCubit>(
                                          title: bank ?? '',
                                          style: context.textTheme.bodySmall
                                              ?.copyWith(
                                                  fontSize: ATSizes.size15)),
                                    ),
                                    const SizedBox(width: 30),
                                    ATRadioBtn(
                                      isSelected: selectedBank == bank,
                                      duration: 0,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      });
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 50),
                    child:
                        BlocBuilder<WithdrawalBanksBloc, WithdrawalBanksState>(
                            builder: (_, WithdrawalBanksState state) {
                      return ATPlainElevatedBtn(
                        onPressed: (state is WithdrawalBanksData &&
                                state.selectedBank != null)
                            ? () {
                                context.pop(state.selectedBank!);
                              }
                            : null,
                        btnTitle: ATStrings.cContinue,
                      );
                    }),
                  ),
                ],
              ),
            );
          }),
        ),
      );
    },
  );
}
