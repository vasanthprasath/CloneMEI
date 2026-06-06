import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/parcel_model.dart';
import '../../providers/app_state_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/app_drawer.dart';

class ParcelScreen extends StatefulWidget {
  const ParcelScreen({Key? key}) : super(key: key);

  @override
  State<ParcelScreen> createState() => _ParcelScreenState();
}

class _ParcelScreenState extends State<ParcelScreen> {
  final TextEditingController _trackingController = TextEditingController();
  final TextEditingController _courierController = TextEditingController();
  bool _notificationEnabled = true;

  @override
  void dispose() {
    _trackingController.dispose();
    _courierController.dispose();
    super.dispose();
  }

  void _showScanSimulateDialog(BuildContext context, AppStateProvider state) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Simulate Guard Scan',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _trackingController,
                decoration: const InputDecoration(
                  labelText: 'Tracking / Reference Number',
                  hintText: 'e.g., TRACK123456',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _courierController,
                decoration: const InputDecoration(
                  labelText: 'Courier / Service Provider',
                  hintText: 'e.g., DHL Express',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCEL', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_trackingController.text.isNotEmpty && _courierController.text.isNotEmpty) {
                  state.addScannedParcel(
                    _trackingController.text.trim(),
                    _courierController.text.trim(),
                  );
                  _trackingController.clear();
                  _courierController.clear();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('New parcel registered successfully!'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
              child: const Text('SUBMIT', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GradientAppBar(
        title: 'Parcel Tracking',
        showBackButton: true,
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Student Pickup QR Card
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
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Student Pickup QR Code',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Show this QR to the hostel security guard to retrieve your parcels.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Display QR Code representing student's unique ID
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200, width: 2),
                    ),
                    child: QrImageView(
                      data: state.registerNumber,
                      version: QrVersions.auto,
                      size: 140.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'REG ID: ${state.registerNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.primaryPurple,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Notification preferences
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.notifications_active_outlined, color: AppColors.primaryBlue),
                      SizedBox(width: 12),
                      Text(
                        'Instant SMS & App Alerts',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _notificationEnabled,
                    activeColor: AppColors.primaryPurple,
                    onChanged: (val) {
                      setState(() {
                        _notificationEnabled = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Simulated Scan Button
            ElevatedButton.icon(
              onPressed: () => _showScanSimulateDialog(context, state),
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
              label: const Text(
                'SIMULATE GUARD NEW PARCEL ENTRY',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),

            // Received History
            const Text(
              'Parcel Delivery History',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            state.parcels.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 30.0),
                      child: Text(
                        'No parcels recorded.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.parcels.length,
                    itemBuilder: (context, index) {
                      final item = state.parcels[index];
                      final dateStr = DateFormat('MMM dd, yyyy - hh:mm a').format(item.receivedDate);
                      
                      Color statusColor;
                      String statusText;

                      switch (item.status) {
                        case ParcelStatus.inTransit:
                          statusColor = AppColors.warning;
                          statusText = 'IN TRANSIT';
                          break;
                        case ParcelStatus.received:
                          statusColor = AppColors.primaryBlue;
                          statusText = 'AWAITING PICKUP';
                          break;
                        case ParcelStatus.delivered:
                          statusColor = AppColors.success;
                          statusText = 'DELIVERED';
                          break;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
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
                                Text(
                                  item.courierService,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: statusColor, width: 0.8),
                                  ),
                                  child: Text(
                                    statusText,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Track ID: ${item.trackingNumber}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const Divider(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recipient: ${item.recipientName}',
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                                Text(
                                  dateStr,
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
