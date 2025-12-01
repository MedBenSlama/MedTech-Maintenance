import 'package:flutter/material.dart';
import '../models/intervention_model.dart';
import '../services/camera_service.dart';
import 'dart:io';

class InterventionDetailPage extends StatefulWidget {
  final Intervention intervention;
  final int index;
  final Function(int, Intervention) onUpdate;

  const InterventionDetailPage({
    super.key,
    required this.intervention,
    required this.index,
    required this.onUpdate,
  });

  @override
  _InterventionDetailPageState createState() => _InterventionDetailPageState();
}

class _InterventionDetailPageState extends State<InterventionDetailPage> {
  late Intervention _intervention;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _intervention = widget.intervention;
    _notesController.text = _intervention.notes ?? '';
  }

  void _updateIntervention() {
    widget.onUpdate(widget.index, _intervention);
  }

  Future<void> _takePhoto() async {
    final photoPath = await CameraService.takePhoto();
    if (photoPath != null) {
      setState(() {
        _intervention = _intervention.copyWith(photoPath: photoPath);
      });
      _updateIntervention();
      _showSuccessMessage('Photo ajoutée avec succès!');
    }
  }

  Future<void> _pickFromGallery() async {
    final photoPath = await CameraService.pickFromGallery();
    if (photoPath != null) {
      setState(() {
        _intervention = _intervention.copyWith(photoPath: photoPath);
      });
      _updateIntervention();
      _showSuccessMessage('Photo ajoutée avec succès!');
    }
  }

  void _updateStatus(String newStatus) {
    setState(() {
      _intervention = _intervention.copyWith(status: newStatus);
    });
    _updateIntervention();
    _showSuccessMessage('Statut changé à: $newStatus');
  }

  void _updateNotes() {
    setState(() {
      _intervention = _intervention.copyWith(notes: _notesController.text);
    });
    _updateIntervention();
  }

  void _showSuccessMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Détails',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note, size: 22),
            onPressed: () => _showStatusMenu(context),
            tooltip: 'Changer le statut',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            _buildMainInfoCard(),
            const SizedBox(height: 12),
            _buildPhotoCard(),
            const SizedBox(height: 12),
            _buildNotesCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Équipement
            Text(
              _intervention.equipmentName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 12),

            // Statut
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(_intervention.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getStatusColor(_intervention.status),
                ),
              ),
              child: Text(
                _intervention.status,
                style: TextStyle(
                  color: _getStatusColor(_intervention.status),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Informations
            _buildInfoRow(
              Icons.person_outline,
              'Technicien',
              _intervention.technicianName,
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              Icons.calendar_today,
              'Date',
              _formatDate(_intervention.date),
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              Icons.description,
              'Description',
              _intervention.problemDescription,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Photo',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    _buildIconButton(
                      icon: Icons.camera_alt,
                      onPressed: _takePhoto,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    _buildIconButton(
                      icon: Icons.photo_library,
                      onPressed: _pickFromGallery,
                      color: Colors.green.shade700,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPhotoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }

  Widget _buildPhotoSection() {
    final hasPhoto = _intervention.photoPath?.isNotEmpty ?? false;

    if (!hasPhoto) {
      return Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_camera_outlined, size: 40, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'Aucune photo',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if ((_intervention.photoPath?.isNotEmpty ?? false)) {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.all(12),
                  child: InteractiveViewer(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildPhotoImage(_intervention.photoPath!),
                    ),
                  ),
                ),
              );
            }
          },
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildPhotoImage(_intervention.photoPath!),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '✓ Photo enregistrée',
          style: TextStyle(color: Colors.green[600], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPhotoImage(String path) {
    if (path.isEmpty) {
      return _buildPhotoError();
    }
    // Network image
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPhotoError(),
      );
    }
    // Local file image
    try {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPhotoError(),
      );
    } catch (e) {
      return _buildPhotoError();
    }
  }

  Widget _buildPhotoError() {
    return Container(
      color: Colors.grey[100],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.grey),
          SizedBox(height: 8),
          Text('Erreur de chargement', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notes', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                hintText: 'Ajoutez des observations...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
              maxLines: 3,
              onChanged: (value) => _updateNotes(),
            ),
            const SizedBox(height: 4),
            Text(
              'Sauvegardé automatiquement',
              style: TextStyle(color: Colors.grey[500], fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  'Changer le statut',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const Divider(height: 1),
              _buildStatusOption('En Attente', Colors.orange),
              _buildStatusOption('En Cours', Colors.blue),
              _buildStatusOption('Terminée', Colors.green),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fermer'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(String status, Color color) {
    return ListTile(
      dense: true,
      leading: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      title: Text(
        status,
        style: TextStyle(
          fontWeight: _intervention.status == status
              ? FontWeight.w600
              : FontWeight.normal,
          color: _intervention.status == status ? color : Colors.grey[800],
        ),
      ),
      trailing: _intervention.status == status
          ? Icon(Icons.check, size: 20, color: color)
          : null,
      onTap: () {
        Navigator.pop(context);
        _updateStatus(status);
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'En Attente':
        return Colors.orange;
      case 'En Cours':
        return Colors.blue[600]!;
      case 'Terminée':
        return Colors.green[600]!;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}
