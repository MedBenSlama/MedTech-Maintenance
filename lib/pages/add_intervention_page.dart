// (Dashboard declaration moved below imports to keep directives at file top)
import 'package:flutter/material.dart';
import '../models/intervention_model.dart';

class AddInterventionPage extends StatefulWidget {
  const AddInterventionPage({super.key});

  @override
  _AddInterventionPageState createState() => _AddInterventionPageState();
}

class _AddInterventionPageState extends State<AddInterventionPage> {
  final _formKey = GlobalKey<FormState>();

  final _equipmentNameController = TextEditingController();
  final _technicianNameController = TextEditingController();
  final _problemDescriptionController = TextEditingController();

  @override
  void dispose() {
    _equipmentNameController.dispose();
    _technicianNameController.dispose();
    _problemDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ...existing code - keep this page focused on the "Add Intervention" form

    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle Intervention'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Dashboard removed from this page (keeps UI identical to original request)
              // ...le reste du formulaire...
              TextFormField(
                controller: _equipmentNameController,
                decoration: InputDecoration(
                  labelText: 'Nom de l\'équipement *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medical_services),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de l\'équipement';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _technicianNameController,
                decoration: InputDecoration(
                  labelText: 'Nom du technicien *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _problemDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Description du problème *',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez décrire le problème';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'AJOUTER L\'INTERVENTION',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Créer une nouvelle intervention
      final newIntervention = Intervention.createNew(
        equipmentName: _equipmentNameController.text,
        technicianName: _technicianNameController.text,
        problemDescription: _problemDescriptionController.text,
      );

      // Retourner à la page précédente avec la nouvelle intervention
      Navigator.pop(context, newIntervention);
    }
  }
}
