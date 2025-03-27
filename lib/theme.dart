import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade package to version 8.1.1.
///
/// Use in [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class AppTheme {
  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
  scheme: FlexScheme.hippieBlue,
  usedColors: 1,
  surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
  blendLevel: 1,
  appBarStyle: FlexAppBarStyle.background,
  subThemesData: const FlexSubThemesData(
    interactionEffects: true,
    tintedDisabledControls: true,
    blendOnLevel: 10,
    useM2StyleDividerInM3: true,
    elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
    elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
    segmentedButtonSchemeColor: SchemeColor.primary,
    inputDecoratorSchemeColor: SchemeColor.primary,
    inputDecoratorIsFilled: true,
    inputDecoratorBackgroundAlpha: 21,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorRadius: 8.0,
    inputDecoratorUnfocusedHasBorder: false,
    inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
    popupMenuRadius: 6.0,
    popupMenuElevation: 4.0,
    alignedDropdown: true,
    dialogElevation: 3.0,
    dialogRadius: 20.0,
    drawerIndicatorSchemeColor: SchemeColor.primary,
    bottomNavigationBarMutedUnselectedLabel: false,
    bottomNavigationBarMutedUnselectedIcon: false,
    menuRadius: 6.0,
    menuElevation: 4.0,
    menuBarRadius: 0.0,
    menuBarElevation: 1.0,
    searchBarElevation: 2.0,
    searchViewElevation: 2.0,
    searchUseGlobalShape: true,
    navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
    navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
    navigationBarIndicatorSchemeColor: SchemeColor.primary,
    navigationBarBackgroundSchemeColor: SchemeColor.surfaceContainer,
    navigationBarElevation: 0.0,
    navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
    navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
    navigationRailUseIndicator: true,
    navigationRailIndicatorSchemeColor: SchemeColor.primary,
    navigationRailIndicatorOpacity: 1.00,
    navigationRailLabelType: NavigationRailLabelType.all,
  ),
  keyColors: const FlexKeyColors(
    useSecondary: true,
    useTertiary: true,
    keepPrimary: true,
  ),
  tones: FlexSchemeVariant.oneHue.tones(Brightness.light),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
  // The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
  scheme: FlexScheme.hippieBlue,
  usedColors: 1,
  surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
  blendLevel: 4,
  appBarStyle: FlexAppBarStyle.background,
  subThemesData: const FlexSubThemesData(
    interactionEffects: true,
    tintedDisabledControls: true,
    blendOnLevel: 10,
    blendOnColors: true,
    useM2StyleDividerInM3: true,
    elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
    elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
    segmentedButtonSchemeColor: SchemeColor.primary,
    inputDecoratorSchemeColor: SchemeColor.primary,
    inputDecoratorIsFilled: true,
    inputDecoratorBackgroundAlpha: 43,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorRadius: 8.0,
    inputDecoratorUnfocusedHasBorder: false,
    inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
    popupMenuRadius: 6.0,
    popupMenuElevation: 4.0,
    alignedDropdown: true,
    dialogElevation: 3.0,
    dialogRadius: 20.0,
    drawerIndicatorSchemeColor: SchemeColor.primary,
    bottomNavigationBarMutedUnselectedLabel: false,
    bottomNavigationBarMutedUnselectedIcon: false,
    menuRadius: 6.0,
    menuElevation: 4.0,
    menuBarRadius: 0.0,
    menuBarElevation: 1.0,
    searchBarElevation: 2.0,
    searchViewElevation: 2.0,
    searchUseGlobalShape: true,
    navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
    navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
    navigationBarIndicatorSchemeColor: SchemeColor.primary,
    navigationBarBackgroundSchemeColor: SchemeColor.surfaceContainer,
    navigationBarElevation: 0.0,
    navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
    navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
    navigationRailUseIndicator: true,
    navigationRailIndicatorSchemeColor: SchemeColor.primary,
    navigationRailIndicatorOpacity: 1.00,
    navigationRailLabelType: NavigationRailLabelType.all,
  ),
  keyColors: const FlexKeyColors(
    useSecondary: true,
    useTertiary: true,
  ),
  tones: FlexSchemeVariant.oneHue.tones(Brightness.dark),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
