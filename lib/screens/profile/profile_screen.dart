import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/app_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GradientAppBar(
        title: 'Profile',
        showBackButton: true,
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Circular Photo / Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryBlue, width: 3),
                      gradient: AppColors.headerGradient,
                    ),
                    child: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Text(
                        'AS',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Reg No: ${state.registerNumber}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Profile Detail Sections
            _buildProfileSection(
              title: 'Personal Details',
              icon: Icons.person_outline,
              fields: {
                'Full Name': state.name,
                'Email Address': state.email,
                'Mobile Number': state.phoneNumber,
              },
            ),
            const SizedBox(height: 16),

            _buildProfileSection(
              title: 'Academic Details',
              icon: Icons.school_outlined,
              fields: {
                'Department': state.department,
                'Current Year': state.year,
                'Institution': 'MEI College of Engineering',
              },
            ),
            const SizedBox(height: 16),

            _buildProfileSection(
              title: 'Hostel Details',
              icon: Icons.hotel_outlined,
              fields: {
                'Hostel Block': state.hostelBlock,
                'Room Number': state.roomNumber,
                'Room Type': '3-Sharing AC',
                'Warden Name': 'Dr. K. Ranganathan',
              },
            ),
            const SizedBox(height: 16),

            _buildProfileSection(
              title: 'Emergency Contact',
              icon: Icons.contact_phone_outlined,
              fields: {
                'Parent/Guardian': 'S. Sundaram (Father)',
                'Contact Number': '+91 94432 10987',
                'Home Address': '12A, North Car Street, Coimbatore - 641012',
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection({
    required String title,
    required IconData icon,
    required Map<String, String> fields,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryPurple, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
          const Divider(height: 20, thickness: 0.8),
          ...fields.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
