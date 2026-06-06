import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/app_drawer.dart';

class PassTimingScreen extends StatelessWidget {
  const PassTimingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GradientAppBar(
        title: 'Pass Timings & Rules',
        showBackButton: true,
      ),
      drawer: const AppDrawer(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Timetable layout card
          Container(
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
                const Row(
                  children: [
                    Icon(Icons.schedule, color: AppColors.primaryBlue),
                    SizedBox(width: 8),
                    Text(
                      'Outing & Entry Timetable',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildTimetableRow('Weekday Outing', 'Wed & Fri', '04:30 PM - 07:00 PM'),
                const Divider(height: 16, thickness: 0.5),
                _buildTimetableRow('Weekend Outing', 'Saturday', '01:30 PM - 08:00 PM'),
                const Divider(height: 16, thickness: 0.5),
                _buildTimetableRow('Weekend Outing', 'Sunday', '07:00 AM - 08:00 PM'),
                const Divider(height: 16, thickness: 0.5),
                _buildTimetableRow('Night Curfew', 'Daily', '08:30 PM'),
                const Divider(height: 16, thickness: 0.5),
                _buildTimetableRow('Mess Timings', 'Breakfast', '07:15 AM - 08:30 AM'),
                _buildTimetableRow('Mess Timings', 'Lunch', '12:15 PM - 01:45 PM'),
                _buildTimetableRow('Mess Timings', 'Dinner', '07:30 PM - 09:00 PM'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Weekend Rules
          _buildRuleCard(
            title: 'Weekend Outing Rules',
            icon: Icons.weekend,
            iconColor: AppColors.primaryPurple,
            rules: [
              'Weekend passes must be submitted at least 24 hours prior to checkout time.',
              'Outing permissions are granted only after receiving automated SMS confirmation from parents.',
              'Late entries beyond 08:00 PM on Sunday will attract disciplinary action and suspension of outing privileges for 2 weeks.',
              'Students must carry their college ID card and biometric punch is mandatory at checkout and checkin.',
            ],
          ),
          const SizedBox(height: 16),

          // Holiday Rules
          _buildRuleCard(
            title: 'Holiday/Vacation Guidelines',
            icon: Icons.flight_takeoff,
            iconColor: AppColors.warning,
            rules: [
              'Holiday requests must be raised 3 days in advance and require approval from both Room Warden and Chief Warden.',
              'In case of extended leaves due to medical reasons, students must produce a medical certificate during checkin.',
              'Hostel mess charges will be rebated only if the student is continuously absent for 5 days or more with prior approved leave.',
              'Students must clean their rooms and shut off all electrical appliances before leaving for holidays.',
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTimetableRow(String type, String days, String hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              type,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              days,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              hours,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPurple,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<String> rules,
  }) {
    return Container(
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
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ...rules.map((rule) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: iconColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        rule,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.35,
                        ),
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
