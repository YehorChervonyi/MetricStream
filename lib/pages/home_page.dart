import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'client_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _clients = [
    {
      'ip': '192.168.0.101',
      'port': '8080',
      'user': 'Client 1',
      'isOnline': false, // Default offline
    },
    {
      'ip': '192.168.0.103',
      'port': '7070',
      'user': 'Client 2',
      'isOnline': false, // Default offline
    },
    {
      'ip': '127.0.0.1',
      'port': '36500',
      'user': 'Local',
      'isOnline': true, // Default offline
    },
  ];

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
                      borderSide: BorderSide(color: Colors.blue),
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
                      borderSide: BorderSide(color: Colors.blue),
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
                      borderSide: BorderSide(color: Colors.blue),
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
                      // bool isOnline = await _pingClient(ip);
                      setState(() {
                        _clients.add({
                          'ip': ip,
                          'port': port,
                          'user': name,
                          'isOnline': true,
                        });
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

  void handleTileClick(Map<String, dynamic> client) {
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
      body: ListView.builder(
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
                onTap: () => handleTileClick(client),
                trailing: SizedBox(
                  width: 50,
                  height: 50,
                  child: Lottie.asset(
                    client['isOnline'] ? 'assets/onn.json' : 'assets/off.json',
                    fit: BoxFit.cover,
                  ),
                ),
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
