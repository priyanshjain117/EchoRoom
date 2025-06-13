import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchInput = TextEditingController();
  final _focusNode = FocusNode();

  List<Map<String, dynamic>> myRooms = [];
  List<Map<String, dynamic>> suggestedRooms = [];

  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  bool _isFocused = false;

  Future<void> fetchUserRooms() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('members', arrayContains: currentUserId)
        .get();

    final userRooms =
        snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();

    setState(() {
      myRooms = userRooms;
    });
  }

  void _updateSuggestion(String search) {
    if (search.trim().isEmpty) {
      setState(() => suggestedRooms = []);
      return;
    }

    setState(() {
      suggestedRooms = myRooms
          .where((room) => room['name']
              .toString()
              .toLowerCase()
              .contains(search.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserRooms();
    _searchInput.addListener(() {
      _updateSuggestion(_searchInput.text);
    });
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchInput.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _showSuggestions => _searchInput.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(
          controller: _searchInput,
          focusNode: _focusNode,
          elevation: WidgetStatePropertyAll(5),
          leading: const Icon(Icons.search),
          backgroundColor: const WidgetStatePropertyAll(Colors.white70),
          hintText: 'Search',
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 15),
          ),
          onChanged: (query) {},
        ),
        if (_showSuggestions && _isFocused)
          Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            child: suggestedRooms.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'No matching rooms found.',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: suggestedRooms.length,
                    itemBuilder: (context, index) {
                      final room = suggestedRooms[index];
                      return ListTile(
                        title: Text(room['name']),
                        onTap: () {
                            print('recommended room: ${room['name']}');
                          _searchInput.text = ''; 
                          _focusNode.unfocus(); 
                        },
                      );
                    },
                  ),
          ),
        const SizedBox(height: 10),
        Expanded(
          child: myRooms.isEmpty
              ? Center(
                  child: Text(
                  'You are not in any rooms yet.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.white70, fontWeight: FontWeight.w600),
                ))
              : ListView.builder(
                  itemCount: myRooms.length,
                  itemBuilder: (context, index) {
                    final room = myRooms[index];
                    return Card(
                      color: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(room['name']),
                        subtitle:
                            Text('Created by: ${room['creator'] ?? 'N/A'}'),
                        onTap: () {
                          print('Tapped on your room: ${room['name']}');
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
