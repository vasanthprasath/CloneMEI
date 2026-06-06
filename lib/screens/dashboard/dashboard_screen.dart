import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    // Calculate stats
    int approvedCount = state.requests.where((r) => r.status == RequestStatus.approved).length;
    int pendingCount = state.requests.where((r) => r.status == RequestStatus.pending).length;
    int totalRequests = state.requests.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GradientAppBar(title: 'Dashboard'),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Welcome Section - Responsive Layout (row for tablets, column for phones)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: isTablet ? 32 : 24, 
                  horizontal: 20
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: isTablet
                    ? Row(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              gradient: AppColors.headerGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryPurple.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'MEI',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Welcome back,',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  state.name,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${state.registerNumber} | ${state.department}',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: AppColors.headerGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryPurple.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'MEI',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.black,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Welcome back,',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${state.registerNumber} | ${state.department}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
              ),
              
              Padding(
                padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Overview',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Responsive Grid using LayoutBuilder
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Dynamic crossAxisCount based on screen width
                        int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                        double aspectRatio = constraints.maxWidth > 600 ? 1.45 : 1.35;

                        return GridView.count(
                          crossAxisCount: crossAxisCount,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: aspectRatio,
                          children: [
                            StatCard(
                              title: 'Room Number',
                              value: state.roomNumber,
                              icon: Icons.meeting_room,
                              iconColor: AppColors.primaryBlue,
                              subtitle: state.hostelBlock.split(' ')[0],
                            ),
                            const StatCard(
                              title: 'Attendance',
                              value: '94.8%',
                              icon: Icons.playlist_add_check,
                              iconColor: AppColors.success,
                              subtitle: 'Present this month',
                            ),
                            StatCard(
                              title: 'Approved Passes',
                              value: approvedCount.toString(),
                              icon: Icons.check_circle_outline,
                              iconColor: AppColors.success,
                              subtitle: 'Out of $totalRequests requests',
                            ),
                            StatCard(
                              title: 'Pending Passes',
                              value: pendingCount.toString(),
                              icon: Icons.pending_outlined,
                              iconColor: AppColors.warning,
                              subtitle: 'Awaiting approval',
                            ),
                          ],
                        );
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    const Text(
                      'Recent Announcements',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Responsive announcement layout (could load in a Grid on tablet)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool useAnnounceGrid = constraints.maxWidth > 600;

                        if (useAnnounceGrid) {
                          return GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2.2,
                            children: [
                              _buildNotificationItem(
                                title: 'Mess Menu Choice Open',
                                desc: 'Select your food preference for next week before Friday 5:00 PM.',
                                time: '2 hours ago',
                                tag: 'MESS',
                                tagColor: AppColors.primaryPurple,
                              ),
                              _buildNotificationItem(
                                title: 'Weekend Pass Guidelines',
                                desc: 'All weekend outing applications must be submitted 24 hours prior to checkout.',
                                time: '1 day ago',
                                tag: 'RULES',
                                tagColor: AppColors.primaryBlue,
                              ),
                              _buildNotificationItem(
                                title: 'Anti-Ragging Committee Visit',
                                desc: 'The committee will visit tomorrow morning for hostel inspections.',
                                time: '2 days ago',
                                tag: 'ALERT',
                                tagColor: AppColors.error,
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              _buildNotificationItem(
                                title: 'Mess Menu Choice Open',
                                desc: 'Select your food preference for next week before Friday 5:00 PM.',
                                time: '2 hours ago',
                                tag: 'MESS',
                                tagColor: AppColors.primaryPurple,
                              ),
                              _buildNotificationItem(
                                title: 'Weekend Pass Guidelines',
                                desc: 'All weekend outing applications must be submitted 24 hours prior to checkout.',
                                time: '1 day ago',
                                tag: 'RULES',
                                tagColor: AppColors.primaryBlue,
                              ),
                              _buildNotificationItem(
                                title: 'Anti-Ragging Committee Visit',
                                desc: 'The committee will visit tomorrow morning for hostel inspections.',
                                time: '2 days ago',
                                tag: 'ALERT',
                                tagColor: AppColors.error,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String desc,
    required String time,
    required String tag,
    required Color tagColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tagColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: tagColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              desc,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
