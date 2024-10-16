import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Colors.grey[950],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                filled: false, // Remove background color
                // Add border with color
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors.grey, // Border color
                    width: 1.5, // Border width
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors.grey, // Border color when focused
                    width: 1.0, // Border width when focused
                  ),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey), // Search icon
              ),
              style: TextStyle(color: Colors.grey[700]), // Text color
              cursorColor: Colors.grey[500], // Cursor color
            ),
            SizedBox(height: 20,),
            Row(
              children: [

                FilterChip(

                  label: Text('Education', style: TextStyle(color: Colors.grey[500])),
                  selected: false,
                  backgroundColor: Colors.grey[950],
                  selectedColor: Colors.grey,
                  onSelected: (bool selected) {
                    // Handle filter logic here
                  },
                ),
                const SizedBox(height: 20, width: 20,),
              ],
            ),
            SizedBox(height: 20),
            // Add your search results widget here
            Expanded(
              child: Center(
                child: Text(
                  'Search results will appear here.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),

      backgroundColor: Colors.grey[950], // Background color of the screen
    );
  }
}