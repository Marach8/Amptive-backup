import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import '../../../../views/widgets/common_widgets/textformfield_widget.dart';


class SearchFieldWithXSuffix extends StatefulWidget {
  const SearchFieldWithXSuffix({
    super.key,
    required this.onChanged,
    required this.hintText,
    this.onClear,
  });

  final void Function(String) onChanged;
  final VoidCallback? onClear;
  final String hintText;

  @override
  State<SearchFieldWithXSuffix> createState() => _SearchFieldWithXSuffixState();
}

class _SearchFieldWithXSuffixState extends State<SearchFieldWithXSuffix> {
  late TextEditingController _controller;
  bool _hasInput = false;

  @override 
  void initState(){
    super.initState();
    _controller = TextEditingController()..addListener(_handleTextInput);
  }

  void _handleTextInput(){
    if(_controller.text.isNotEmpty && !_hasInput){
      setState(() => _hasInput = true);
    }
    else if (_controller.text.isEmpty && _hasInput){
      setState(() => _hasInput = false);
    }
  }

  @override
  void dispose(){
    _controller.removeListener(_handleTextInput);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ATTextFormField(
      controller: _controller,
      disableBlueBorder: true,
      isDense: true,
      onChanged: widget.onChanged,
      cursorHeight: 20, maxLines: 1,
      cursorColor: ATColors.white.withValues(alpha: 0.6),
      contentPadding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      hintText: widget.hintText,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: ATColors.trsprnt)
      ),
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
        child: ATAnimatedCrossFade(
          condition: _hasInput,
          secondChild: const SizedBox.shrink(),
          firstChild: GestureDetector(
            onTap: (){
              _controller.clear();
              if(widget.onClear != null){
                widget.onClear!();
              }
            },
            child: Icon(Icons.close, size: 20, color: ATColors.white)
          ),
        ),
      ),
    );
  }
}
