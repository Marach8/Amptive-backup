import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/extensions/string_extensions.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/features/main_app/wallet/bloc/wallet_bloc_export.dart';
import 'package:amptive/src/views/features/main_app/wallet/presentation/views/wallet_views_export.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_align_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/common_widgets/radio_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/search_filter_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/shimmer.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../views/features/main_app/wallet/bloc/enter_pin_bloc.dart';
import '../../../views/widgets/common_widgets/circular_image.dart';
import '../../constants/font_weights.dart';


Future<String?> selectWithdrawalBankDialog(BuildContext context) {
  final cntrl = TextEditingController();
  bool showCancelIcon = false;

  return showCupertinoModalPopup<String>(
    context: context,
    barrierColor: ATColors.black,
    builder: (dialogContext) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => WithdrawalBanksBloc()),
          BlocProvider(create: (_) => SearchkeyBloc())
        ],
        child: Material(
          color: ATColors.trsprnt,
          child: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<WithdrawalBanksBloc>().add(FetchBanksEvent());
              });

              return SizedBox(
                height: ATHelperFuncs.getScreenHeight(context),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(7, 40, 15, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const ATRoundedBackBtn(),
                          Text(
                            ATStrings.SELECT_BANK,
                            style: Theme.of(context).textTheme.bodyMedium
                          ),
                          const SizedBox(width: 30),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                      child: Text(
                        maxLines: 2,
                        ATStrings.SELECT_BANK_DESC,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ATColors.hexC2C2C2
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                      child: StatefulBuilder(
                        builder: (_, setter) {
                          return ATTextFormField(
                            controller: cntrl,
                            fillColor: ATColors.white.withValues(alpha: 0.1),
                            hintText: ATStrings.SEARCH_4_BANK,
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 10, right: 5),
                              child: Icon(Iconsax.search_normal_14, size: 20,),
                            ),
                            suffixIcon: showCancelIcon ? IconButton(
                              onPressed: () => setter(
                                (){
                                  context.read<WithdrawalBanksBloc>().add(ResetBanksSearchEvent());
                                  context.read<SearchkeyBloc>().updateSearchKey('');
                                  cntrl.clear(); showCancelIcon = false;
                                }
                              ),
                              icon: const Icon(Icons.close, size: 20,),
                            ) : null,
                            onChanged: (text){
                              if(text.isEmpty && showCancelIcon){
                                setter(() => showCancelIcon = false);
                              }
                              else if(text.isNotEmpty && !showCancelIcon){
                                setter(() => showCancelIcon = true);
                              }
                              ATHelperFuncs.callDebouncer(
                                500,
                                (){
                                  context.read<SearchkeyBloc>().updateSearchKey(text);
                                  context.read<WithdrawalBanksBloc>().add(
                                    SearchBanksEvent(text)
                                  );
                                }
                              );
                            },
                          );
                        }
                      ),
                    ),
                  
                    Expanded(
                      child: LayoutBuilder(
                        builder: (_, kst) {
                          return BlocBuilder<WithdrawalBanksBloc, WithdrawalBanksState>(
                            builder: (_, state) {
                              if(state is SearchingBanks){
                                return const Center(child: ATLoadingIndicator());
                              }
                              if(state is WithdrawalBanksInitial){
                                return Center(
                                  child: Text(
                                    ATStrings.NO_MATCHING_RESULTS,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  )
                                );
                              }
                          
                              final banks = (state as WithdrawalBanksData).banks;
                              final selectedBank = state.selectedBank;
                          
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                itemCount: banks?.length ?? (kst.maxHeight ~/ 40),
                                itemBuilder: (_, index){
                                  final bank = banks?[index];
                                  return InkWell(
                                    onTap: banks == null ? null : () => context.read<WithdrawalBanksBloc>().add(
                                      SelectBankEvent(selectedBank == bank ? null : bank)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          banks == null ? Flexible(
                                            child: ATShimmer(
                                            height: 15, margin: EdgeInsets.zero,
                                            width: ATHelperFuncs.getRandomNumber(kst.maxWidth).toDouble(),
                                            ),
                                          ) : Expanded(
                                            child: ATFilterWidget<SearchkeyBloc>(
                                              title: bank ?? '',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                fontSize: ATFontSizes.size15
                                              )
                                            ),
                                          ),
                                          const SizedBox(width: 30),
                                          banks == null ? const ATShimmer(
                                            height: 20, width: 20, radius: 15,
                                            margin: EdgeInsets.zero,
                                          ) : ATRadioButton(isSelected: selectedBank == bank, duration: 0,),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          );
                        }
                      ),
                    ),
                  
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: BlocBuilder<WithdrawalBanksBloc, WithdrawalBanksState>(
                          builder: (_, state) {
                          return ATPlainElevatedBtn(
                            onPressed: (state is WithdrawalBanksData && state.selectedBank != null) ? (){
                              context.pop(state.selectedBank!);
                            } : null,
                            btnTitle: ATStrings.CONTINUE,
                          );
                        }
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      );
    },
  );
}
