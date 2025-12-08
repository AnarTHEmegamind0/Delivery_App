import 'package:flutter/material.dart';
import '../features/customer/pages/customer_orders_page.dart';
import '../features/customer/pages/customer_profile_page.dart';
import 'app_theme.dart';
import 'design_system/tokens/colors.dart';
import 'design_system/tokens/typography.dart';

class MainNavigation2 extends StatefulWidget {
  const MainNavigation2({super.key});

  @override
  State<MainNavigation2> createState() => _MainNavigation2State();
}

class _MainNavigation2State extends State<MainNavigation2> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CustomerOrdersPage(),
    const CustomerProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent, // Handled by container
          elevation: 0,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: AppTypography.caption.copyWith(
             fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTypography.caption,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Миний захиалгууд',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Профайл',
            ),
          ],
        ),
      ),
    );
  }
}
