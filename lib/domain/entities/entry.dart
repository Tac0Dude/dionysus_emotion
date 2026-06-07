class Entry {
  final int id;
  final int parentId;
  final int emotionId;
  final int intensity;
  final int? activityId;
  final int? locationId;
  final DateTime createdAt;

  const Entry({
    required this.id,
    required this.parentId,
    required this.emotionId,
    required this.intensity,
    this.activityId,
    this.locationId,
    required this.createdAt,
  });
}
