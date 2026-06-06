import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);
    final activeScreen = state.currentScreen;
    
    final double screenWidth = MediaQuery.of(context).size.width;
    // Drawer width scales based on screen width but has a max cap
    final double drawerWidth = screenWidth > 600 ? 320.0 : screenWidth * 0.78;

    return Drawer(
      width: drawerWidth,
      child: Container(
        color: AppColors.drawerBackground,
        child: Column(
          children: [
            // Drawer Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: const BoxDecoration(
                gradient: AppColors.headerGradient,
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth > 600 ? 80 : 70,
                      height: screenWidth > 600 ? 80 : 70,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'MEI',
                          style: TextStyle(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.black,
                            fontSize: screenWidth > 600 ? 24 : 22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'MEI Hostel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Student Management System',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Drawer Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                children: [
                  _buildDrawerItem(
                    context,
                    title: 'Dashboard',
                    icon: Icons.dashboard_outlined,
                    activeIcon: Icons.dashboard,
                    isSelected: activeScreen == 'Dashboard',
                    onTap: () => _navigateTo(context, 'Dashboard'),
                  ),
                  _buildDrawerItem(
                    context,
                    title: 'Request List',
                    icon: Icons.article_outlined,
                    activeIcon: Icons.article,
                    isSelected: activeScreen == 'Request List',
                    onTap: () => _navigateTo(context, 'Request List'),
                  ),
                  _buildDrawerItem(
                    context,
                    title: 'Pass Timing',
                    icon: Icons.access_time_outlined,
                    activeIcon: Icons.access_time_filled,
                    isSelected: activeScreen == 'Pass Timing',
                    onTap: () => _navigateTo(context, 'Pass Timing'),
                  ),
                  _buildDrawerItem(
                    context,
                    title: 'Emergency Request',
                    icon: Icons.emergency_share_outlined,
                    activeIcon: Icons.emergency_share,
                    isSelected: activeScreen == 'Emergency Request',
                    onTap: () => _navigateTo(context, 'Emergency Request'),
                  ),
                  _buildDrawerItem(
                    context,
                    title: 'Parcel Tracking',
                    icon: Icons.inventory_2_outlined,
                    activeIcon: Icons.inventory_2,
                    isSelected: activeScreen == 'Parcel Tracking',
                    onTap: () => _navigateTo(context, 'Parcel Tracking'),
                  ),
                  _buildDrawerItem(
                    context,
                    title: 'Food Choice',
                    icon: Icons.restaurant_outlined,
                    activeIcon: Icons.restaurant,
                    isSelected: activeScreen == 'Food Choice',
                    onTap: () => _navigateTo(context, 'Food Choice'),
                  ),
                  _buildDrawerItem(
                    context,
                    title: 'Profile',
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    isSelected: activeScreen == 'Profile',
                    onTap: () => _navigateTo(context, 'Profile'),
                  ),
                  _buildDrawerItem(
                    context,
                    title: 'Change Password',
                    icon: Icons.lock_outline,
                    activeIcon: Icons.lock,
                    isSelected: activeScreen == 'Change Password',
                    onTap: () => _navigateTo(context, 'Change Password'),
                  ),
                  const Divider(color: Colors.white24, height: 16),
                  _buildDrawerItem(
                    context,
                    title: 'Logout',
                    icon: Icons.logout,
                    isSelected: false,
                    onTap: () => _handleLogout(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    IconData? activeIcon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Icon(
          isSelected ? (activeIcon ?? icon) : icon,
          color: isSelected ? AppColors.accentMint : Colors.white70,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void _navigateTo(BuildContext context, String screenName) {
    final state = Provider.of<AppStateProvider>(context, listen: false);
    state.changeScreen(screenName);
    Navigator.of(context).pop();
  }

  void _handleLogout(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logging out...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
