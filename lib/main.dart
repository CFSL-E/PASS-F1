import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:animations/animations.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PasswordManagerApp());
}

// 自定义全局过渡：Pixel 风格 Shared Axis (X轴水平平移)
class PixelPageTransitionsBuilder extends PageTransitionsBuilder {
  const PixelPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // 注入 fastOutSlowIn 曲线以提供完美的“快进慢出”阻尼感
    final curveAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastOutSlowIn.flipped,
    );

    return SharedAxisTransition(
      animation: curveAnimation,
      secondaryAnimation: secondaryAnimation,
      transitionType: SharedAxisTransitionType.horizontal,
      fillColor: Colors.transparent, // 避免多余的背景色闪烁
      child: child,
    );
  }
}

class PasswordManagerApp extends StatelessWidget {
  const PasswordManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightScheme;
        ColorScheme darkScheme;

        // 如果设备支持动态取色（Android 12+）则使用系统主题色，否则使用默认蓝色
        if (lightDynamic != null && darkDynamic != null) {
          lightScheme = lightDynamic.harmonized();
          darkScheme = darkDynamic.harmonized();
        } else {
          lightScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF005FB0));
          darkScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF005FB0), brightness: Brightness.dark);
        }

        return MaterialApp(
          title: '密码本',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightScheme,
            // 显式指定底色范围，确保浅色模式下带有淡淡的动态取色氛围（而非惨白）
            scaffoldBackgroundColor: lightScheme.surfaceContainerLowest,
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: PixelPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkScheme,
            scaffoldBackgroundColor: darkScheme.surfaceContainerLowest,
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: PixelPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
