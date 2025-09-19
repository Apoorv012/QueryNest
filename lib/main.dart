import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:query_nest/utils.dart';
import 'package:query_nest/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const QueryNestApp());
}

// class Child : Parent {};
// class MyApp extends StatefulWidget {}


class QueryNestApp extends StatelessWidget {
  const QueryNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QueryNest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Poppins'),
          bodyMedium: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> results = [];
  bool _isUploading = false;

  void _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    try {
      final resultsData = await ApiService.search(query);
      setState(() {
        results = resultsData
            .map((doc) => {
                  "filename": doc["filename"]?.toString() ?? "",
                  "snippet": doc["snippet"]?.toString() ?? "",
                  "url": doc["url"]?.toString() ?? "",
                })
            .toList();
      });
    } catch (e) {
      print("Search error: $e");
    }
  }

  Future<void> _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }


  void _uploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);

      setState(() {
        _isUploading = true;
      });

      try {
        final message = await ApiService.uploadFile(file);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Upload failed: $e")),
        );
        print("Upload error: $e");
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QueryNest 🪶"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Box
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Ask me anything about your files...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Results
            Expanded(
              child: results.isEmpty
                  ? const Center(
                      child: Text(
                        "Your nest is empty 🪹\nAdd files to start searching!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.insert_drive_file),
                            title: Text(results[index]["filename"] ?? ""),
                            subtitle: Text(
                                cleanText(results[index]["snippet"] ?? "")),
                            onTap: () {
                                final url = results[index]["url"];
                                print("Click happened");
                                print(url);
                                if (url != null && url.isNotEmpty) {
                                  print("opening link");
                                  print(url);
                                  _openLink(url);
                                }
                              },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isUploading
          ? const FloatingActionButton(
              onPressed: null, // disabled
              backgroundColor: Colors.grey,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : FloatingActionButton(
              onPressed: _uploadFile,
              child: const Icon(Icons.add),
            ),
    );
  }
}
