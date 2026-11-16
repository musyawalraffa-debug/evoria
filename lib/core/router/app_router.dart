import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/memory_item.dart';
import '../widgets/liquid_glass_nav_bar.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/auth/screens/google_signin_screen.dart';
import '../../features/auth/screens/profile_setup_screen.dart';
import '../../features/home/screens/beranda_screen.dart';
import '../../features/memories/screens/kenangan_screen.dart';
import '../../features/memories/screens/tambah_kenangan_screen.dart';
import '../../features/memories/screens/detail_kenangan_screen.dart';
import '../../features/explore/screens/jelajah_screen.dart';
import '../../features/reflection/screens/refleksi_screen.dart';
import '../../features/profile/screens/profil_screen.dart';
import '../../features/showcase/screens/liquid_glass_showcase_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/google-signin',
      builder: (context, state) => const GoogleSignInScreen(),
    ),
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/showcase',
      builder: (context, state) => const LiquidGlassShowcaseScreen(),
    ),
    GoRoute(
      path: '/tambah-kenangan',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TambahKenanganScreen(),
    ),
    GoRoute(
      path: '/detail-kenangan',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final memory = state.extra as MemoryItem;
        return DetailKenanganScreen(memory: memory);
      },
    ),

    // Five Main Tabs hosted in a StatefulShellRoute with Floating Liquid Glass Navbar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          extendBody: true,
          body: navigationShell,
          bottomNavigationBar: _MainShellNavBar(
            navigationShell: navigationShell,
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/beranda',
              builder: (context, state) => const BerandaScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/kenangan',
              builder: (context, state) => const KenanganScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/jelajah',
              builder: (context, state) => const JelajahScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/refleksi',
              builder: (context, state) => const RefleksiScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profil',
              builder: (context, state) => const ProfilScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class _MainShellNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _MainShellNavBar({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    const navItems = [
      LiquidNavItem(icon: Icons.home_rounded, label: 'Beranda'),
      LiquidNavItem(icon: Icons.photo_library_outlined, label: 'Kenangan'),
      LiquidNavItem(icon: Icons.travel_explore_rounded, label: 'Jelajah'),
      LiquidNavItem(icon: Icons.auto_stories_outlined, label: 'Refleksi'),
      LiquidNavItem(icon: Icons.person_outline_rounded, label: 'Profil'),
    ];

    return LiquidGlassNavBar(
      selectedIndex: navigationShell.currentIndex,
      onItemSelected: (index) {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
      items: navItems,
      isDark: isDark,
    );
  }
}
