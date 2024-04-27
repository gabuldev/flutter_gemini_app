import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'gemini.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemini APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final gemini = Gemini();

  String text = "";
  var isLoading = false;

  Future<void> getImageWeb() async {
    var bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    recognizeProducts(bytesFromPicker!);
  }

  Future<void> getImageDevice() async {
    var xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      final bytes = await xFile.readAsBytes();
      recognizeProducts(bytes);
    }
  }

  Future<void> recognizeProducts(Uint8List imageBytes) async {
    const prompt =
        'Você vai receber a foto de um cardápio de restaurante e me devolva todos os produtos que estão escritos nele em formato JSON';
    final content = [
      Content.multi(
        [
          TextPart(prompt),
          DataPart("image/jpeg", imageBytes),
        ],
      ),
    ];
    final response = await gemini.model.generateContent(content);
    setState(() {
      text = response.text ?? "";
    });
  }

  Future<void> recognizePlate(Uint8List imageBytes) async {
    const prompt =
        'Você vai receber a foto de uma placa de veículo, me devolvam o texto que está escrito nela.';
    final content = [
      Content.multi(
        [
          TextPart(prompt),
          DataPart("image/jpeg", imageBytes),
        ],
      ),
    ];
    final response = await gemini.model.generateContent(content);
    setState(() {
      text = response.text ?? "";
    });
  }

  Future<void> generateContent() async {
    isLoading = true;
    setState(() {});
    const prompt = 'Write a story about a magic backpack.';
    final content = [Content.text(prompt)];
    final response = await gemini.model.generateContent(content);
    setState(() {
      isLoading = false;
      text = response.text ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Gemini App"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    text,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImageDevice();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
