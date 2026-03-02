
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/circular_image.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/main_app/go_live_bloc/host_view/cohosts_display_bloc.dart';
import '../../../../services/go_live_service/go_live_service.dart';
import '../../go_live_export.dart';



class GoLiveAudienViewControlsWidget extends StatefulWidget {
  const GoLiveAudienViewControlsWidget({super.key});

  @override
  State<GoLiveAudienViewControlsWidget> createState() => _GoLiveAudienViewControlsWidgetState();
}

class _GoLiveAudienViewControlsWidgetState extends State<GoLiveAudienViewControlsWidget> {
  late FocusNode _focusNode;
  late TextEditingController _cntrl;
  final ValueNotifier<bool> _isFocusedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _hasTextNotifier = ValueNotifier<bool>(false);

  @override 
  void initState(){
    super.initState();
    _focusNode = FocusNode()..addListener(_onFocus);
    _cntrl = TextEditingController()..addListener(_onInput);
  }

  void _onFocus() => _isFocusedNotifier.value = _focusNode.hasFocus;
  void _onInput() => _hasTextNotifier.value = _cntrl.text.isNotEmpty;

  @override 
  void dispose(){
    _focusNode.dispose();
    _isFocusedNotifier.dispose();
    _hasTextNotifier.dispose();
    _cntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ValueListenableBuilder<bool>(
          valueListenable: _isFocusedNotifier,
          builder: (_, bool isFocused, __) {
            if(isFocused){
              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: InkWell(
                  onTap: () => _focusNode.unfocus(),
                  child: ATCircularImage(
                    diameter: 35,
                    imagePath: getHostList()[3].obj.profilePicture ?? ''
                  ),
                ),
              );
            }
            
            return EachGoLiveControlBtn(
              onTap: (){
                context.read<AmptiveGoLiveSelectCoHostBloc>().hostAddCohost(getHostList()[3]);
              },
              child: Transform.flip(flipX: true, child: const Icon(Icons.reply, size: 20,),)
            );
          }
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: ATTextFormField(
              controller: _cntrl,
              disableBlueBorder: true,
              focusNode: _focusNode, counterText: '',
              keyboardType: TextInputType.multiline,
              cursorHeight: 20, maxLength: 50,
              maxLines: null, isDense: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: ATColors.transparent)
              ),
              prefixIcon: const SizedBox(width: 10,),
              fillColor: ATColors.white.withValues(alpha: 0.1),
              cursorColor: ATColors.white.withValues(alpha: 0.6),
              constraints: const BoxConstraints(maxHeight: 60),
              contentPadding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
              hintText: ATStrings.COMMENT,
            ),
          )
        ),
    
        ValueListenableBuilder<bool>(
          valueListenable: _isFocusedNotifier,
          builder: (_, bool value, __) {
            if(value){
              return ValueListenableBuilder<bool>(
                valueListenable: _hasTextNotifier,                
                builder: (_, bool value, __) {
                  return InkWell(
                    onTap: value ? (){
                      _cntrl.clear();
                      _focusNode.unfocus();
                    } : null,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.send,
                        color:value ? ATColors.white : ATColors.lightDark,
                      ),
                    ),
                  );
                }
              );
            }
    
            return const _RowOfBtns();
          }
        ),
      ]
    );
  }
}


class _RowOfBtns extends StatelessWidget {
  const _RowOfBtns();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        EachGoLiveControlBtn(
          onTap: (){
            context.read<AmptiveGoLiveSelectCoHostBloc>().hostAddCohost(getHostList()[6]);
          },
          child: const Icon(Icons.mic, size: 20),
        ),
        EachGoLiveControlBtn(
          onTap: (){
            context.read<AmptiveGoLiveSelectCoHostBloc>().hostAddCohost(getHostList()[5]);
            //showFollowHostOrCohostDialog(context: context, host: getHostList().first);
          },
          child: const ATImgLoader(
            imgPath: ATImgStrings.HAND_RAISING_ICON,
            height: 20, width: 20,
            boxFit: BoxFit.fill,
          ),
        ),
        EachGoLiveControlBtn(
          onTap: (){context.read<AmptiveGoLiveSelectCoHostBloc>().hostAddCohost(getHostList()[1]);},
          child: const ATImgLoader(imgPath: ATImgStrings.HOST_GIFT_ICON, height: 20, width: 20,),
        ),
        EachGoLiveControlBtn(
          onTap: ()async{
            context.read<AmptiveGoLiveSelectCoHostBloc>().hostAddCohost(getHostList()[2]);
          },
          margin: EdgeInsets.zero,
          child: Icon(Icons.favorite, color: ATColors.hexECO404, size: 20,),
        ),
      ],
    );
  }
}
