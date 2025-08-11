import 'dart:async';
import 'dart:ui';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/dismiss_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Future<String?> enterDescriptionModal({
  required BuildContext context,
  String? initialDesc
}) async{
  return await showModalBottomSheet<String>(
    backgroundColor: ATColors.black.withValues(alpha: 0.1),
    constraints: BoxConstraints.expand(height: context.screenHeight),
    context: context,
    isScrollControlled: true,
    elevation: 0,
    builder: (_)  => BlocProvider<_PrivateBloc>(
      create: (_) => _PrivateBloc(),
      child: _DescriptionWidget(intialDesc: initialDesc)
    ),
  );
}



class _DescriptionWidget extends StatefulWidget {
  const _DescriptionWidget({this.intialDesc});
  final String? intialDesc;

  @override
  State<_DescriptionWidget> createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<_DescriptionWidget> with WidgetsBindingObserver{
  late final TextEditingController _textCntrl;
  final StreamController<double> _streamCntrl = StreamController<double>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _textCntrl = TextEditingController(text: widget.intialDesc);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _streamCntrl.close();
    _textCntrl.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final ViewPadding currentViewPadding = WidgetsBinding.instance.platformDispatcher.views.first.viewInsets;
    _streamCntrl.add(currentViewPadding.bottom);
  }


  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 150, sigmaY: 150),
      child: Column(
        children: <Widget>[
          const SizedBox(height: kToolbarHeight * 0.5),
          const ATModalDismisser(),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Opacity(
                  opacity: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                    child: Text(
                      ATStrings.DONE,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    ATStrings.DESCRIPTION,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ATContainer(
                  onTap: () => context.pop(_textCntrl.text.trim()),
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                  color: ATColors.hex307FE2, radius: 30,
                  child: Text(
                    ATStrings.DONE,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: Stack(
              children: <Widget>[
                BlocBuilder<_PrivateBloc, ({bool isBold, bool isItalic})>(
                  builder: (_, ({bool isBold, bool isItalic}) state) {
                    return TextField(
                      maxLines: 100, controller: _textCntrl,
                      keyboardType: TextInputType.multiline,
                      cursorColor: ATColors.white.withValues(alpha: 0.7),
                      style: context.textTheme.bodySmall?.copyWith(
                        fontStyle: state.isItalic ? FontStyle.italic : null,
                        fontWeight: state.isBold ? ATFontWeights.w800 : null,
                        color: ATColors.white.withValues(alpha: 0.7)
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: ATStrings.TELL_LISTENERS_ABOUT_SHOW,
                        hintStyle: context.textTheme.bodySmall?.copyWith(
                          color: ATColors.white.withValues(alpha: 0.4)
                        ),
                        contentPadding: const EdgeInsets.all(15),
                      ),
                    );
                  }
                ),
                StreamBuilder<double>(
                  stream: _streamCntrl.stream,
                  builder: (_, AsyncSnapshot<double> snapshot) {   
                    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
                    final double height = (snapshot.data ?? 0.0) > 0 ? keyboardHeight : -50.0;
                    return AnimatedPositioned(
                      left: 0, right: 0, bottom: height,
                      duration: const Duration(milliseconds: 100),
                      child: ATContainer(
                        color: ATColors.hex48484A,
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: BlocBuilder<_PrivateBloc, ({bool isBold, bool isItalic})>(
                          builder: (_, ({bool isBold, bool isItalic}) state) {
                            return Row(
                              children: <Widget>[
                                ATContainer(
                                  onTap: () => context.read<_PrivateBloc>().toggleBold(),
                                  width: 20, alignment: Alignment.center,
                                  child: Text(
                                    'B',
                                    style: context.textTheme.headlineMedium?.copyWith(
                                      fontWeight: state.isBold ? null : ATFontWeights.w300
                                    )
                                  ),
                                ),
                                const SizedBox(width: 35,),
                                ATContainer(
                                  onTap: () => context.read<_PrivateBloc>().toggleItalic(),
                                  padding: const EdgeInsets.all(3),
                                  height: 18, width: 18,
                                  child: CustomPaint(
                                    painter: _ItalicIPainter(
                                      color: ATColors.white,
                                      strokeWidth: state.isItalic ? 3 : 1
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 40,),
                                ATContainer(
                                  onTap: ()async{
                                    final (String, String)? linkData = await addLinkModal(context: context);
                                    if(linkData != null){}
                                  },
                                  width: 20, height: 20, alignment: Alignment.center,
                                  child: const Icon(CupertinoIcons.link, size: 18,),
                                )
                              ],
                            );
                          }
                        ),
                      )
                    );
                  }
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _PrivateBloc extends Cubit<({bool isBold, bool isItalic})> {
  _PrivateBloc() : super((isBold: false, isItalic: false));

  void toggleBold() => emit((isBold: !state.isBold, isItalic: state.isItalic));

  void toggleItalic() => emit((isBold: state.isBold, isItalic: !state.isItalic));
}


class _ItalicIPainter extends CustomPainter {
  _ItalicIPainter({
    required this.color,
    required this.strokeWidth
  });
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double centerX1 = 2 * (size.width) / 3;
    final double centerX2 = size.width / 3;

    canvas.drawLine(
      Offset(centerX1, 0),
      Offset(centerX2, size.height),
      paint,
    );

    final Path topPath = Path()
      ..moveTo(centerX2, 0)
      ..lineTo(size.width, 0);
    canvas.drawPath(topPath, paint);

    final Path bottomPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(centerX1, size.height);
    canvas.drawPath(bottomPath, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
