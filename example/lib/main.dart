import 'package:flutter/material.dart';
import 'package:flutter_pagination_widget/flutter_pagination_widget.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int current = 1;
  final int totalPages = 10;
  final int itemsPerPage = 10;

  List<String> get _currentItems {
    int start = (current - 1) * itemsPerPage;
    return List.generate(itemsPerPage, (index) => 'Item ${start + index + 1}');
  }

  @override
  Widget build(BuildContext context) {
    final meta = PaginationModel(
      from: (current - 1) * itemsPerPage + 1,
      to: current * itemsPerPage,
      total: totalPages * itemsPerPage,
      currentPage: current,
      lastPage: totalPages,
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Pagination Example')),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _currentItems.length,
                itemBuilder: (context, index) {
                  final item = _currentItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/150?img=${index + 1}", // random dummy avatars
                        ),
                      ),
                      title: Text(
                        "Person ${index + 1}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        "Dummy description for $item",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey[700],
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Tapped on Person ${index + 1}"),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            PaginationWidget(
              meta: meta,
              onPageChanged: (p) => setState(() => current = p),
              primaryColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}
