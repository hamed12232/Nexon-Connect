import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/helper/cache_helper.dart';
import 'package:myapp/core/helper/cache_helper_key.dart';

part 'theme_state.dart';

enum ThemeModeState { light, dark, system }

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial()) {
    loadTheme();
  }
  // select theme mode and save
  // get current theme mode
  // load theme mode
  static ThemeCubit get(context) => BlocProvider.of(context);
  ThemeModeState currentTheme = ThemeModeState.system;

  Future<void> selectThemeMode(ThemeModeState themeMode) async {
    currentTheme = themeMode;
    await CachHelper().saveData(
      key: CacheHelperKey.themeMode,
      value: currentTheme.name,
    );
    emit(ThemeChanged());
  }

  ThemeMode getTheme() {
    switch (currentTheme) {
      case ThemeModeState.light:
        return ThemeMode.light;
      case ThemeModeState.dark:
        return ThemeMode.dark;
      case ThemeModeState.system:
        return ThemeMode.system;
    }
  }

  Future<void> loadTheme() async {
    String? value = await CachHelper().getData(key: CacheHelperKey.themeMode);
    if (value != null) {
      currentTheme = ThemeModeState.values.firstWhere(
        (element) => element.name == value,
        orElse: () => ThemeModeState.system,
      );
    }
    emit(ThemeChanged());
  }
}
