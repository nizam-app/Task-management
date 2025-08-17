import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../../providers/auth_provider.dart';
import '../../providers/message_provider.dart';
import '../../theme/app_theme.dart';
import 'staff_dashboard_screen.dart';
import 'shift_claiming_screen.dart';
import 'clock_in_out_screen.dart';
import 'staff_messaging_screen.dart';
import 'staff_profile_screen.dart';

class StaffMainScreen extends StatefulWidget {
  const StaffMainScreen({super.key});

  @override
  State<StaffMainScreen> createState() => _StaffMainScreenState();
}

class _StaffMainScreenState extends State<StaffMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const StaffDashboardScreen(),
    const ShiftClaimingScreen(),
    const ClockInOutScreen(),
    const StaffMessagingScreen(),
    const StaffProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final messageProvider = Provider.of<MessageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('EDM Solutions'),
            Text(
              'Welcome back, ${authProvider.userName?.split(' ').first ?? 'Staff'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppTheme.lightBlue,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'S',
                    style: TextStyle(
                      color: AppTheme.primaryBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (messageProvider.totalUnreadCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.errorRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryBlue,
          unselectedItemColor: AppTheme.gray600,
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: badges.Badge(
                showBadge: true,
                badgeContent: const SizedBox(width: 6, height: 6),
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: AppTheme.errorRed,
                  padding: EdgeInsets.zero,
                ),
                child: const Icon(Icons.calendar_today_outlined),
              ),
              activeIcon: const Icon(Icons.calendar_today),
              label: 'Shifts',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.access_time_outlined),
              activeIcon: Icon(Icons.access_time),
              label: 'Clock',
            ),
            BottomNavigationBarItem(
              icon: badges.Badge(
                showBadge: messageProvider.totalUnreadCount > 0,
                badgeContent: const SizedBox(width: 6, height: 6),
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: AppTheme.errorRed,
                  padding: EdgeInsets.zero,
                ),
                child: const Icon(Icons.message_outlined),
              ),
              activeIcon: const Icon(Icons.message),
              label: 'Messages',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}