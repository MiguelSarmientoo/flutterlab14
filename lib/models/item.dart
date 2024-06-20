// lib/models/item.dart

class Item {
  int? id;
  String name;
  DateTime date;
  int quantity;
  bool isAvailable;

  Item({
    this.id,
    required this.name,
    required this.date,
    required this.quantity,
    required this.isAvailable,
  });

  // Método para convertir un objeto Item a un mapa para guardarlo en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(), // Convertir DateTime a formato de texto ISO 8601
      'quantity': quantity,
      'isAvailable': isAvailable ? 1 : 0, // Guardar bool como 1 o 0 en la base de datos
    };
  }

  @override
  String toString() {
    return 'Item{id: $id, name: $name, date: $date, quantity: $quantity, isAvailable: $isAvailable}';
  }
}
