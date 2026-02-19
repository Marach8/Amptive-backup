import 'package:amptive/src/features/auth/presentation/screens/auth_options_screen.dart' show AuthType;
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:go_router/go_router.dart';
import '../../../../views/widgets/common_widgets/image_loader_widget.dart';


class ATPostOnboardingScreen extends StatelessWidget {
  const ATPostOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ATAnnotatedRegion(
      child: Scaffold(
        body: Center(
          child: ATScrollBar(child: _SubWidget(),),
        ),
      )
    );
  }
}


class _SubWidget extends StatelessWidget {
  const _SubWidget();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: true, 
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const ATImgLoader(imgPath: ATImgStrings.AMPTIVE_LOGO),
          const SizedBox(height: 80,),
    
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TestWidget(imgPath: ATImgStrings.jpeg2,),
                TestWidget(imgPath: ATImgStrings.jpeg1,),
                TestWidget(imgPath: ATImgStrings.jpeg3,),  
              ],
            ),
          ),
          
          const SizedBox(height: 80,),
    
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              ATStrings.monetizeLiveAudioShowsAndEvents,
              textAlign: TextAlign.center, maxLines: 2,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
    
          const SizedBox(height: 30,),
    
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ATPlainElevatedBtn(
              onPressed: () => context.pushNamed(ATRoutes.AUTH_OPTIONS_SCREEN, extra: AuthType.signUp),
              btnTitle: ATStrings.SIGN_UP,
            ),
          ),
    
          const SizedBox(height: 15,),
    
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ATOutlinedBtn(
              onPressed: () => context.pushNamed(ATRoutes.AUTH_OPTIONS_SCREEN, extra: AuthType.signIn),
              btnTitle: ATStrings.SIGN_IN,
            ),
          ),
    
          const SizedBox(height: 10,),
          TextButton(
            onPressed: (){},
            child: const Text(ATStrings.attendAsGuest)
          )
        ]
      ),
    );
  }
}
