import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:metricstream_app/pages/home_page.dart';
import 'package:metricstream_app/util/Chart.dart';
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
  // late List<FlSpot> cpuData = List.generate(21, (index) => FlSpot(index.toDouble(), 0.0));
  // late List<FlSpot> ramData = List.generate(21, (index) => FlSpot(index.toDouble(), 0.0));
  late List<FlSpot> cpuData = [];
  late List<FlSpot> ramData = [];
  late List<FlSpot> cpuFreqData = [];
  late double xValue = 0;

  @override
  void initState() {
    super.initState();
    client = widget.client;
    // Connect to WebSocket
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
                client = parsedData; 
                // DateTime now = DateTime.now();
                // double  timeAsDouble = now.hour + (now.minute / 60) + (now.second / 3600);// Update the client data with new data
                cpuData.add(FlSpot(xValue ,client['cpu']['persent']));
                ramData.add(FlSpot(xValue, client['ram']['persent']));
                cpuFreqData.add(FlSpot(xValue, client['cpu']['freq']));
                xValue+=1;


                // Access disk usage percentages
        // double diskCUsed = client['disk_data']['C:\\']['percentage_used'];
        // double diskDUsed = client['disk_data']['D:\\']['percentage_used'];

                if (cpuData.length > 22) {
                  cpuData.removeAt(0);
                }
                if (ramData.length > 22) {
                  ramData.removeAt(0);
                }
                if (cpuFreqData.length > 22) {
                  cpuFreqData.removeAt(0);
                }
              });
            }
          }
        } catch (e) {
          print("Error parsing JSON: $e");
        Navigator.pop(context);
        }
      },
      onError: (error) {
        print("WebSocket error: $error");
        Navigator.pop(context);
      },
      onDone: () {
        print("WebSocket connection closed");
        Navigator.pop(context);
      },
    );
  }



  @override
Widget build(BuildContext context) {
  // Ensure disk_data is not null before accessing it
  final diskData = client['disk_data'] != null ? client['disk_data'] as Map<String, dynamic> : {};

  return Scaffold(
    appBar: AppBar(
      title: Text("IP: "+client['ip']+" | MAC: "+client['mac'] ?? 'Unknown User', style: TextStyle(color: Colors.white),), // Handle null for 'user'
      backgroundColor: const Color.fromRGBO(97, 103, 122, 1),
    ),
    backgroundColor: const Color.fromRGBO(39, 40, 41, 1),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the client details
            Text(
//  Disk: ${diskData.isNotEmpty ? '${diskData['persent']}% used (${diskData['available']} / ${diskData['total']})' : 'Unknown Disk'}
              '''
  IP: ${client['ip'] ?? 'Unknown IP'}
  MAC: ${client['mac'] ?? 'Unknown MAC'}
  CPU: ${client['cpu'] != null ? '${client['cpu']['freq']} MHz, ${client['cpu']['persent']}% usage' : 'Unknown CPU'}
  RAM: ${client['ram'] != null ? '${client['ram']['persent']}% used (${client['ram']['available']} / ${client['ram']['total']})' : 'Unknown RAM'}
              ''',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            
            // Integrate the chart here
            const Text(
              'CPU Persentage:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Add the LineChartSample2 widget
            Chart(cpuData, 0, 100, 25),

            const Text(
              'CPU Frequency:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Chart(cpuFreqData, 0, 4400, 1000),

            const Text(
              'RAM Persentage:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Chart(ramData, 0, 100, 25),
          ],
        ),
      ),
    ),
  );
}


}
