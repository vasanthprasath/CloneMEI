enum ParcelStatus { inTransit, received, delivered }

class ParcelModel {
  final String id;
  final String trackingNumber;
  final String courierService;
  final DateTime receivedDate;
  final ParcelStatus status;
  final String recipientName;

  ParcelModel({
    required this.id,
    required this.trackingNumber,
    required this.courierService,
    required this.receivedDate,
    required this.status,
    required this.recipientName,
  });
}
