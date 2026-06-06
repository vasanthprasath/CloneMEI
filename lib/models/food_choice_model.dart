enum MealType { veg, nonVeg, special }

class FoodChoiceModel {
  final DateTime date;
  final MealType breakfast;
  final MealType lunch;
  final MealType dinner;

  FoodChoiceModel({
    required this.date,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });
}
