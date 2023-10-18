import 'dart:convert';

class MCondition {
  final String text;
  final int code;
  String icon;
  MCondition({
    required this.text,
    required this.code,
    required this.icon,
  }) {
    icon = icon.replaceFirst("//", "https://");
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'code': code,
      'icon': icon,
    };
  }

  factory MCondition.fromMap(Map<String, dynamic> map) {
    return MCondition(
      text: map['text'] as String,
      code: map['code'] as int,
      icon: map['icon'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MCondition.fromJson(String source) =>
      MCondition.fromMap(json.decode(source) as Map<String, dynamic>);
}
