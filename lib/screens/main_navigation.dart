import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'forecast_screen.dart';
import 'settings.dart' as settings_screen;

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  List<Widget> get _pages => const [
    HomeScreen(),
    ForecastScreen(),
    settings_screen.SettingsPage(),
  ];

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          MediaQuery(
            data: mq.copyWith(
              padding: mq.padding.copyWith(bottom: mq.padding.bottom + 104),
            ),
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: mq.padding.bottom + 16,
            child: _buildFloatingNavBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavBar(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final homeSelected = _selectedIndex == 0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: cs.outlineVariant.withValues(alpha: 0.30),
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withValues(alpha: 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: cs.shadow.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _navIconBtn(
                      cs: cs,
                      icon: Icons.list_alt_outlined,
                      selectedIcon: Icons.list_alt_rounded,
                      label: 'Details',
                      selected: _selectedIndex == 1,
                      onTap: () => _onNavTap(1),
                    ),
                    const SizedBox(width: 6),
                    _navIconBtn(
                      cs: cs,
                      icon: Icons.settings_outlined,
                      selectedIcon: Icons.settings_rounded,
                      label: 'Einstellungen',
                      selected: _selectedIndex == 2,
                      onTap: () => _onNavTap(2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            _BouncyButton(
              onTap: () => _onNavTap(0),
              scaleTarget: 0.88,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 480),
                curve: Curves.fastOutSlowIn,
                height: homeSelected ? 68 : 56,
                width: homeSelected ? 68 : 56,
                decoration: BoxDecoration(
                  color: homeSelected
                      ? cs.primary
                      : cs.surfaceContainerHigh.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(
                    homeSelected ? 22 : 18,
                  ),
                  border: Border.all(
                    color: homeSelected
                        ? cs.primary.withValues(alpha: 0.38)
                        : cs.outlineVariant.withValues(alpha: 0.30),
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (homeSelected ? cs.primary : cs.surfaceContainerHigh)
                          .withValues(alpha: 0.32),
                      blurRadius: homeSelected ? 20 : 12,
                      offset: Offset(0, homeSelected ? 6 : 4),
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 420),
                    switchInCurve: Curves.fastOutSlowIn,
                    switchOutCurve: Curves.easeInOutCubic,
                    transitionBuilder: (child, anim) {
                      final slide = Tween<Offset>(
                        begin: const Offset(0, 0.15),
                        end: Offset.zero,
                      ).animate(anim);
                      return FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: slide,
                          child: ScaleTransition(
                            scale: Tween<double>(
                              begin: 0.85,
                              end: 1.0,
                            ).animate(anim),
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      homeSelected
                          ? Icons.wb_sunny_rounded
                          : Icons.wb_sunny_outlined,
                      key: ValueKey('weather_$homeSelected'),
                      color: homeSelected
                          ? cs.onPrimary
                          : cs.onSurfaceVariant,
                      size: homeSelected ? 34 : 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navIconBtn({
    required ColorScheme cs,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return _BouncyButton(
      onTap: onTap,
      scaleTarget: 0.8,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
        height: 44,
        padding: EdgeInsets.symmetric(horizontal: selected ? 14 : 11),
        decoration: BoxDecoration(
          color: selected ? cs.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          border: selected
              ? Border.all(color: cs.primary.withValues(alpha: 0.20), width: 0.8)
              : Border.all(color: Colors.transparent, width: 0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.fastOutSlowIn,
              switchOutCurve: Curves.easeInOutCubic,
              transitionBuilder: (child, anim) {
                return ScaleTransition(scale: anim, child: child);
              },
              child: Icon(
                selected ? selectedIcon : icon,
                key: ValueKey(selected),
                size: selected ? 22 : 24,
                color: selected
                    ? cs.onPrimaryContainer
                    : cs.onSurfaceVariant.withValues(alpha: 0.8),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 360),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.centerLeft,
              child: selected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BouncyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scaleTarget;

  const _BouncyButton({
    required this.child,
    required this.onTap,
    this.scaleTarget = 0.9,
  });

  @override
  State<_BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<_BouncyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _tapLocked = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 320),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleTarget)
        .animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOutCubic,
          reverseCurve: Curves.fastOutSlowIn,
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (_tapLocked) return;
        _controller.forward();
      },
      onTap: () {
        if (_tapLocked) return;
        _tapLocked = true;
        widget.onTap();
        _controller.reverse();
        Future.delayed(const Duration(milliseconds: 140), () {
          if (!mounted) return;
          _tapLocked = false;
        });
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
