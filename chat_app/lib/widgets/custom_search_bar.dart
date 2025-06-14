import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _searchInput = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  late final Stream<QuerySnapshot> _roomsStream;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    _roomsStream = firestore
        .collection('rooms')
        .where('members', arrayContains: currentUserId)
        .orderBy('lastUpdate', descending: true)
        .snapshots();

    _searchInput.addListener(() {
      setState(() {});
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

  bool get _showSuggestions =>
      _searchInput.text.trim().isNotEmpty && _isFocused;

  List<QueryDocumentSnapshot> _filterRooms(QuerySnapshot snapshot) {
    final query = _searchInput.text.toLowerCase();
    return snapshot.docs.where((doc) {
      final name = doc['name']?.toString().toLowerCase() ?? '';
      return name.contains(query);
    }).toList();
  }

  Widget _buildMainList(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Center(
        child: Text(
          'You are not in any rooms yet.',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
        ),
      );
    }

    final docs = snapshot.data!.docs;

    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final room = docs[index].data() as Map<String, dynamic>;
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(206, 202, 221, 230),
                  const Color.fromARGB(255, 154, 173, 247),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(
            vertical: 3.2,
            horizontal: 2,
          ),
          child: ListTile(
            title: Text(room['name'] ?? 'Unnamed Room'),
            subtitle: Text(
                'Created at: ${DateTime.fromMillisecondsSinceEpoch(room['createdAt'].millisecondsSinceEpoch)}'),
            onTap: () {
              print('Tapped on room: ${room['name']}');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatScreen(doc: docs[index],),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSuggestions(AsyncSnapshot<QuerySnapshot> snapshot) {
    final filtered = _filterRooms(snapshot.data!);

    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: filtered.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'No matching rooms found.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final room = filtered[index].data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(room['name']),
                  onTap: () {
                    print(
                        'Suggested room selected: ${room['name']} ${filtered[index].id}');
                    _searchInput.clear();
                    _focusNode.unfocus();
                  },
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(
          controller: _searchInput,
          focusNode: _focusNode,
          elevation: const WidgetStatePropertyAll(4),
          leading: const Icon(Icons.search),
          backgroundColor: const WidgetStatePropertyAll(Colors.white70),
          hintText: 'Search your rooms...',
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 15),
          ),
        ),
        const SizedBox(height: 13),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _roomsStream,
            builder: (context, snapshot) {
              return Stack(
                children: [
                  Visibility(
                    visible: !_showSuggestions,
                    child: _buildMainList(snapshot),
                  ),
                  if (_showSuggestions) _buildSuggestions(snapshot),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
