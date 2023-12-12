import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfCreater extends StatefulWidget {
  const PdfCreater({super.key});

  @override
  State<PdfCreater> createState() => _PdfCreaterState();
}

class _PdfCreaterState extends State<PdfCreater> {
  List<String> emailList = [];
  final emailController = TextEditingController();
  Future<void> saveAsPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            children: emailList
                .map(
                  (email) => pw.Text(email),
                )
                .toList(),
          );
        },
      ),
    );

    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    final path = '/storage/emulated/0/Download/$timeStamp.pdf';

    // Save the PDF to the device
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    showMessage('PDF saved at: $path');
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
        title: const Text('PDF Creater'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter Email',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  emailList.insert(0, emailController.text);
                  emailController.clear();
                });
              },
              child: const Text('Add Email'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: emailList.length,
                itemBuilder: (context, index) {
                  return Text(
                    '${index + 1}. ${emailList[index]}',
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveAsPDF();
        },
        child: const Icon(Icons.create),
      ),
    );
  }
}
