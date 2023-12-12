import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pw;

class ImageToPdfConversion extends StatefulWidget {
  const ImageToPdfConversion({super.key});

  @override
  State<ImageToPdfConversion> createState() => _ImageToPdfConversionState();
}

class _ImageToPdfConversionState extends State<ImageToPdfConversion> {
  final List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    setState(() {
      // _selectedImages = pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
      for (var item in pickedImages) {
        _selectedImages.insert(0, File(item.path));
      }
    });
  }

  void imageDelete(int index) {
    _selectedImages.removeAt(index);
    setState(() {});
  }

  Future<void> _convertToPdf() async {
    if (_selectedImages.isEmpty) {
      showMessage('Please Select Image');
    } else {
      final pdf = pw.Document();
      for (var imageFile in _selectedImages) {
        final image = pw.MemoryImage(File(imageFile.path).readAsBytesSync());
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(child: pw.Image(image));
            },
          ),
        );
      }
      final timeStamp = DateTime.now().millisecondsSinceEpoch;
      final output = File('/storage/emulated/0/Download/$timeStamp.pdf');
      await output.writeAsBytes(await pdf.save());
      showMessage('Pdf Saved !');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image To PDF'),
        actions: [
          TextButton(
            onPressed: () {
              _convertToPdf();
            },
            child: const Text('Create Pdf'),
          )
        ],
      ),
      body: _selectedImages.isEmpty
          ? Center(
              child: ElevatedButton(
                onPressed: () {
                  _pickImages();
                },
                child: const Text('Select Images'),
              ),
            )
          : GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              children: [
                for (var index = 0; index < _selectedImages.length; index++)
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.file(
                          _selectedImages[index],
                          fit: BoxFit.contain,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: CircleAvatar(
                            child: IconButton(
                              onPressed: () {
                                imageDelete(index);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Image',
        onPressed: () {
          _pickImages();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
