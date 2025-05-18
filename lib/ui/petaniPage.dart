import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:learn_pagination/model/petani.dart';
import 'package:learn_pagination/services/apiStatic.dart';
import 'package:learn_pagination/ui/petaniFormPage.dart';
// import 'package:learn_pagination/ui/listPage.dart';
import 'package:learn_pagination/ui/widget/listItem.dart';
import 'package:learn_pagination/ui/widget/searchBar.dart';

class PetaniPage extends StatefulWidget {
  const PetaniPage({super.key});

  @override
  State<PetaniPage> createState() => _PetaniPageState();
}

class _PetaniPageState extends State<PetaniPage> {

  static const _pageSize = 10;

  // final PagingController<int, Petani> _pagingController=PagingController(firstPageKey: 0);
  // late TextEditingController _s;
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // late String _publish="Y";
  // int _pageSize=3;
  late final _pagingController = PagingController<int, Petani>(
    getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
    // fetchPage: (pageKey) => ApiStatic.getPetaniFilter(pageKey, '', 'Y'),
    fetchPage: (pageKey) =>
      ApiStatic.getPetaniFilter(pageKey, _searchQuery, _filters['status'] ?? 'Y'),
  
  );

  String _searchQuery = '';
  final Map<String, String> _filters = {};

  void _handleSearchChanged(String searchQuery, Map<String, String> filters) {
    _searchQuery = searchQuery;
    _filters.clear();
    _filters.addAll(filters);
    _pagingController.refresh(); // Ulangi fetch data dengan query baru
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Petani')),
      // body: PagingListener(
      //   controller: _pagingController,
      //   builder: (context, state, fetchNextPage) => PagedListView<int, Petani>(
      //     state: state,
      //     fetchNextPage: fetchNextPage,
      //     builderDelegate: PagedChildBuilderDelegate<Petani>(
      //       itemBuilder: (context, petani, index) => PetaniListItem(petani : petani),
      //     ),
      //   ),
      // ),

      body: Column(
        children: [
          // Tambahkan Searchbar di atas
          Searchbar(
            allPetani: const [], // Tidak digunakan karena pakai paging
            onResultsChanged: (data) {}, // Diabaikan
            onSearchChanged: _handleSearchChanged, // Ini yang penting
          ),
          Expanded(
            child: PagingListener(
              controller: _pagingController,
              builder: (context, state, fetchNextPage) => PagedListView<int, Petani>(
                state: state,
                fetchNextPage: fetchNextPage,
                builderDelegate: PagedChildBuilderDelegate<Petani>(
                  itemBuilder: (context, petani, index) =>PetaniListItem(
                    petani: petani,
                    onEdit: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetaniFormPage(petani: petani,),
                        ),
                      );
                      if (result == true) {
                        _pagingController.refresh();
                      }
                    },
                    onDelete: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Konfirmasi Hapus'),
                          content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        final success = await ApiStatic.deletePetani(petani.idPenjual);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Data berhasil dihapus')),
                          );
                          _pagingController.refresh();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Gagal menghapus data')),
                          );
                        }
                      }
                    },
                    
                    ),
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PetaniFormPage()),
          );

          if (result == true) {
            setState(() {
            _searchQuery = '';
            _filters.clear();
          });
            _pagingController.refresh();
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Tambah Petani',
      ),

    );
  }
}