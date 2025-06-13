import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _searchInput = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchInput,
      decoration: InputDecoration(
        labelText: 'Search Room',
        prefixIcon: Icon(
          Icons.search,
        ),
        border: OutlineInputBorder(),
      ),
    );
  }
}
