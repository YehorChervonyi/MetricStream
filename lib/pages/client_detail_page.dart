import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  late List<FlSpot> ramUsageData = [];
  late double xValue = 0;
  late Map<String, dynamic> diskData = {};
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
              ramUsageData.add(FlSpot(xValue, (client['ram']['total']/1024/1024/1024).toInt()-(client['ram']['available']/1024/1024/1024).toInt() ?? 0.0));
              xValue += 1;
              diskData = client['disk_data'] != null ? client['disk_data'] as Map<String, dynamic> : {};
              

              if (cpuData.length > 22) cpuData.removeAt(0);
              if (ramData.length > 22) ramData.removeAt(0);
              if (cpuFreqData.length > 22) cpuFreqData.removeAt(0);
              if (ramUsageData.length > 22) ramUsageData.removeAt(0);
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
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: !isLoading,
          title: isLoading
              ? const Text(
                  "Loading..",
                  style: TextStyle(color: Colors.white),
                )
              : Text(
                  "IP: ${client['ip'] ?? 'Unknown'} | MAC: ${client['mac'] ?? 'Unknown'}",
                  style: const TextStyle(color: Colors.white),
                ),
          backgroundColor: const Color.fromRGBO(97, 103, 122, 1),
        ),
        backgroundColor: const Color.fromRGBO(39, 40, 41, 1),
        body: isLoading
            ? const Center(
                // mainAxisAlignment: MainAxisAlignment.center,
                child: (
                  Center(
                    child:CircularProgressIndicator(),
                  )
                ),
              )
            : Container(
                padding: const EdgeInsets.all(5.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '''
                        Username: ${client['user'] ?? 'Unknown User'}
                        ''',
                        style: const TextStyle(color: Colors.white),
                      ),
                      // const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'CPU',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Chart(cpuData, 0, 100, 25, "CPU Percentage"),
                      const SizedBox(height: 8),
                      Chart(cpuFreqData, 0, 4400, 1000, "CPU Frequency"),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'RAM',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Chart(ramData, 0, 100, 25, "RAM Percentage"),
                      const SizedBox(height: 8),
                      // Text((client['ram']['total']/1024/1024/1024).round().toString()),
                      Chart(ramUsageData, 0, (client['ram']['total']/1024/1024/1024).round().toInt(), ((client['ram']['total']/1024/1024/1024).toInt()/5).toInt(), "RAM Usage"),
                      const SizedBox(height: 16),

                      const Center(
                        child: Text(
                          'Disk',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Column(
                        children: diskData.entries.map((entry) { 
                        return Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          alignment: WrapAlignment.start,
                          children: [
                            MyPieChart(100.0-entry.value['percentage_used'], entry.value['percentage_used'], "Disk ${entry.key}"),
                            const SizedBox(height: 8),
                          ],
                        ); 
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
