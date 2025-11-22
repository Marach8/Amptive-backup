import 'package:amptive/src/features/discover/presentation/views/discover_landing_screen.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import '../../../../views/widgets/common_widgets/textformfield_widget.dart';

class ATDiscoverSearchField extends StatefulWidget {
  const ATDiscoverSearchField({super.key});

  @override
  State<ATDiscoverSearchField> createState() => _ATDiscoverSearchFieldState();
}

class _ATDiscoverSearchFieldState extends State<ATDiscoverSearchField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  bool _hasFocus = false;
  bool _hasInput = false;

  @override 
  void initState(){
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocus);
    _controller = TextEditingController()..addListener(_handleTextInput);
  }

  void _handleFocus(){
    if(_focusNode.hasFocus){
      setState(() => _hasFocus = true);
      if(mounted){
        context.read<DiscoverTrnstnBlc>().showRecentSearches();
      }
    }
    else{
      setState(() => _hasFocus = false);
      context.read<DiscoverTrnstnBlc>().reset();
    }
  }

  void _handleTextInput(){
    if(_controller.text.isNotEmpty){
      setState(() => _hasInput = true);
      Future<void>.delayed(
        const Duration(seconds: 2),
        (){
          if(mounted){
            context.read<DiscoverTrnstnBlc>().showSearchResults();
          }
        }
      );
    }
    else{
      setState(() => _hasInput = false);
      context.read<DiscoverTrnstnBlc>().reset();
    }
  }

  @override
  void dispose(){
    _focusNode.removeListener(_handleFocus);
    _focusNode.dispose();
    _controller.removeListener(_handleTextInput);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      color: ATColors.black, height: 60,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ATTextFormField(
                focusNode: _focusNode,
                controller: _controller,
                disableBlueBorder: true,
                isDense: true,
                cursorHeight: 20, maxLines: 1,
                cursorColor: ATColors.white.withValues(alpha: 0.6),
                contentPadding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                hintText: ATStrings.SEARCH_FOR_EVENTS_ND_SHOWS,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(ATColors.white, BlendMode.srcATop),
                    child: const ATImgLoader(
                      height: 25, width: 25,
                      imgPath: ATImgStrings.OUTLINED_SEARCH,
                    ),
                  ),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10,),
                  child: ATAnimatedXFade(
                    condition: _hasInput,
                    secondChild: const SizedBox.shrink(),
                    firstChild: GestureDetector(
                      onTap: () => _controller.clear(),
                      child: Icon(Icons.close, size: 20, color: ATColors.white)
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10,),
            ATAnimatedXFade(
              condition: _hasFocus,
              secondChild: const SizedBox.shrink(),
              firstChild: InkWell(
                onTap: () => _focusNode.unfocus(),
                child: Text(
                  ATStrings.cancel,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
