import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image/image.dart' as img;

class ImageResizeScreen extends StatefulWidget {
  const ImageResizeScreen({super.key});

  @override
  State<ImageResizeScreen> createState() => _ImageResizeScreenState();
}

class _ImageResizeScreenState extends State<ImageResizeScreen> {
  String? originalImagePath;
  String? resizedImagePath;
  final height = TextEditingController();
  final width = TextEditingController();

  Future<void> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() {
        originalImagePath = image.path;
        resizedImagePath = null;
      });
    } catch (e) {
      return;
    }
  }

  Future<void> resizeAndSaveImage(int width, int height) async {
    if (originalImagePath == null) return;

    final originalBytes = File(originalImagePath!).readAsBytesSync();
    final originalImage = img.decodeImage(Uint8List.fromList(originalBytes));

    final resizedImage = img.copyResize(originalImage!, width: width, height: height);

    final timeStamp = DateTime.now().millisecondsSinceEpoch;

    final resizedPath = '/storage/emulated/0/Download/$timeStamp.png';

    File(resizedPath).writeAsBytesSync(Uint8List.fromList(img.encodePng(resizedImage)));

    final result = await ImageGallerySaver.saveFile(resizedPath);

    if (result['isSuccess']) {
      setState(() {
        resizedImagePath = resizedPath;
      });
      showMessage('Image Saved in Gallery');
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
        title: const Text('Resize Image'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => pickImage(),
            child: Container(
              width: 300,
              height: 350,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: originalImagePath == null
                  ? const Center(
                      child: Text(
                        'Select Image',
                      ),
                    )
                  : Image.file(
                      resizedImagePath == null ? File(originalImagePath!) : File(resizedImagePath!),
                      fit: BoxFit.contain,
                      width: 300,
                      height: 350,
                    ),
            ),
          ),
          const Text(
            'Change Image Pixels',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 130,
                child: TextField(
                  controller: width,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                    hintText: 'Width',
                  ),
                ),
              ),
              SizedBox(
                width: 130,
                child: TextField(
                  controller: height,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                    hintText: 'height',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          ElevatedButton(
              onPressed: () {
                resizeAndSaveImage(int.parse(width.text), int.parse(height.text));
              },
              child: const Text('Resized Image'))
        ],
      ),
    );
  }
}
