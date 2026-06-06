import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/food_choice_model.dart';
import '../../providers/app_state_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/app_drawer.dart';

class FoodChoiceScreen extends StatefulWidget {
  const FoodChoiceScreen({Key? key}) : super(key: key);

  @override
  State<FoodChoiceScreen> createState() => _FoodChoiceScreenState();
}

class _FoodChoiceScreenState extends State<FoodChoiceScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);
    final foodChoice = state.getFoodChoiceForDate(_selectedDate);

    // List of dates for choice: Today and next 4 days
    final List<DateTime> dateOptions = List.generate(
      5,
      (index) => DateTime.now().add(Duration(days: index)),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GradientAppBar(
        title: 'Food Preference Choice',
        showBackButton: true,
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Calendar/Date Selector Row
            const Text(
              'Select Date for Meal Preference',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: dateOptions.length,
                itemBuilder: (context, index) {
                  final date = dateOptions[index];
                  final isSelected = date.day == _selectedDate.day &&
                      date.month == _selectedDate.month &&
                      date.year == _selectedDate.year;

                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 65,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryPurple : AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: isSelected
                              ? null
                              : Border.all(color: Colors.grey.shade300, width: 1),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('E').format(date).toUpperCase(),
                              style: TextStyle(
                                color: isSelected ? Colors.white70 : AppColors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              date.day.toString(),
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Mess cutoff time alert
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.warning, width: 0.8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.warning, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Changes for tomorrow\'s meals must be submitted before 5:00 PM today.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Breakfast selection card
            _buildMealSelectionCard(
              title: 'Breakfast Selection',
              icon: Icons.free_breakfast_outlined,
              currentTime: '07:15 AM - 08:30 AM',
              selectedType: foodChoice.breakfast,
              onChanged: (MealType type) {
                state.updateFoodChoice(_selectedDate, breakfast: type);
              },
            ),
            const SizedBox(height: 16),

            // Lunch selection card
            _buildMealSelectionCard(
              title: 'Lunch Selection',
              icon: Icons.lunch_dining_outlined,
              currentTime: '12:15 PM - 01:45 PM',
              selectedType: foodChoice.lunch,
              onChanged: (MealType type) {
                state.updateFoodChoice(_selectedDate, lunch: type);
              },
            ),
            const SizedBox(height: 16),

            // Dinner selection card
            _buildMealSelectionCard(
              title: 'Dinner Selection',
              icon: Icons.dinner_dining_outlined,
              currentTime: '07:30 PM - 09:00 PM',
              selectedType: foodChoice.dinner,
              onChanged: (MealType type) {
                state.updateFoodChoice(_selectedDate, dinner: type);
              },
            ),
            const SizedBox(height: 24),

            // Save Confirmation Alert
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, color: AppColors.success, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Preferences are auto-saved on selection',
                    style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMealSelectionCard({
    required String title,
    required IconData icon,
    required String currentTime,
    required MealType selectedType,
    required Function(MealType) onChanged,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.primaryPurple, size: 22),
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
              Text(
                currentTime,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          
          // Row of options
          Row(
            children: [
              Expanded(
                child: _buildOptionButton(
                  label: 'Vegetarian',
                  icon: Icons.circle,
                  iconColor: Colors.green,
                  isSelected: selectedType == MealType.veg,
                  onTap: () => onChanged(MealType.veg),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildOptionButton(
                  label: 'Non-Veg',
                  icon: Icons.change_history,
                  iconColor: Colors.red,
                  isSelected: selectedType == MealType.nonVeg,
                  onTap: () => onChanged(MealType.nonVeg),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildOptionButton(
                  label: 'Special Meal',
                  icon: Icons.star,
                  iconColor: Colors.amber.shade700,
                  isSelected: selectedType == MealType.special,
                  onTap: () => onChanged(MealType.special),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required String label,
    required IconData icon,
    required Color iconColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? iconColor.withOpacity(0.12) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? iconColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? iconColor : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
