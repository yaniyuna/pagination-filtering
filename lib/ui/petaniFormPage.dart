import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:learn_pagination/model/petani.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class PetaniFormPage extends StatefulWidget {
  final Petani? petani;
  const PetaniFormPage({super.key, this.petani});

  @override
  State<PetaniFormPage> createState() => _PetaniFormPageState();
}

class _PetaniFormPageState extends State<PetaniFormPage> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  final _picker = ImagePicker();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _telpController = TextEditingController();

  String? _selectedKelompok;
  String? _selectedStatus;

  final List<String> _kelompokOptions = ['Kelompok A', 'Kelompok B', 'Kelompok C'];
  final List<String> _statusOptions = ['Aktif', 'Tidak Aktif'];

  // Pemetaan nama kelompok ke ID kelompok
  final Map<String, String> _kelompokIdMap = {
    'Kelompok A': '1',
    'Kelompok B': '2',
    'Kelompok C': '3',
  };

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> submitPetaniData({
    required String nama,
    required String nik,
    required String alamat,
    required String telp,
    required String kelompok,
    required String status,
    File? fotoFile,
  }) async {
    final uri = Uri.parse('https://dev.wefgis.com/api/petani');
    final request = http.MultipartRequest('POST', uri)
      ..fields['nama'] = nama
      ..fields['nik'] = nik
      ..fields['alamat'] = alamat
      ..fields['telp'] = telp
      ..fields['id_kelompok_tani'] = _kelompokIdMap[kelompok] ?? ''
      ..fields['status'] = status;

    if (fotoFile != null) {
      final mimeType = lookupMimeType(fotoFile.path);
      final multipartFile = await http.MultipartFile.fromPath(
        'foto',
        fotoFile.path,
        contentType: mimeType != null ? MediaType.parse(mimeType) : null,
      );
      request.files.add(multipartFile);
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(' Data berhasil dikirim');
      print(' Response: $responseBody');
    } else {
      print(' Gagal kirim data (${response.statusCode})');
      print(' Error: $responseBody');
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await submitPetaniData(
        nama: _namaController.text,
        nik: _nikController.text,
        alamat: _alamatController.text,
        telp: _telpController.text,
        kelompok: _selectedKelompok ?? '',
        status: _selectedStatus ?? '',
        fotoFile: _selectedImage,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil dikirim')),
      );

      Navigator.pop(context, true); 
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.petani != null) {
      _namaController.text = widget.petani!.nama;
      _nikController.text = widget.petani!.nik;
      _alamatController.text = widget.petani!.alamat;
      _telpController.text = widget.petani!.telp;
      // _selectedKelompok = widget.petani!.namaKelompok;
      // _selectedStatus = widget.petani!.status;

      if (_kelompokOptions.contains(widget.petani!.namaKelompok)) {
        _selectedKelompok = widget.petani!.namaKelompok;
      }

      if (_statusOptions.contains(widget.petani!.status)) {
        _selectedStatus = widget.petani!.status;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Petani')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : const Center(child: Text('Pilih Foto')),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _nikController,
                decoration: InputDecoration(labelText: 'NIK'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _telpController,
                decoration: InputDecoration(labelText: 'Telepon'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedKelompok,
                decoration: InputDecoration(labelText: 'Kelompok Tani'),
                items: _kelompokOptions
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedKelompok = val),
                validator: (value) => value == null ? 'Pilih salah satu' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(labelText: 'Status'),
                items: _statusOptions
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedStatus = val),
                validator: (value) => value == null ? 'Pilih salah satu' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
