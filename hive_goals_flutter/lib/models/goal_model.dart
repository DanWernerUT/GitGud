class Goal {
  final int? id;
  final String name;
  final String text;
  final String? tags;
  final int? duration;

  const Goal({
    this.id,
    required this.name,
    required this.text,
    this.tags,
    this.duration,
  });

  factory Goal.fromMap(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as int?,
      name: (json['name'] as String?) ?? '',
      text: (json['text'] as String?) ?? '',
      tags: json['tags'] as String?,
      duration: json['duration'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'text': text,
      'tags': tags,
      'duration': duration,
    };
  }
}

