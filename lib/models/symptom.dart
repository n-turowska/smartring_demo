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
