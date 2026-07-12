import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/wallet/presentation/screens/transaction_amount_screen.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ATPaperPlaneSuccessScreen extends StatelessWidget {
  const ATPaperPlaneSuccessScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.transactionType,
  });
  final String title, subtitle;
  final TransactionType transactionType;

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: BlocProvider(
        create: (_) => _SlidingPaperPlaneBloc()..kickOfPaperSliding(),
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              BlocBuilder<_SlidingPaperPlaneBloc, int?>(
                builder: (_, int? state) {
                  return LayoutBuilder(builder: (_, BoxConstraints kst) {
                    return AnimatedSlide(
                      duration: const Duration(milliseconds: 500),
                      offset: state == null
                          ? Offset(-1, kst.maxHeight / 400)
                          : Offset((kst.maxWidth / 400), -1),
                      child: const ATImgLoader(
                        height: 400,
                        width: 400,
                        imgPath: ATImgStrings.PAPER_PLANE,
                      ),
                    );
                  });
                },
              ),
              Center(
                child: BlocBuilder<_SlidingPaperPlaneBloc, int?>(
                  builder: (_, int? state) {
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: state == 1 ? 1 : 0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const ATImgLoader(
                              imgPath: ATImgStrings.PAPER_PLANE,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              title,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(fontSize: ATSizes.size23),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(subtitle,
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: ATColors.hexC2C2C2))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 50),
            child: BlocBuilder<_SlidingPaperPlaneBloc, int?>(
                builder: (_, int? state) {
              return AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                offset: state == 1 ? const Offset(0, 0) : const Offset(0, 2),
                child: ATPlainElevatedBtn(
                  onPressed: () {
                    if (transactionType == TransactionType.transfer) {
                      context.pop();
                      context.pop();
                      context.pop();
                    } else {
                      context.pop();
                      context.pop();
                      context.pop();
                      context.pop();
                    }
                  },
                  btnTitle: ATStrings.backToSite,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _SlidingPaperPlaneBloc extends Cubit<int?> {
  _SlidingPaperPlaneBloc() : super(null);

  void kickOfPaperSliding() async {
    await Future.delayed(const Duration(milliseconds: 200));
    emit(0);
    await Future.delayed(const Duration(milliseconds: 700));
    emit(1);
  }
}
