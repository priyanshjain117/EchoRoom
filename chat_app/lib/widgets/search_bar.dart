import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  List<Map<String, dynamic>> allRooms = [];
  List<Map<String, dynamic>>  recomendedRooms = [];
  final _searchInput = TextEditingController();

  Future<void> _loadRooms() async {
    final snapshot=await FirebaseFirestore.instance.collection('rooms').get();
    final rooms=snapshot.docs.map((doc)=>doc.data(),).toList();
    setState(() {
      allRooms=rooms;
    });
  }



  @override
  Future<void> initState() async {
    super.initState();
    _loadRooms();
    _searchInput.addListener((){});
  }

  @override
  void dispose() {
    _searchInput.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchInput,
          decoration: InputDecoration(
            labelText: 'Search Room',
            prefixIcon: Icon(
              Icons.search,
            ),
            border: OutlineInputBorder(),
          ),
        ),
        // ListView.builder(itemCount: ,itemBuilder: )
      ],
    );
  }
}
