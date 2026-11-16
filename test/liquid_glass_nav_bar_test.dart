import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:evoria/core/widgets/liquid_glass_nav_bar.dart';
import 'package:evoria/core/theme/evoria_theme.dart';

void main() {
  const testItems = [
    LiquidNavItem(icon: Icons.home_rounded, label: 'Beranda'),
    LiquidNavItem(icon: Icons.photo_library_outlined, label: 'Kenangan'),
    LiquidNavItem(icon: Icons.travel_explore_rounded, label: 'Jelajah'),
    LiquidNavItem(icon: Icons.auto_stories_outlined, label: 'Refleksi'),
    LiquidNavItem(icon: Icons.person_outline_rounded, label: 'Profil'),
  ];

  testWidgets('LiquidGlassNavBar renders all 5 tab items and labels', (tester) async {
    int selectedTab = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: EvoriaTheme.light(),
        home: Scaffold(
          body: const SizedBox(),
          bottomNavigationBar: StatefulBuilder(
            builder: (context, setState) {
              return LiquidGlassNavBar(
                selectedIndex: selectedTab,
                onItemSelected: (index) {
                  setState(() {
                    selectedTab = index;
                  });
                },
                items: testItems,
              );
            },
          ),
        ),
      ),
    );

    // Verify all 5 tab labels are visible in Indonesian
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Kenangan'), findsOneWidget);
    expect(find.text('Jelajah'), findsOneWidget);
    expect(find.text('Refleksi'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);

    // Verify backdrop filter and blur structure
    expect(find.byType(BackdropFilter), findsOneWidget);
  });

  testWidgets('Tapping on a tab updates selectedIndex and triggers onItemSelected', (tester) async {
    int selectedTab = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: EvoriaTheme.light(),
        home: Scaffold(
          body: const SizedBox(),
          bottomNavigationBar: StatefulBuilder(
            builder: (context, setState) {
              return LiquidGlassNavBar(
                selectedIndex: selectedTab,
                onItemSelected: (index) {
                  setState(() {
                    selectedTab = index;
                  });
                },
                items: testItems,
              );
            },
          ),
        ),
      ),
    );

    // Tap on 'Jelajah' (index 2)
    await tester.tap(find.text('Jelajah'));
    await tester.pumpAndSettle();

    expect(selectedTab, equals(2));

    // Tap on 'Profil' (index 4)
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    expect(selectedTab, equals(4));
  });

  testWidgets('LiquidGlassNavBar renders seamlessly in Dark Theme', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: EvoriaTheme.dark(),
        home: Scaffold(
          body: const SizedBox(),
          bottomNavigationBar: LiquidGlassNavBar(
            selectedIndex: 1,
            onItemSelected: (_) {},
            items: testItems,
            isDark: true,
          ),
        ),
      ),
    );

    expect(find.byType(LiquidGlassNavBar), findsOneWidget);
    expect(find.text('Kenangan'), findsOneWidget);
  });
}
