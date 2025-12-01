import 'package:flutter/material.dart';
import 'add_intervention_page.dart';
import 'login_page.dart';
import 'intervention_detail_page.dart';
import '../widgets/intervention_dashboard.dart';
import '../models/intervention_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Intervention> interventions = [];

  void _updateIntervention(int index, Intervention updatedIntervention) {
    setState(() {
      interventions[index] = updatedIntervention;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MedTech Maintenance'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Se déconnecter',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final ok = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Déconnexion'),
                  content: const Text('Voulez-vous vous déconnecter ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Non'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Oui'),
                    ),
                  ],
                ),
              );

              if (ok == true) {
                // Clear navigation stack and go to LoginPage
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (c) => const LoginPage()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          children: [
            InterventionDashboard(
              doneCount: interventions
                  .where((i) => i.status == 'Terminée')
                  .length,
              inProgressCount: interventions
                  .where((i) => i.status == 'En Cours')
                  .length,
              pendingCount: interventions
                  .where((i) => i.status == 'En Attente')
                  .length,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: interventions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.medical_services,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Aucune intervention',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[500],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Cliquez sur + pour ajouter une intervention',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: interventions.length,
                      itemBuilder: (context, index) {
                        final intervention = interventions[index];
                        return Card(
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            leading: Icon(
                              Icons.medical_services,
                              color: Colors.blue,
                            ),
                            title: Text(
                              intervention.equipmentName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Technicien: ${intervention.technicianName}',
                                ),
                                Text('Statut: ${intervention.status}'),
                                if (intervention.photoPath != null)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.photo_camera,
                                        size: 16,
                                        color: Colors.green,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Photo disponible',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InterventionDetailPage(
                                    intervention: intervention,
                                    index: index,
                                    onUpdate: _updateIntervention,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddInterventionPage()),
          );

          if (result != null) {
            setState(() {
              interventions.add(result);
            });
          }
        },
        backgroundColor: Colors.blue[700],
        child: Icon(Icons.add),
      ),
    );
  }
}
