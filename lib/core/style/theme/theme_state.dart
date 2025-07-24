part of 'theme_cubit.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeChanged extends ThemeState {
  final ThemeModeState currentTheme;

  const ThemeChanged(this.currentTheme);

  @override
  List<Object> get props => [currentTheme];
}
