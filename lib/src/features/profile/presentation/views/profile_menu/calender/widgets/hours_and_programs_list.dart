import 'package:amptive/src/bloc/main_app/profile/profile_menu/calender/calender_programs_bloc.dart';
import 'package:amptive/src/bloc/main_app/profile/profile_menu/calender/day_view_bloc.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/common_widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../calender_export.dart' show CalenderProgramDisplay;



class HoursAndProgramsList extends StatelessWidget {
  const HoursAndProgramsList({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HoursInADayBloc, HoursInADayState?>(
      builder: (_, HoursInADayState? state) {
        if(state == null) return const SizedBox.shrink();
        if(!state.$1) return const Center(child: ATLoadingIndicator(size: 30));

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 15),
          itemCount: state.$2.length,
          itemBuilder: (_, int index) {
            final String formattedTime = state.$2.elementAt(index);
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      formattedTime, 
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: ATFontSizes.size11,
                        color: ATColors.hexC2C2C2
                      )
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Divider(color: ATColors.white.withValues(alpha: 0.2), height: 0,)
                    ),
                  ],
                ),
                BlocBuilder<CalenderProgramBloc, ProgramsState>(
                  builder: (_, ProgramsState state) {
                    final bool isLoading = state is ProgramsLoadingState;
                    final bool hasError = state is ProgramsErrorState;
                    final bool initialState = state is NoProgramsState;
        
                    if(initialState) return const SizedBox(height: 30);
                    if(isLoading) return const ATShimmer(margin: EdgeInsets.only(left: 58));
                    if(hasError) return const Text('Error occured');
        
                    final ProgramsDataState programs = state as ProgramsDataState;
                    final List<CalenderProgram>? listOfProgs = programs.programs[formattedTime];
        
                    if(listOfProgs == null) return const SizedBox(height: 30);
                                  
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5,
                      children: listOfProgs.map(
                        (CalenderProgram program) => CalenderProgramDisplay(program: program),
                      ).toList()
                    );
                  }
                ),
              ],
            );
          },
        );
      }
    );
  }
}