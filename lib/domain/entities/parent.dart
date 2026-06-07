class Parent {
  final int id;
  final String firstName;
  final String babyFirstName;
  final DateTime babyBirthDate;
  final int gestationalAgeWeeks;
  final int stageId;
  final int? coparentId;
  final bool sharingConsent;
  final DateTime createdAt;

  const Parent({
    required this.id,
    required this.firstName,
    required this.babyFirstName,
    required this.babyBirthDate,
    required this.gestationalAgeWeeks,
    required this.stageId,
    this.coparentId,
    required this.sharingConsent,
    required this.createdAt,
  });

  Parent copyWith({
    int? id,
    String? firstName,
    String? babyFirstName,
    DateTime? babyBirthDate,
    int? gestationalAgeWeeks,
    int? stageId,
    int? coparentId,
    bool? sharingConsent,
    DateTime? createdAt,
  }) {
    return Parent(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      babyFirstName: babyFirstName ?? this.babyFirstName,
      babyBirthDate: babyBirthDate ?? this.babyBirthDate,
      gestationalAgeWeeks: gestationalAgeWeeks ?? this.gestationalAgeWeeks,
      stageId: stageId ?? this.stageId,
      coparentId: coparentId ?? this.coparentId,
      sharingConsent: sharingConsent ?? this.sharingConsent,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
