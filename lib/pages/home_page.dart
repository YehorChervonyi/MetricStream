import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:lottie/lottie.dart';
import 'client_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  
}




class _HomePageState extends State<HomePage> {
  late SharedPreferences pref;
  List<Map<String, dynamic>> _clients = [];

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  // Load preferences asynchronously
  Future<void> _initPreferences() async {
    pref = await SharedPreferences.getInstance();
    _loadClients();
  }

  // Load _clients list from SharedPreferences
  void _loadClients() {
    String? clientsJson = pref.getString('clients');
    if (clientsJson != null) {
      List<dynamic> decoded = jsonDecode(clientsJson);
      setState(() {
        _clients = List<Map<String, dynamic>>.from(decoded);
      });
    }
  }

  // Save _clients list to SharedPreferences
  void _saveClients() {
    String clientsJson = jsonEncode(_clients);
    pref.setString('clients', clientsJson);
  }

  void _showAddClientModal() {
    final TextEditingController ipController = TextEditingController();
    final TextEditingController portController = TextEditingController();
    final TextEditingController nameController = TextEditingController();

    showModalBottomSheet(
      backgroundColor: const Color.fromRGBO(39, 40, 41, 1),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 24,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Add New Client',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ipController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'IP Address',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: portController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Port',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final String ip = ipController.text.trim();
                    final String port = portController.text.trim();
                    final String name = nameController.text.trim();

                    if (ip.isNotEmpty && port.isNotEmpty && name.isNotEmpty) {
                      setState(() {
                        _clients.add({
                          'ip': ip,
                          'port': port,
                          'user': name,
                        });
                        _saveClients();
                      });
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all fields'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Add Client'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void handleTileClick(BuildContext context, Map<String, dynamic> client) {
    final String clientConnect = "${client['ip']}:${client['port']}";
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientDetailPage(clientConnect: clientConnect),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(39, 40, 41, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(97, 103, 122, 1),
        title: const Center(
          child: Text(
            "MetricStream",
            style: TextStyle(color: Colors.white, fontSize: 32),
          ),
        ),
      ),
      body: _clients.isEmpty ? 
      const Center(
        child: Text("Add first instance to see metrics", style: TextStyle(color: Colors.white),) ,
      )
      :
      ListView.builder(
        itemCount: _clients.length,
        itemBuilder: (context, index) {
          final client = _clients[index];
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(97, 103, 122, 1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  client['user'],
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '${client['ip']} : ${client['port']}',
                  style: const TextStyle(color: Colors.white70),
                ),
                onTap: () => handleTileClick(context, client),
                trailing: SizedBox(
                  width: 50,
                  height: 50,
                  child: IconButton(onPressed: () {
                    setState(() {
                    _clients.removeAt(index);
                    _saveClients();
                    });
                  }, icon: const Icon(Icons.delete, color: Colors.white,)))
                ),
              ),
            );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddClientModal,
        backgroundColor: const Color.fromRGBO(97, 103, 122, 1),
        child: const Icon(Icons.add),
      ),
    );
  }
}
