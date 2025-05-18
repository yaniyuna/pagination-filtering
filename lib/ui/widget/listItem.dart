import 'package:flutter/material.dart';
import 'package:learn_pagination/model/petani.dart';

class PetaniListItem extends StatelessWidget {
  final Petani petani;
  final VoidCallback? onTap;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PetaniListItem({
    super.key,
    required this.petani,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final String baseUrl = 'https://dev.wefgis.com/';
    final String FotoUrl = baseUrl + petani.foto;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: petani.foto.isNotEmpty
                        ? NetworkImage('https://dev.wefgis.com/${petani.foto}')
                        : const AssetImage('assets/default_avatar.png') as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      petani.nama,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('NIK: ${petani.nik}'),
                    Text('Kelompok: ${petani.namaKelompok}'),
                    Text('Status: ${petani.status}'),
                  ],
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: onEdit,
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                    tooltip: 'Hapus',
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
