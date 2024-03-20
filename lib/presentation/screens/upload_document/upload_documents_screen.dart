import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/snack_bar.dart';
import 'package:medibookings/service/auth_service.dart';
import 'package:medibookings/service/hospital/hospital_service.dart';
import 'package:medibookings/service/nurse/nurse_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class UploadDocumentsScreen extends StatefulWidget {
  bool isFromNurse;
   UploadDocumentsScreen({required this.isFromNurse , super.key});

  @override
  _UploadDocumentsScreenState createState() => _UploadDocumentsScreenState();
}

class _UploadDocumentsScreenState extends State<UploadDocumentsScreen> {
  List<PlatformFile>? _selectedFiles;

  bool _isPickingFiles = false; // Flag to track file picker state
  bool _isUploading = false;
  Future<void> _selectFiles() async {
    if (_isPickingFiles) return; // Return if file picker is already active

    _isPickingFiles = true; // Set flag to prevent multiple attempts

    // Check for storage permission
    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      var result = await Permission.storage.request();
      if (result != PermissionStatus.granted) {
        _showPermissionDeniedDialog();
        return;
      }
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'png', 'jpeg'],
      );

      if (result != null) {
        setState(() {
          _selectedFiles = result.files;
        });
      }
    } catch (e) {
      // Improved error handling
      print("Error picking files: $e");
      if (!context.mounted) return;
      custom_snackBar(context, "An error occurred while selecting files: ${e.toString()}");
    } finally {
      // Ensure flag is reset regardless of success or error
      _isPickingFiles = false;
    }
  }
void _showPermissionDeniedDialog() {
final theme = Theme.of(context);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Storage Access Required'),
      content: const Text(
          'This app needs access to your storage to select files. Please grant permission in the app settings.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child:  Text('Cancel',style: TextStyle(color: theme.scaffoldBackgroundColor),),
        ),
        TextButton(
          
          onPressed: () => openAppSettings(),
          child:  Text('Open Settings',style: TextStyle(color: theme.scaffoldBackgroundColor)),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final hospitalService = Provider.of<HospitalService>(context);
    final nurseService = Provider.of<NurseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Documents'),
      ),
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              
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
                    
                  ],
                ),
          
                ElevatedButton(
                      onPressed: _selectFiles,
                      child: const Text('Upload'),
                    ),
            ],
          ),
          if (_isUploading)
            commonLoading(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: basicButton(onPressed: ()async{
            setState(() {
              _isUploading = true;
            });
            try {
              if(widget.isFromNurse){
                  await authService.documentsuploadForNurse(_selectedFiles!, nurseService);
              }
              else{
                  await authService.documentsuploadForHospital(_selectedFiles!, hospitalService);
              }
            
              if (!context.mounted) return;
              custom_snackBar(context, "Files successfully uploaded");
              Navigator.pushReplacementNamed(context, RouteName.appWrapper);
            } catch (e) {
              if (!context.mounted) return;
              custom_snackBar(context, "An error occurred while uploading files");
            } finally {
              setState(() {
                _isUploading = false;
              });
            }
        }, text: "Upload"),
      ),
    );
  }
}
