import 'dart:ui';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/features/main_app/wallet/bloc/recent_receipients_bloc.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/common_widgets/radio_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/search_filter_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../widgets/common_widgets/app_bar_widget.dart';
import '../../../../../widgets/common_widgets/back_button.dart';

class ATSelectRecipientScreen extends StatefulWidget {
  const ATSelectRecipientScreen({super.key});

  @override
  State<ATSelectRecipientScreen> createState() => _ATSelectRecipientScreenState();
}

class _ATSelectRecipientScreenState extends State<ATSelectRecipientScreen> {
  bool showCancelIcon = false;
  late final TextEditingController _cntrl;

  @override 
  void initState(){
    super.initState();
    _cntrl = TextEditingController();
  }

  @override
  void dispose(){
    _cntrl.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext _) {
    return ATAnnotatedRegion(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => RecentRecipientsBloc()),
          BlocProvider(create: (_) => SearchkeyBloc())
        ],
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: const ATAppBar(
                leading: ATRoundedBackBtn(),
                leadingWidth: 30,
                padding: EdgeInsets.only(left: 7),
                titleText: ATStrings.TRANSFER_FUNDS,
              ),
            
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                      child: StatefulBuilder(
                        builder: (_, setter) {
                          return ATTextFormField(
                            controller: _cntrl,
                            fillColor: ATColors.white.withValues(alpha: 0.1),
                            hintText: ATStrings.SEARCH_4_USER,
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 10, right: 5),
                              child: Icon(Iconsax.search_normal_14, size: 20,),
                            ),
                            suffixIcon: showCancelIcon ? IconButton(
                              onPressed: () => setter(
                                (){
                                  context.read<RecentRecipientsBloc>().add(ResetRecipientsEvent());
                                  _cntrl.clear(); showCancelIcon = false;
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
                                  context.read<RecentRecipientsBloc>().add(
                                    SearchRecentRecipients(text)
                                  );
                                }
                              );
                            },
                          );
                        }
                      ),
                    ),

                
                    BlocBuilder<RecentRecipientsBloc, RecentRecipientsState>(
                      builder: (_, state) {
                        switch (state){
                          case RecentRecipientsInitial _:
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ATStrings.NO_RECENT_RECEPIENT,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: ATFontSizes.size14
                                    ),
                                  ),
                                  Text(
                                    ATStrings.TRY_SEARCHING_4_USER, maxLines: 2,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: ATColors.hexC2C2C2
                                    ),
                                  )
                                ],
                              ),
                            );
                
                          case RecentRecipientsLoading _:
                            return const Center(child: ATLoadingIndicator());
                
                          case RecentRecipientsData _:
                            return Column(
                              children: state.recipients.map(
                                (recipient) => _UserWithTrailingRadio(user: recipient)
                              ).toList(),
                            );
                        
                          default: return const SizedBox.shrink();
                        }
                      }
                    ),
                    const SizedBox(height: 100,),
                  ],
                ),
              ),
              bottomSheet: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                    child: BlocBuilder<RecentRecipientsBloc, RecentRecipientsState>(
                      builder: (_, state) {
                        return ATPlainElevatedBtn(
                          onPressed: (state is RecentRecipientsData && state.selectedRecipient != null) ? () async{
                            final recipient = state.selectedRecipient!;
                            final shouldProceed = await context.pushNamed(
                              ATRoutes.ENTER_AMOUNT_2_TRSF,
                              extra: (1, recipient, null, null)
                            ) as bool?;

                            if((context.mounted) && (shouldProceed ?? false)){
                              context.pushReplacementNamed(
                                ATRoutes.PAPER_PLANE_SUCCESS,
                                extra: [ATStrings.TRSF_SUCCESS, '${ATStrings.TRSF_SUCCESS_DESC}${recipient.obj.username}']
                              );
                            }
                          } : null,
                          btnTitle: ATStrings.ENTER_AMT,
                        );
                      }
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}




class _UserWithTrailingRadio extends StatelessWidget {
  final ObjectWithNotifier<Host> user;

  const _UserWithTrailingRadio({required this.user});

  @override
  Widget build(context) {
    return InkWell(
      onTap: () => context.read<RecentRecipientsBloc>().add(SelectRecipient(user)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
          children: [
            ATContainer(
              clipBehavior: Clip.hardEdge,
              height: 50, width: 50, radius: 30,
              child: FittedBox(
                fit: BoxFit.fill,
                child: ATImgLoader(imgPath: user.obj.profilePicture!)
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ATFilterWidget<SearchkeyBloc>(
                    title: user.obj.name ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: ATFontSizes.size15
                    )
                  ),
                  Text(
                    user.obj.username ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ATColors.hexC2C2C2
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<RecentRecipientsBloc, RecentRecipientsState>(
              builder: (_, state) {
                final recipient = (state as RecentRecipientsData).selectedRecipient;
                final isSelected = recipient != null && recipient.obj.name == user.obj.name;
                return ATRadioButton(isSelected: isSelected);
              }
            )
          ],
        ),
      ),
    );
  }
}


class SearchkeyBloc extends Cubit<String>{
  SearchkeyBloc() : super('');

  void updateSearchKey(String searchKey) => emit(searchKey);
}