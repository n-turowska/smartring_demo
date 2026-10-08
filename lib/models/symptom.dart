//dodanie enum, zeby byly dwie kategorie i nie bylo mozliwosci literowek, jesli by sie zrobilo jako String
enum SymptomCategory { physical, mood }

class SymptomType {
  final String id;
  final String name;
  final String namePolish;
  final SymptomCategory category;
  final String icon;

  const SymptomType({
    required this.id,
    required this.name,
    required this.namePolish,
    required this.category,
    required this.icon,
  });
}

class Symptom {
  final int? id;
  final DateTime date;
  final String symptomType;
  final SymptomCategory category;
  final int intensity; //1-5
  final String? notes;
  final String created_at;

  const Symptom({
    required this.id,
    required this.date,
    required this.symptomType,
    required this.category,
    required this.intensity,
    this.notes,
    required this.created_at,
  });

  Map<String, dynamic> toMap() {
    //zeby zamienialo na typy ktore "rozumie" SQLite, czyli int, String, double, null, bo nie rozumie tych "dartowych" obiektow jak np DateTime i enum
    return {
      'id': id,
      'date':
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'symptom_type': symptomType,
      'category': category.name,
      'intensity': intensity,
      'notes': notes,
      'created_at': created_at,
    };
  }

  factory Symptom.fromMap(Map<String, dynamic> map) {
    //tworzenie obiektu Symptom na podstawie danych pobranych z bazy(map)
    return Symptom(
      id: map['id'],
      date: DateTime.parse(map['date']),
      symptomType: map['symptom_type'],
      category: SymptomCategory.values.firstWhere(
        (e) => e.name == map['category'],
      ),
      intensity: map['intensity'],
      notes: map['notes'],
      created_at: map['created_at'],
    );
  }
}
