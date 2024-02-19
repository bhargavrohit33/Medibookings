import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadDocumentsScreen extends StatefulWidget {
  const UploadDocumentsScreen({super.key});

  @override
  _UploadDocumentsScreenState createState() => _UploadDocumentsScreenState();
}

class _UploadDocumentsScreenState extends State<UploadDocumentsScreen> {
  List<PlatformFile>? _selectedFiles;

  Future<void> _selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt','png','jpeg'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles = result.files;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Documents'),
      ),
      body: ListView(
        children: <Widget>[
          ElevatedButton(
            onPressed: _selectFiles,
            child: const Text('Select Documents to Upload'),
          ),
          if (_selectedFiles != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Selected Documents:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                for (var file in _selectedFiles!)
                  ListTile(
                    title: Text(file.name),
                  ),
                ElevatedButton(
                  onPressed: () {
                    //  upload functionality to be implemented
                  },
                  child: const Text('Upload'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
