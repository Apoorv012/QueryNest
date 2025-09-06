import 'package:flutter/material.dart';

void main() {
  runApp(const QueryNestApp());
}

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
  List<String> results = [];

  void _search() {
    setState(() {
      results = [
        "Project_Report.pdf",
        "Meeting_Notes.txt",
        "AI_Research.docx",
      ]; // dummy results
    });
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
                            title: Text(results[index]),
                            subtitle: const Text("Sample matching snippet..."),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
