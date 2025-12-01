class Intervention {
  final String equipmentName;
  final String technicianName;
  final DateTime date;
  final String problemDescription;
  final String status;
  final String? photoPath; // Chemin de la photo
  final String? notes; // Notes supplémentaires

  Intervention({
    required this.equipmentName,
    required this.technicianName,
    required this.date,
    required this.problemDescription,
    required this.status,
    this.photoPath,
    this.notes,
  });

  // Méthode pour créer une intervention
  factory Intervention.createNew({
    required String equipmentName,
    required String technicianName,
    required String problemDescription,
  }) {
    return Intervention(
      equipmentName: equipmentName,
      technicianName: technicianName,
      date: DateTime.now(),
      problemDescription: problemDescription,
      status: 'En Attente',
    );
  }

  // Copier avec modifications
  Intervention copyWith({
    String? equipmentName,
    String? technicianName,
    DateTime? date,
    String? problemDescription,
    String? status,
    String? photoPath,
    String? notes,
  }) {
    return Intervention(
      equipmentName: equipmentName ?? this.equipmentName,
      technicianName: technicianName ?? this.technicianName,
      date: date ?? this.date,
      problemDescription: problemDescription ?? this.problemDescription,
      status: status ?? this.status,
      photoPath: photoPath ?? this.photoPath,
      notes: notes ?? this.notes,
    );
  }
}
