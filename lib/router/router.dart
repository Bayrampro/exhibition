import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:requests_with_riverpod/repo/auth_token_repo/auth_token_interface.dart';
import 'package:requests_with_riverpod/screens/cat_list_screen.dart';
import 'package:requests_with_riverpod/screens/kind_detail_screen.dart';
import 'package:requests_with_riverpod/screens/kinds_screen.dart';
import 'package:requests_with_riverpod/screens/login_screen.dart';
import 'package:requests_with_riverpod/screens/cat_detail_screen.dart';
import 'package:requests_with_riverpod/screens/user_cats_screen.dart';
import 'package:requests_with_riverpod/screens/welcome_screen.dart';

final isAuthenticated = GetIt.I.get<AuthTokenInterface>().isAuthenticated;
final isFirstTime = GetIt.I.get<AuthTokenInterface>().isFirstTime;
final tokens = GetIt.I.get<AuthTokenInterface>().getTokens();

String initialLocation = '/cat-list';

String getInitialLocation(bool? isAuthenticated, bool isFirstTime) {
  if (isFirstTime) {
    initialLocation = '/';
    return initialLocation;
  } else if (isAuthenticated != null && !isAuthenticated ||
      JwtDecoder.isExpired(tokens['refresh'])) {
    initialLocation = '/login';
    return initialLocation;
  }
  return initialLocation;
}

final router = GoRouter(
  initialLocation: getInitialLocation(isAuthenticated, isFirstTime),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/cat-list',
      builder: (context, state) => const CatListScreen(),
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) {
        final pp = state.pathParameters['id']!;
        final id = int.parse(pp);
        return CatDetailScreen(id: id);
      },
    ),
    GoRoute(
      path: '/kinds',
      builder: (context, state) => const KindsScreen(),
    ),
    GoRoute(
      path: '/kind-detail/:id',
      builder: (context, state) {
        final pp = state.pathParameters['id']!;
        final id = int.parse(pp);
        return KindDetailScreen(id: id);
      },
    ),
    GoRoute(
      path: '/cats-by-user',
      builder: (context, state) => const UserCatsScreen(),
    ),
  ],
);
