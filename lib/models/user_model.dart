class EmpowerHerUser {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? profileImageUrl;

  final String? language; // e.g., "Hindi", "Marathi"
  final String? region; // e.g., "Bihar", "Rajasthan"

  final List<String>? skills; // e.g., ["stitching", "embroidery"]
  final List<String>? categories; // e.g., ["Art & Craft", "Cooking"]

  final String? learningLevel; // e.g., "Beginner", "Intermediate"
  final String? preferredJobType; // e.g., "Remote", "Part-time"
  final String? currentGoal; // e.g., "Start own sewing business"
  final int? age;

  final DateTime? joinedAt;
  final bool isMentor; // if promoted as local helper

  EmpowerHerUser({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.profileImageUrl,
    this.language,
    this.region,
    this.skills,
    this.categories,
    this.learningLevel,
    this.preferredJobType,
    this.currentGoal,
    this.age,
    this.joinedAt,
    this.isMentor = false,
  });

  factory EmpowerHerUser.fromJson(Map<String, dynamic> json) {
    return EmpowerHerUser(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
      language: json['language'],
      region: json['region'],
      skills: (json['skills'] as List?)?.map((e) => e.toString()).toList(),
      categories:
          (json['categories'] as List?)?.map((e) => e.toString()).toList(),
      learningLevel: json['learningLevel'],
      preferredJobType: json['preferredJobType'],
      currentGoal: json['currentGoal'],
      age: json['age'],
      joinedAt:
          json['joinedAt'] != null ? DateTime.parse(json['joinedAt']) : null,
      isMentor: json['isMentor'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'language': language,
      'region': region,
      'skills': skills,
      'categories': categories,
      'learningLevel': learningLevel,
      'preferredJobType': preferredJobType,
      'currentGoal': currentGoal,
      'age': age,
      'joinedAt': joinedAt?.toIso8601String(),
      'isMentor': isMentor,
    };
  }

  EmpowerHerUser copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? profileImageUrl,
    String? language,
    String? region,
    List<String>? skills,
    List<String>? categories,
    String? learningLevel,
    String? preferredJobType,
    String? currentGoal,
    int? age,
    DateTime? joinedAt,
    bool? isMentor,
  }) {
    return EmpowerHerUser(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      language: language ?? this.language,
      region: region ?? this.region,
      skills: skills ?? this.skills,
      categories: categories ?? this.categories,
      learningLevel: learningLevel ?? this.learningLevel,
      preferredJobType: preferredJobType ?? this.preferredJobType,
      currentGoal: currentGoal ?? this.currentGoal,
      age: age ?? this.age,
      joinedAt: joinedAt ?? this.joinedAt,
      isMentor: isMentor ?? this.isMentor,
    );
  }
}
