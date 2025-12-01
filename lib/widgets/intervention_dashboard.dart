import 'package:flutter/material.dart';

class InterventionDashboard extends StatelessWidget {
  final int doneCount;
  final int inProgressCount;
  final int pendingCount;

  const InterventionDashboard({
    super.key,
    required this.doneCount,
    required this.inProgressCount,
    required this.pendingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStat('Terminée', doneCount, Colors.green),
            _buildStat('En Cours', inProgressCount, Colors.blue),
            _buildStat('En Attente', pendingCount, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
