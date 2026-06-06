enum RequestStatus { approved, pending, rejected }

class PermissionRequest {
  final String id;
  final String requestType;
  final DateTime fromDate;
  final DateTime toDate;
  final String timeOut;
  final String timeIn;
  final DateTime createdDate;
  final String reason;
  RequestStatus status;

  PermissionRequest({
    required this.id,
    required this.requestType,
    required this.fromDate,
    required this.toDate,
    required this.timeOut,
    required this.timeIn,
    required this.createdDate,
    required this.reason,
    this.status = RequestStatus.pending,
  });
}
