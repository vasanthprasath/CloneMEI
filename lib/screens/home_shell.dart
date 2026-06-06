import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import 'dashboard/dashboard_screen.dart';
import 'request/request_list_screen.dart';
import 'profile/profile_screen.dart';
import 'pass_timing/pass_timing_screen.dart';
import 'emergency/emergency_screen.dart';
import 'food/food_choice_screen.dart';
import 'parcel/parcel_screen.dart';
import 'change_password/change_password_screen.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);

    // Dynamic transition mapping
    switch (state.currentScreen) {
      case 'Dashboard':
        return const DashboardScreen();
      case 'Request List':
        return const RequestListScreen();
      case 'Profile':
        return const ProfileScreen();
      case 'Pass Timing':
        return const PassTimingScreen();
      case 'Emergency Request':
        return const EmergencyScreen();
      case 'Food Choice':
        return const FoodChoiceScreen();
      case 'Parcel Tracking':
        return const ParcelScreen();
      case 'Change Password':
        return const ChangePasswordScreen();
      default:
        return const DashboardScreen();
    }
  }
}
