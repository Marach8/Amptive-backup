import 'package:amptive/src/global_export.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DotIndicatorRow extends StatelessWidget {
  const DotIndicatorRow({super.key, required this.pageCntrl});
  final PageController pageCntrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Opacity(
            opacity: 0.0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
              child: Text(
                ATStrings.apply,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          SmoothPageIndicator(
            controller: pageCntrl,
            count: 3,
            onDotClicked: (int index) => pageCntrl.animateToPage(index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.decelerate),
            effect: ExpandingDotsEffect(
              dotHeight: 10,
              dotWidth: 10,
              spacing: 3,
              activeDotColor: ATColors.hexD9D9D9,
              dotColor: ATColors.hex5B5B5B,
            ),
          ),
          ListenableBuilder(
              listenable: pageCntrl,
              builder: (_, __) {
                final bool isLast = pageCntrl.page == 2;
                return ATContainer(
                  onTap: () {
                    isLast
                        ? context.pushNamed(ATRoutes.postOnboardingScreen)
                        : pageCntrl.animateToPage(2,
                            duration: const Duration(seconds: 1),
                            curve: Curves.decelerate);
                  },
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                  color: ATColors.hex307FE2,
                  radius: 30,
                  child: Text(
                    isLast ? ATStrings.next : ATStrings.SKIP,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              })
        ],
      ),
    );
  }
}
