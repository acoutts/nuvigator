// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_two_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class SampleTwoRoutes {
  static const screenOne = 'screenOne';

  static const screenTwo = 'screenTwo';
}

class ScreenOneArgs {
  ScreenOneArgs({@required this.testId});

  final String testId;

  static ScreenOneArgs parse(Map<String, Object> args) {
    return ScreenOneArgs(
      testId: args['testId'],
    );
  }

  static ScreenOneArgs of(BuildContext context) {
    final routeSettings = ModalRoute.of(context)?.settings;
    final nuvigator = Nuvigator.of(context);
    if (routeSettings?.name == SampleTwoRoutes.screenOne) {
      final args = routeSettings?.arguments;
      if (args is ScreenOneArgs) return args;
      if (args is Map<String, Object>) return parse(args);
    } else if (nuvigator != null) {
      return of(nuvigator.context);
    }
    return null;
  }
}

abstract class ScreenOneScreen extends ScreenWidget {
  ScreenOneScreen(BuildContext context) : super(context);

  ScreenOneArgs get args => ScreenOneArgs.of(context);
  SampleTwoNavigation get sampleTwoNavigation =>
      SampleTwoNavigation.of(context);
}

class SampleTwoNavigation {
  SampleTwoNavigation(this.nuvigator);

  final NuvigatorState nuvigator;

  static SampleTwoNavigation of(BuildContext context) =>
      SampleTwoNavigation(Nuvigator.of(context));
  Future<String> toScreenOne({String testId}) {
    return nuvigator.pushNamed<String>(
      SampleTwoRoutes.screenOne,
      arguments: {
        'testId': testId,
      },
    );
  }

  Future<String> pushReplacementToScreenOne<TO extends Object>(
      {String testId, TO result}) {
    return nuvigator.pushReplacementNamed<String, TO>(
      SampleTwoRoutes.screenOne,
      arguments: {
        'testId': testId,
      },
      result: result,
    );
  }

  Future<String> pushAndRemoveUntilToScreenOne<TO extends Object>(
      {String testId, @required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<String>(
      SampleTwoRoutes.screenOne,
      predicate,
      arguments: {
        'testId': testId,
      },
    );
  }

  Future<String> popAndPushToScreenOne<TO extends Object>(
      {String testId, TO result}) {
    return nuvigator.popAndPushNamed<String, TO>(
      SampleTwoRoutes.screenOne,
      arguments: {
        'testId': testId,
      },
      result: result,
    );
  }

  Future<String> toScreenTwo() {
    return nuvigator.pushNamed<String>(
      SampleTwoRoutes.screenTwo,
    );
  }

  Future<String> pushReplacementToScreenTwo<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<String, TO>(
      SampleTwoRoutes.screenTwo,
      result: result,
    );
  }
}

Map<RouteDef, ScreenRouteBuilder> _$sampleTwoScreensMap(
    SampleTwoRouter router) {
  return {
    RouteDef(SampleTwoRoutes.screenOne): (RouteSettings settings) {
      final Map<String, Object> args = settings.arguments;
      return router.screenOne(testId: args['testId']);
    },
    RouteDef(SampleTwoRoutes.screenTwo): (RouteSettings settings) {
      return router.screenTwo();
    },
  };
}
