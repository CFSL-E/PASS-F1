import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:animations/animations.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PasswordManagerApp());
}

// 提供自定义带时长的 PageRoute，以达到 450ms 的沉稳 Pixel 动画体验
class PixelPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  PixelPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 450),
          reverseTransitionDuration: const Duration(milliseconds: 450),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curveAnimation = CurvedAnimation(
              parent: animation,
              // 改用 easeInOutCubic 提供更沉稳的阻尼感，消除生硬弹跳
              curve: Curves.easeInOutCubic,
              reverseCurve: Curves.easeInOutCubic.flipped,
            );

            return SharedAxisTransition(
              animation: curveAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              // 消除黑色底层闪烁：填充与当前环境完全一致的表层背景色
              fillColor: Theme.of(context).colorScheme.surface,
              child: child,
            );
          },
        );
}

// 全局兜底动画配置，顺便修复黑色遮罩问题与曲线统一
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
    // 采用与 PixelPageRoute 相同的过渡曲线
    final curveAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic.flipped,
    );

    return SharedAxisTransition(
      animation: curveAnimation,
      secondaryAnimation: secondaryAnimation,
      transitionType: SharedAxisTransitionType.horizontal,
      fillColor: Theme.of(context).colorScheme.surface, // 修复黑色闪烁
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
            // 移除纯白背景强制覆盖，使用 MD3 默认自带的主题色调表面颜色 (surface)
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
