import 'package:amptive/src/config/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ATFilterWidget<B extends BlocBase<String>> extends StatelessWidget {
  const ATFilterWidget({
    super.key,
    required this.title,
    required this.style,
    this.padLeft,
    this.padRight,
  });

  final String title;
  final TextStyle? style;
  final String? padLeft, padRight;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, String>(
      builder: (_, String state) {
        final String text = title.trim();
        final String query = state.trim();

        // Emphasize the contiguous run that matches the query (the global
        // standard), rather than colouring every letter that appears in it.
        final TextStyle? matchStyle = style?.copyWith(
          fontWeight: FontWeight.w700,
          color: ATColors.white,
        );

        final List<InlineSpan> spans = <InlineSpan>[];
        if (padLeft != null) spans.add(TextSpan(text: padLeft, style: style));

        final int matchIndex = query.isEmpty
            ? -1
            : text.toLowerCase().indexOf(query.toLowerCase());
        if (matchIndex < 0) {
          spans.add(TextSpan(text: text, style: style));
        } else {
          final int end = matchIndex + query.length;
          if (matchIndex > 0) {
            spans.add(TextSpan(
                text: text.substring(0, matchIndex), style: style));
          }
          spans.add(TextSpan(
              text: text.substring(matchIndex, end), style: matchStyle));
          if (end < text.length) {
            spans.add(TextSpan(text: text.substring(end), style: style));
          }
        }

        if (padRight != null) spans.add(TextSpan(text: padRight, style: style));

        return Text.rich(
          TextSpan(children: spans),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}

class ATSearchIcon extends StatelessWidget {
  const ATSearchIcon({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
        child: Icon(CupertinoIcons.search, size: size),
      );
}

class SearchkeyCubit extends Cubit<String> {
  SearchkeyCubit() : super('');

  void updateSearchKey(String searchKey) => emit(searchKey);

  void resetSearch() => emit('');
}
