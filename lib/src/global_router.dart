import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'nuvigator.dart';
import 'router.dart';
import 'screen_route.dart';

String deepLinkString(String url) => url.split(':/').last;

typedef HandleDeepLinkFn = Future<dynamic> Function(
    GlobalRouter globalRouter, String uri,
    [bool isFromNative, dynamic args]);

class GlobalRouterProvider extends InheritedWidget {
  const GlobalRouterProvider(
      {@required this.globalRouter, @required Widget child})
      : super(child: child);

  final GlobalRouter globalRouter;

  @override
  bool updateShouldNotify(GlobalRouterProvider oldWidget) {
    return oldWidget.globalRouter != globalRouter;
  }
}

class GlobalRouter implements Router {
  GlobalRouter({
    @required this.baseRouter,
    GlobalKey<NuvigatorState> nuvigatorKey,
    this.onScreenNotFound,
    this.onDeepLinkNotFound,
  }) {
    this.nuvigatorKey = nuvigatorKey ?? defaultKey;
  }

  static final defaultKey =
      GlobalKey<NuvigatorState>(debugLabel: 'GlobalRouter');

  static GlobalRouter of(BuildContext context) {
    final GlobalRouterProvider globalRouterProvider =
        context.inheritFromWidgetOfExactType(GlobalRouterProvider);
    return globalRouterProvider?.globalRouter;
  }

  HandleDeepLinkFn onDeepLinkNotFound;
  final Router baseRouter;
  GlobalKey<NuvigatorState> nuvigatorKey;
  final ScreenRoute Function(RouteSettings settings) onScreenNotFound;

  NuvigatorState get nuvigator => nuvigatorKey.currentState;

  @override
  Future<RouteEntry> getRouteEntryForDeepLink(String deepLink) {
    return baseRouter.getRouteEntryForDeepLink(deepLink);
  }

  @override
  ScreenRoute getScreen(RouteSettings settings) {
    final screen = baseRouter.getScreen(settings);
    if (screen == null) {
      if (onScreenNotFound != null)
        return onScreenNotFound(settings)
            ?.fallbackScreenType(nuvigator.widget.screenType);
    }
    return screen;
  }

  @override
  Route getRoute(RouteSettings settings) {
    return getScreen(settings)?.toRoute(settings);
  }

  Future<bool> canOpenDeepLink(String url) async {
    return (await getRouteEntryForDeepLink(deepLinkString(url))) != null;
  }

  Future<T> openDeepLink<T>(String url,
      [dynamic arguments, bool isFromNative = false]) async {
    final routeEntry = await getRouteEntryForDeepLink(deepLinkString(url));

    if (routeEntry == null) {
      if (onDeepLinkNotFound != null)
        return await onDeepLinkNotFound(this, url, isFromNative, arguments);
      return null;
    }

    final mapArguments = _extractParameters(url, routeEntry.key.path);
    if (isFromNative) {
      final route = _buildNativeRoute(routeEntry, mapArguments);
      return nuvigatorKey.currentState.push<T>(route);
    }
    return nuvigatorKey.currentState
        .pushNamed<T>(routeEntry.key.path, arguments: mapArguments);
  }

  Route _buildNativeRoute(
      RouteEntry routeEntry, Map<String, String> arguments) {
    final routeSettings = RouteSettings(
      name: routeEntry.key.path,
      isInitialRoute: false,
      arguments: arguments,
    );
    final screenRoute = getScreen(routeSettings)
        .fallbackScreenType(nuvigator.widget.screenType);
    final route = screenRoute.toRoute(routeSettings);
    route.popped.then<dynamic>((dynamic _) async {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await SystemNavigator.pop();
    });
    return route;
  }

  Map<String, String> _extractParameters(String url, String deepLinkTemplate) {
    final parameters = <String>[];
    final regExp = pathToRegExp(deepLinkTemplate, parameters: parameters);
    final match = regExp.matchAsPrefix(deepLinkString(url));
    return extract(parameters, match)..addAll(Uri.parse(url).queryParameters);
  }
}
