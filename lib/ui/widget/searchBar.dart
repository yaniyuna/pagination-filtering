import 'package:flutter/material.dart';
import 'package:learn_pagination/model/petani.dart';

class Searchbar extends StatefulWidget {
  // const Searchbar({super.key});
  final List<Petani> allPetani;
  final Function(List<Petani>) onResultsChanged;


  final Function(String searchQuery, Map<String, String> filters)? onSearchChanged;
  
  const Searchbar({
    Key? key,
    required this.allPetani,
    required this.onResultsChanged,
    this.onSearchChanged,
  }) : super(key: key);

  @override
  _SearchbarState createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  
  String _searchQuery = '';
  final Map<String, String> _filters = {};

  void _applySearchAndFilter() {
    final results = widget.allPetani.where((petani) {
      final matchesSearch = _searchQuery.isEmpty || 
          petani.matchesSearchQuery(_searchQuery);
      final matchesFilter = _filters.isEmpty || 
          petani.matchesFilterCriteria(_filters);
      return matchesSearch && matchesFilter;
    }).toList();

    widget.onResultsChanged(results); // buat kirim hasil ke parent widget
    if (widget.onSearchChanged != null) {
      widget.onSearchChanged!(_searchQuery, _filters);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        TextField(
          decoration: InputDecoration(
            labelText: 'Cari Petani',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
              _applySearchAndFilter();
            });
          },
        ),
        // Wrap(
        //   spacing: 8.0,
        //   children: [
        //     FilterChip(
        //       label: Text('Status: Aktif'),
        //       selected: _filters['status'] == 'aktif',
        //       onSelected: (selected) {
        //         setState(() {
        //           if (selected) {
        //             _filters['status'] = 'aktif';
        //           } else {
        //             _filters.remove('status');
        //           }
        //           _applySearchAndFilter();
        //         });
        //       },
        //     ),
            
        //   ],
        // ),
      ],
    );
  }
}