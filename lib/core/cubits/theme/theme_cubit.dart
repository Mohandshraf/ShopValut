import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false); // false = light mode

  bool get isDarkMode => state;

  void toggle() => emit(!state);
  void setDark() => emit(true);
  void setLight() => emit(false);
}
