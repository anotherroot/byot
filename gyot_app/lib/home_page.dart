import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // A controller to manage the text in the TextField.
  final TextEditingController _textController = TextEditingController();

  // This method will handle picking a file from the device using the file_picker package.
  void _pickFile() async {
    // Use the file_picker package to open the file selection dialog.
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf', 'epub'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final extension = result.files.single.extension;
      String textContent = '';

      if (extension == 'txt') {
        // For .txt files, we can read the content directly.
        try {
          textContent = await file.readAsString();
        } catch (e) {
          textContent = "Error reading file: $e";
        }
      } else {
        // For complex files like PDF or EPUB, you need specific libraries to parse them.
        // This example just shows the file path.
        textContent =
            "Parsing for .$extension files requires a specific library.\nFile path: ${file.path}";
      }

      // Once the text is loaded, save it.
      _textController.text = textContent;
      _addSource();
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file selected.'),
        ),
      );
    }
  }

  // New method to show a dialog for pasting text.
  Future<void> _showPasteTextDialog() async {
    // You could pre-populate with clipboard content if you want.
    // final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    // if (clipboardData != null) {
    //   _textController.text = clipboardData.text ?? '';
    // }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Paste Your Text'),
          content: TextField(
            controller: _textController,
            autofocus: true,
            maxLines: 10,
            decoration: const InputDecoration(
              hintText: 'Paste content here...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                _addSource(); // Call the save method after dialog closes.
              },
            ),
          ],
        );
      },
    );
  }

  // This method will handle saving the text content to a local file.
  void _addSource() async {
    final String text = _textController.text;
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot save empty source.'),
        ),
      );
      return;
    }

    try {
      // Use path_provider to find the correct local directory.
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/my_source.txt';
      final file = File(filePath);

      // Write the text from the controller to the file.
      await file.writeAsString(text);

      // Show a confirmation message with the file path.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Source saved successfully to: $filePath'),
        ),
      );
      // Clear the text controller for the next input.
      _textController.clear();
    } catch (e) {
      // Show an error message if saving fails.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving file: $e'),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Left Button: Import File
          _buildSourceButton(
              icon: Icons.file_upload_outlined,
              label: 'Import File',
              width: 120,
              height: 160,
              onTap: _pickFile,
              borderRadius: BorderRadius.circular(16)),

          const SizedBox(width: 20),

          // Right Button: Paste Text
          _buildSourceButton(
              icon: Icons.paste,
              label: 'Paste Text',
              width: 120,
              height: 160,
              onTap: _showPasteTextDialog,
              borderRadius: BorderRadius.circular(16)),
        ],
      ),
    );
  }

  // Helper widget to build the stylish square buttons to avoid code repetition.
  Widget _buildSourceButton({
    required IconData icon,
    required String label,
    required double width,
    required double height,
    required VoidCallback onTap,
    required BorderRadius borderRadius,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: borderRadius,
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.3),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: width * 0.4, color: Colors.green[800]),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
