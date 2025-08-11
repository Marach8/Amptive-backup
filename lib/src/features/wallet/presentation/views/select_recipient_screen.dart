import 'dart:ui';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/dialogs/wallet/enter_pin_dialog.dart' show inputTxnPinDialog;
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/features/wallet/bloc/recent_receipients_bloc.dart';
import 'package:amptive/src/features/wallet/presentation/views/enter_amount_screen.dart' show EnterAmountScreenParams;
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/common_widgets/radio_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/search_filter_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import '../../../../views/widgets/common_widgets/app_bar_widget.dart';

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
        providers: <SingleChildWidget>[
          BlocProvider(create: (_) => RecentRecipientsBloc()),
          BlocProvider(create: (_) => SearchkeyBloc())
        ],
        child: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: SafeArea(
                child: NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (_, __) => <Widget>[
                    const ATSliverAppBar(titleText: ATStrings.TRANSFER_FUNDS,),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: ATSliverHDelegate(
                        maxExt: 70, minExt: 70, 
                        child: Container(
                          height: 70,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
                          child: StatefulBuilder(
                            builder: (_, setter) {
                              return ATTextFormField(
                                controller: _cntrl, maxLines: 1,
                                hintText: ATStrings.SEARCH_4_USER,
                                suffixIcon: showCancelIcon ? IconButton(
                                  onPressed: () => setter(
                                    (){
                                      context.read<RecentRecipientsBloc>().add(ResetRecipientsEvent());
                                      _cntrl.clear(); showCancelIcon = false;
                                    }
                                  ),
                                  icon: const Icon(Icons.close, size: 20,),
                                ) : null,
                                onChanged: (String text){
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
                        )
                      ),
                    )
                  ],
                  body: BlocBuilder<RecentRecipientsBloc, RecentRecipientsState>(
                    builder: (_, RecentRecipientsState state) {
                      switch (state){
                        case RecentRecipientsInitial _:
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
                            itemCount: state.recipients.length,
                            itemBuilder: (_, int index){
                              final ObjectWithNotifier<Host> recipient = state.recipients.elementAt(index);
                              return _UserWithTrailingRadio(user: recipient);
                            },
                          );
                      
                        default: return const SizedBox.shrink();
                      }
                    }
                  ),
                ),
              ),
              
              bottomSheet: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                    child: BlocBuilder<RecentRecipientsBloc, RecentRecipientsState>(
                      builder: (_, RecentRecipientsState state) {
                        return ATPlainElevatedBtn(
                          onPressed: (state is RecentRecipientsData && state.selectedRecipient != null) ? () async{
                            final ObjectWithNotifier<Host> recipient = state.selectedRecipient!;
                            final String? trsfAmount = await context.pushNamed(
                              ATRoutes.ENTER_AMOUNT_2_TRSF,
                              extra: EnterAmountScreenParams(
                                title: '${ATStrings.TRANSFER_FUNDS} to ${recipient.obj.name ?? ''}',
                                slidingNotif: ATStrings.AMPTIVE_TRNSF_CHARGES,
                                btnTitle: ATStrings.ENTER_PIN
                              )
                            ) as String?;

                            if(context.mounted && trsfAmount != null){
                              final bool? shouldProceed = await inputTxnPinDialog(context: context, object: recipient);
                              if(context.mounted && (shouldProceed ?? false)){
                                context.pop(recipient.obj.username);
                              }
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

  const _UserWithTrailingRadio({required this.user});
  final ObjectWithNotifier<Host> user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<RecentRecipientsBloc>().add(SelectRecipient(user)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
          children: <Widget>[
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
                children: <Widget>[
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
              builder: (_, RecentRecipientsState state) {
                final ObjectWithNotifier<Host>? recipient = (state as RecentRecipientsData).selectedRecipient;
                final bool isSelected = recipient != null && recipient.obj.name == user.obj.name;
                return ATRadioBtn(isSelected: isSelected);
              }
            )
          ],
        ),
      ),
    );
  }
}
