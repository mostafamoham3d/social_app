import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/app_states.dart';
import 'package:social_app/helpers/shared_prefs.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppState());
  static AppCubit get(context) => BlocProvider.of(context);
  bool isDark = false;
  void changeTheme() {
    isDark = !isDark;
    SharedPrefs.saveTheme(isDark);
    emit(ChangeAppThemeState());
  }

  void getSavedTheme() {
    isDark = SharedPrefs.getTheme() ?? false;
    emit(ChangeAppThemeState1());
  }
}
