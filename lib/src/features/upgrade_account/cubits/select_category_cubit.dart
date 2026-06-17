import 'package:bloc/bloc.dart';

typedef SelectCategoryParams = ({
  String? selectedCategory,
  String searchQuery,
});

class SelectCategoryCubit extends Cubit<SelectCategoryParams> {
  SelectCategoryCubit() : super((selectedCategory: null, searchQuery: ''));

  void selectCategory(String? category) {
    emit((selectedCategory: category, searchQuery: state.searchQuery));
  }

  void updateSearchQuery(String searchQuery) {
    emit((selectedCategory: state.selectedCategory, searchQuery: searchQuery));
  }
}
