import 'package:flutter/material.dart';

import '../core/localization/l10n_extension.dart';
import '../core/localization/locale_controller.dart';
import '../data/repositories/experience_repository.dart';
import '../data/repositories/guide_repository.dart';
import '../features/destinations/destinations_screen.dart';
import '../features/explore/explore_screen.dart';
import '../features/home/home_screen.dart';
import '../features/more/more_screen.dart';
import '../features/trip_planner/trip_planner_screen.dart';

class AppShell extends StatefulWidget {
  final LocaleController localeController;
  final ExperienceRepository homeExperienceRepository;
  final GuideRepository smartGuideRepository;

  const AppShell({
    required this.localeController,
    this.homeExperienceRepository = const ExperienceRepository(),
    this.smartGuideRepository = const GuideRepository(),
    super.key,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const int exploreTabIndex = 1;
  static const int destinationsTabIndex = 2;
  static const int planTabIndex = 3;

  int _selectedIndex = 0;

  void _selectTab(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      HomeScreen(
        experienceRepository: widget.homeExperienceRepository,
        onExploreDestinations: () => _selectTab(destinationsTabIndex),
        onExploreExperiences: () => _selectTab(exploreTabIndex),
        onPlanTrip: () => _selectTab(planTabIndex),
      ),
      const ExploreScreen(),
      DestinationsScreen(onPlanTrip: () => _selectTab(planTabIndex)),
      const TripPlannerScreen(),
      MoreScreen(
        localeController: widget.localeController,
        smartGuideRepository: widget.smartGuideRepository,
        onSelectTab: _selectTab,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: context.l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.explore_outlined),
            selectedIcon: const Icon(Icons.explore_rounded),
            label: context.l10n.explore,
          ),
          NavigationDestination(
            icon: const Icon(Icons.place_outlined),
            selectedIcon: const Icon(Icons.place_rounded),
            label: context.l10n.destinations,
          ),
          NavigationDestination(
            icon: const Icon(Icons.route_outlined),
            selectedIcon: const Icon(Icons.route_rounded),
            label: context.l10n.plan,
          ),
          NavigationDestination(
            icon: const Icon(Icons.more_horiz_outlined),
            selectedIcon: const Icon(Icons.more_horiz_rounded),
            label: context.l10n.more,
          ),
        ],
      ),
    );
  }
}
