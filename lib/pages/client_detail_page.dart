import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:metricstream_app/util/Chart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ClientDetailPage extends StatefulWidget {
  final String clientConnect;

  const ClientDetailPage({super.key, required this.clientConnect});

  @override
  State<ClientDetailPage> createState() => _ClientDetailPageState();
}

class _ClientDetailPageState extends State<ClientDetailPage> {
  late Map<dynamic, dynamic> client = {}; // Initialize with an empty map
  late String clientConnect;
  late WebSocketChannel _channel;
  late List<FlSpot> cpuData = [];
  late List<FlSpot> ramData = [];
  late List<FlSpot> cpuFreqData = [];
  late double xValue = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    clientConnect = widget.clientConnect;
    _connectWebSocket();
  }

  @override
  void dispose() {
    _closeWebSocket();
    super.dispose();
  }

  void _connectWebSocket() async {
    final uri = "ws://$clientConnect";
    try {
      setState(() {
        isLoading = true;
      });
      _channel = WebSocketChannel.connect(Uri.parse(uri));
      await _channel.ready.timeout(Duration(seconds: 2));

      setState(() {
        isLoading = false;
      });

      _channel.stream.listen(
        (data) {
          try {
            final Map<String, dynamic> parsedData = jsonDecode(data);
            print(parsedData);
            setState(() {
              client = parsedData;
              cpuData.add(FlSpot(xValue, client['cpu']['persent'] ?? 0.0));
              ramData.add(FlSpot(xValue, client['ram']['persent'] ?? 0.0));
              cpuFreqData.add(FlSpot(xValue, client['cpu']['freq'] ?? 0.0));
              xValue += 1;

              if (cpuData.length > 22) cpuData.removeAt(0);
              if (ramData.length > 22) ramData.removeAt(0);
              if (cpuFreqData.length > 22) cpuFreqData.removeAt(0);
            });
          } catch (e) {
            Navigator.pop(context);
            print("Error parsing JSON: $e");
          }
        },
        onError: (error) {
          print("WebSocket error on error: $error");
          Navigator.pop(context); 
          print("WebSocket error stack trace: ${error.toString()}");
        },
        onDone: () {
          Navigator.pop(context);
          print("WebSocket connection closed");
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      print("WebSocket error connect: $e");
    }
  }

  void _closeWebSocket() {
    // if (_channel != null) {
      _channel.sink.close();
    // }
  }

  Future<bool> _onWillPop() async {
    _closeWebSocket();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: !isLoading,
          title: isLoading
              ? Text(
                  "Loading..",
                  style: TextStyle(color: Colors.white),
                )
              : Text(
                  "IP: ${client['ip'] ?? 'Unknown'} | MAC: ${client['mac'] ?? 'Unknown'}",
                  style: TextStyle(color: Colors.white),
                ),
          backgroundColor: const Color.fromRGBO(97, 103, 122, 1),
        ),
        backgroundColor: const Color.fromRGBO(39, 40, 41, 1),
        body: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '''
IP: ${client['ip'] ?? 'Unknown IP'}
MAC: ${client['mac'] ?? 'Unknown MAC'}
CPU: ${client['cpu'] != null ? '${client['cpu']['freq']} MHz, ${client['cpu']['persent']}% usage' : 'Unknown CPU'}
RAM: ${client['ram'] != null ? '${client['ram']['persent']}% used (${client['ram']['available']} / ${client['ram']['total']})' : 'Unknown RAM'}
                        ''',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'CPU Percentage:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Chart(cpuData, 0, 100, 25),
                      const Text(
                        'CPU Frequency:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Chart(cpuFreqData, 0, 4400, 1000),
                      const Text(
                        'RAM Percentage:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Chart(ramData, 0, 100, 25),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
