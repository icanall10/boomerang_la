import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Nav {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get context => navigatorKey.currentState!.context;

  static Nav instance() {
    return GetIt.instance<Nav>();
  }

  Future<void> go(Widget screen) async {
    final PageRoute route = makeRoute(screen);

    await navigatorKey.currentState?.push(route);
  }

  void back() {
    navigatorKey.currentState?.pop();
  }

  PageRouteBuilder makeRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const Offset begin = Offset(1, 0);
        const Offset end = Offset(0, 0);

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(
          CurveTween(
            curve: Curves.fastEaseInToSlowEaseOut,
          ),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      settings: RouteSettings(
        name: screen.runtimeType.toString(),
      ),
    );
  }
}
