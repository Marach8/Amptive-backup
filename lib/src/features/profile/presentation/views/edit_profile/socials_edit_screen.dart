import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';


class EditSocialsScreen  extends StatefulWidget {
  const EditSocialsScreen ({
    super.key,
    required this.initialLink,
    required this.socialName
  });
  final String? initialLink;
  final String socialName;

  @override
  State<EditSocialsScreen > createState() => _EditSocialsScreenState();
}

class _EditSocialsScreenState extends State<EditSocialsScreen> {
  late final TextEditingController _cntrl;
  bool btnActive = false;

  @override 
  void initState(){
    super.initState();
    _cntrl = TextEditingController(text: widget.initialLink)
      ..addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final bool isDifferent = _cntrl.text.isNotEmpty && 
      (_cntrl.text.trim() != widget.initialLink);
    if (btnActive != isDifferent) {
      setState(() => btnActive = isDifferent);
    }
  }

  @override
  void dispose(){
    _cntrl.removeListener(_handleTextChange);
    _cntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget prefix = const SizedBox.shrink();
    String hintText = '';

    if(widget.socialName == ATStrings.WEBSITE){
      hintText = ATStrings.enterLink(widget.socialName.toLowerCase());
    }
    hintText = ATStrings.enterLink('${widget.socialName} ${ATStrings.PROFILE.toLowerCase()}');

    switch(widget.socialName){
      case ATStrings.INSTAGRAM:
        prefix = Icon(Iconsax.instagram, color: ATColors.white, size: 20);
      case ATStrings.X:
        prefix = const ATImgLoader(imgPath: ATImgStrings.X_LOGO);
      case ATStrings.LINKEDIN:
        prefix = FaIcon(FontAwesomeIcons.linkedin, color: ATColors.white, size: 20);
      case ATStrings.WEBSITE:
        prefix = Transform.rotate(
          angle: -0.9,
          child: Icon(Icons.insert_link, color: ATColors.white, size: 20),
        );
    }

    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: ATAppBar(
          leadingWidth: 30,
          padding: const EdgeInsets.only(left: 7),
          leading: const ATRoundedBackBtn(),
          titleText: widget.socialName
        ),
        body: ATTextFormField(
          controller: _cntrl,
          maxLines: null, maxLength: 100,
          disableBlueBorder: true,
          cursorHeight: 20,
          hintText: hintText,
          fillColor: ATColors.trsprnt,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: prefix,
          ),
          buildCounter: (
            BuildContext context, {
            required int currentLength,
            required bool isFocused,
            required int? maxLength,
          }) => Text(
            '${maxLength! - currentLength} remaining',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: ATFontSizes.size11
            )
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
          child: ATPlainElevatedBtn(
            onPressed: btnActive ? () => context.pop(_cntrl.text.trim()) : null,
            btnTitle: widget.initialLink == null ? ATStrings.ADD_LINK
              : ATStrings.ACCEPT_CHANGES
          ),
        ),
      ),
    );
  }
}
