import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ClientDetailPage extends StatefulWidget {
  final Map<String, dynamic> client;

  const ClientDetailPage({required this.client, super.key});

  @override
  State<ClientDetailPage> createState() => _ClientDetailPageState();
}

class _ClientDetailPageState extends State<ClientDetailPage> {
  late Map<String, dynamic> client;
  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    client = widget.client;
    _connectWebSocket(); // Connect to WebSocket when the page initializes
  }

  @override
  void dispose() {
    _channel.sink.close(); // Close the WebSocket connection when the page is disposed
    super.dispose();
  }

  void _connectWebSocket() {
    // print(client['ip']);
    // print(client['port']);
    var uri = '${client['ip']}:${client['port']}';
    // print(uri);
    _channel = WebSocketChannel.connect(Uri.parse('ws://$uri')); // Use your WebSocket URL here

    _channel.stream.listen(
      (data) {
        try {
          final Map<String, dynamic> parsedData = jsonDecode(data);
          if (parsedData['ip'] == client['ip']) {
            // Update only if the data has changed
            if (parsedData != client) {
              setState(() {
                client = parsedData; // Update the client data with new data
              });
            }
          }
        } catch (e) {
          print("Error parsing JSON: $e");
        }
      },
      onError: (error) {
        print("WebSocket error: $error");
      },
      onDone: () {
        print("WebSocket connection closed");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure disk_data is not null before accessing it
    final diskData = client['disk_data'] != null ? client['disk_data'] as Map<String, dynamic> : {};

    return Scaffold(
      appBar: AppBar(
        title: Text(client['user'] ?? 'Unknown User'), // Handle null for 'user'
        backgroundColor: const Color.fromRGBO(97, 103, 122, 1),
      ),
      backgroundColor: const Color.fromRGBO(39, 40, 41, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
  User: ${client['user'] ?? 'Unknown User'}
  IP: ${client['ip'] ?? 'Unknown IP'}
  MAC: ${client['mac'] ?? 'Unknown MAC'}
  CPU: ${client['cpu'] != null ? '${client['cpu']['freq']} MHz, ${client['cpu']['persent']}% usage' : 'Unknown CPU'}
  RAM: ${client['ram'] != null ? '${client['ram']['persent']}% used (${client['ram']['available']} / ${client['ram']['total']})' : 'Unknown RAM'}
  Disks:
  ${diskData.entries.map((entry) => '${entry.key}: ${entry.value['percentage_used']}% used (${entry.value['free']} / ${entry.value['total']})').join('\n')}
            ''',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

}
