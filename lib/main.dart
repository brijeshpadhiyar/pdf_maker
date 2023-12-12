import 'package:flutter/material.dart';
import 'package:pdf_maker/screens/image_resize_screen.dart';
import 'package:pdf_maker/screens/image_to_pdf_screen.dart';
import 'package:pdf_maker/screens/pdf_create_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Select Items'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImageToPdfConversion(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text('Convert Image to Pdf'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImageResizeScreen(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text('Image Resize'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PdfCreater(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text('PDF creater'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
