import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_state_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/app_drawer.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedType = 'Medical Emergency';
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _uploadedFileName;

  final List<String> _emergencyTypes = [
    'Medical Emergency',
    'Family Urgency',
    'Critical Structural Issue',
    'Electrical Hazard',
    'Water Supply Failure',
    'Security Concern'
  ];

  @override
  void dispose() {
    _descController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _simulateUploadProof() {
    setState(() {
      _uploadedFileName = 'medical_report_or_proof_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File uploaded: $_uploadedFileName'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GradientAppBar(
        title: 'Emergency Request',
        showBackButton: true,
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // High visibility banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.error, width: 1.5),
              ),
              child: const Row(
                children: [
                  Icon(Icons.report_problem, color: AppColors.error, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EMERGENCY DISPATCH',
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Only submit this request for urgent matters. Misuse will lead to disciplinary action.',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Form card
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Raise Emergency Alert',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Divider(height: 20),

                    // Emergency Type
                    const Text(
                      'Emergency Type',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      items: _emergencyTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedType = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description
                    const Text(
                      'Detailed Description',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _descController,
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please provide a clear description of the situation';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Describe the emergency in detail so the warden/admin can act immediately...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        fillColor: Colors.grey.shade100,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Contact Number
                    const Text(
                      'Urgent Contact Number',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a contact number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Your mobile or parent mobile number',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        prefixIcon: const Icon(Icons.phone, size: 20),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Upload Proof Button
                    const Text(
                      'Upload Proof (Optional)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    OutlinedButton.icon(
                      onPressed: _simulateUploadProof,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        side: const BorderSide(color: AppColors.error),
                        foregroundColor: AppColors.error,
                      ),
                      icon: const Icon(Icons.cloud_upload_outlined),
                      label: Text(
                        _uploadedFileName == null ? 'SELECT & ATTACH PROOF' : 'CHANGE ATTACHMENT',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (_uploadedFileName != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _uploadedFileName!,
                              style: const TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                            onPressed: () => setState(() => _uploadedFileName = null),
                          )
                        ],
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Submit Emergency
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          state.submitEmergency(
                            _selectedType,
                            _descController.text.trim(),
                            _phoneController.text.trim(),
                            _uploadedFileName,
                          );
                          _descController.clear();
                          _phoneController.clear();
                          setState(() {
                            _uploadedFileName = null;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Emergency Alert Sent! Warden is notified.'),
                              backgroundColor: AppColors.error,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 4,
                      ),
                      child: const Text(
                        'SUBMIT EMERGENCY REQUEST',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Emergency History list
            const Text(
              'Past Emergency Submissions',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            state.emergencies.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'No emergency requests submitted.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.emergencies.length,
                    itemBuilder: (context, index) {
                      final item = state.emergencies[index];
                      final dateStr = DateFormat('MMM dd, yyyy - hh:mm a').format(item['date']);
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
                          border: const Border(
                            left: BorderSide(color: AppColors.error, width: 4),
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['type'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.error,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item['status'].toString().toUpperCase(),
                                    style: const TextStyle(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['description'],
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Divider(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Contact: ${item['contact']}',
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
