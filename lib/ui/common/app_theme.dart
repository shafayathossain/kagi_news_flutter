import "package:flutter/material.dart";

class AppTheme {
  final TextTheme textTheme;
  List<ExtendedColor> get extendedColors => [];

  const AppTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      inversePrimary: Color(0xff765a18),
      primary: Color(0xffeabd60),
      surfaceTint: Color(0xff765a18),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffd889),
      onPrimaryContainer: Color(0xff795d1a),
      secondary: Color(0xff6c5c3e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfff3ddb7),
      onSecondaryContainer: Color(0xff706142),
      tertiary: Color(0xff586428),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffd6e49a),
      onTertiaryContainer: Color(0xff5a662a),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f2),
      inverseSurface: Color(0xff34302a),
      onSurface: Color(0xff1e1b16),
      onSurfaceVariant: Color(0xff4d4639),
      outline: Color(0xff7f7667),
      outlineVariant: Color(0xffd0c5b4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),

      primaryFixed: Color(0xffffdfa0),
      onPrimaryFixed: Color(0xff261a00),
      primaryFixedDim: Color(0xffe7c275),
      onPrimaryFixedVariant: Color(0xff5c4300),
      secondaryFixed: Color(0xfff5e0ba),
      onSecondaryFixed: Color(0xff241a03),
      secondaryFixedDim: Color(0xffd8c49f),
      onSecondaryFixedVariant: Color(0xff534529),
      tertiaryFixed: Color(0xffdcea9f),
      onTertiaryFixed: Color(0xff181e00),
      tertiaryFixedDim: Color(0xffc0cd86),
      onTertiaryFixedVariant: Color(0xff414b12),
      surfaceDim: Color(0xffe1d9d0),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffbf2e9),
      surfaceContainer: Color(0xfff5ede3),
      surfaceContainerHigh: Color(0xffefe7de),
      surfaceContainerHighest: Color(0xffe9e1d8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff473300),
      surfaceTint: Color(0xff765a18),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff866925),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff41341a),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff7b6b4c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff303a02),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff667335),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f2),
      onSurface: Color(0xff14110c),
      onSurfaceVariant: Color(0xff3c3529),
      outline: Color(0xff595144),
      outlineVariant: Color(0xff756c5d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff34302a),
      inversePrimary: Color(0xffe7c275),
      primaryFixed: Color(0xff866925),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff6b510d),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff7b6b4c),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff625336),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff667335),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4e5a1f),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffcdc5bd),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffbf2e9),
      surfaceContainer: Color(0xffefe7de),
      surfaceContainerHigh: Color(0xffe3dcd3),
      surfaceContainerHighest: Color(0xffd8d0c8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3a2900),
      surfaceTint: Color(0xff765a18),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff5f4501),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff362a11),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff55472b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff273000),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff434e14),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f2),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff322b1f),
      outlineVariant: Color(0xff50483b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff34302a),
      inversePrimary: Color(0xffe7c275),
      primaryFixed: Color(0xff5f4501),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff433000),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff55472b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff3d3117),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff434e14),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff2d3700),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbfb8af),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8efe6),
      surfaceContainer: Color(0xffe9e1d8),
      surfaceContainerHigh: Color(0xffdbd3ca),
      surfaceContainerHighest: Color(0xffcdc5bd),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff8f3),
      surfaceTint: Color(0xffe7c275),
      onPrimary: Color(0xff402d00),
      primaryContainer: Color(0xffffd889),
      onPrimaryContainer: Color(0xff795d1a),
      secondary: Color(0xffd8c49f),
      onSecondary: Color(0xff3b2f15),
      secondaryContainer: Color(0xff55472b),
      onSecondaryContainer: Color(0xffcab692),
      tertiary: Color(0xfff5ffc5),
      onTertiary: Color(0xff2b3400),
      tertiaryContainer: Color(0xffd6e49a),
      onTertiaryContainer: Color(0xff5a662a),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff16130e),
      onSurface: Color(0xffe9e1d8),
      onSurfaceVariant: Color(0xffd0c5b4),
      outline: Color(0xff998f80),
      outlineVariant: Color(0xff4d4639),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe9e1d8),
      inversePrimary: Color(0xff765a18),
      primaryFixed: Color(0xffffdfa0),
      onPrimaryFixed: Color(0xff261a00),
      primaryFixedDim: Color(0xffe7c275),
      onPrimaryFixedVariant: Color(0xff5c4300),
      secondaryFixed: Color(0xfff5e0ba),
      onSecondaryFixed: Color(0xff241a03),
      secondaryFixedDim: Color(0xffd8c49f),
      onSecondaryFixedVariant: Color(0xff534529),
      tertiaryFixed: Color(0xffdcea9f),
      onTertiaryFixed: Color(0xff181e00),
      tertiaryFixedDim: Color(0xffc0cd86),
      onTertiaryFixedVariant: Color(0xff414b12),
      surfaceDim: Color(0xff16130e),
      surfaceBright: Color(0xff3d3932),
      surfaceContainerLowest: Color(0xff110e09),
      surfaceContainerLow: Color(0xff1e1b16),
      surfaceContainer: Color(0xff221f1a),
      surfaceContainerHigh: Color(0xff2d2924),
      surfaceContainerHighest: Color(0xff38342e),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff8f3),
      surfaceTint: Color(0xffe7c275),
      onPrimary: Color(0xff402d00),
      primaryContainer: Color(0xffffd889),
      onPrimaryContainer: Color(0xff594100),
      secondary: Color(0xffefdab4),
      onSecondary: Color(0xff2f240b),
      secondaryContainer: Color(0xffa08f6d),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff5ffc5),
      onTertiary: Color(0xff2b3400),
      tertiaryContainer: Color(0xffd6e49a),
      onTertiaryContainer: Color(0xff3e4910),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff16130e),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffe7dbc9),
      outline: Color(0xffbbb0a0),
      outlineVariant: Color(0xff998f7f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe9e1d8),
      inversePrimary: Color(0xff5d4400),
      primaryFixed: Color(0xffffdfa0),
      onPrimaryFixed: Color(0xff191000),
      primaryFixedDim: Color(0xffe7c275),
      onPrimaryFixedVariant: Color(0xff473300),
      secondaryFixed: Color(0xfff5e0ba),
      onSecondaryFixed: Color(0xff191000),
      secondaryFixedDim: Color(0xffd8c49f),
      onSecondaryFixedVariant: Color(0xff41341a),
      tertiaryFixed: Color(0xffdcea9f),
      onTertiaryFixed: Color(0xff0e1300),
      tertiaryFixedDim: Color(0xffc0cd86),
      onTertiaryFixedVariant: Color(0xff303a02),
      surfaceDim: Color(0xff16130e),
      surfaceBright: Color(0xff48443d),
      surfaceContainerLowest: Color(0xff090704),
      surfaceContainerLow: Color(0xff201d18),
      surfaceContainer: Color(0xff2b2722),
      surfaceContainerHigh: Color(0xff36322c),
      surfaceContainerHighest: Color(0xff413d37),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff8f3),
      surfaceTint: Color(0xffe7c275),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffd889),
      onPrimaryContainer: Color(0xff332400),
      secondary: Color(0xffffeed2),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffd4c09c),
      onSecondaryContainer: Color(0xff110a00),
      tertiary: Color(0xfff5ffc5),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffd6e49a),
      onTertiaryContainer: Color(0xff212900),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff16130e),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfffbeedc),
      outlineVariant: Color(0xffccc1b0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe9e1d8),
      inversePrimary: Color(0xff5d4400),
      primaryFixed: Color(0xffffdfa0),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffe7c275),
      onPrimaryFixedVariant: Color(0xff191000),
      secondaryFixed: Color(0xfff5e0ba),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffd8c49f),
      onSecondaryFixedVariant: Color(0xff191000),
      tertiaryFixed: Color(0xffdcea9f),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffc0cd86),
      onTertiaryFixedVariant: Color(0xff0e1300),
      surfaceDim: Color(0xff16130e),
      surfaceBright: Color(0xff544f49),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff221f1a),
      surfaceContainer: Color(0xff34302a),
      surfaceContainerHigh: Color(0xff3f3b35),
      surfaceContainerHighest: Color(0xff4a4640),
    );
  }
  

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

}

class ExtendedColor {
  final Color seed;
  final Color value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;

  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });
}
