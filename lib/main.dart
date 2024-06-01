import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String sensorData = '';
  int position = 0;

  void sendCommand(String command) async {
    final response = await http.get(Uri.parse('http://192.168.1.201/$command'));
    if (response.statusCode == 200) {
      setState(() {
        sensorData = response.body;
        if (command == 'SENSOR') {
          position = int.parse(sensorData.split(' ').last);
        }
      });
    } else {
      setState(() {
        sensorData = 'Error: ${response.statusCode}';
      });
    }
  }

  void startMotors() {
    sendCommand('START');
  }

  void stopMotors() {
    sendCommand('STOP');
  }

  void reverseMotors() {
    sendCommand('REVERSE');
  }

  void goToPosition(int targetPosition) {
    sendCommand('GOTO $targetPosition');
  }

  void getSensorData() {
    sendCommand('SENSOR');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: startMotors,
                  child: Text('Start Motors'),
                ),
                ElevatedButton(
                  onPressed: stopMotors,
                  child: Text('Stop Motors'),
                ),
                ElevatedButton(
                  onPressed: reverseMotors,
                  child: Text('Reverse Motors'),
                ),
                ElevatedButton(
                  onPressed: getSensorData,
                  child: Text('Get Sensor Data'),
                ),
                SizedBox(height: 20),
                Text(sensorData),
                SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  children: List<Widget>.generate(
                    15,
                    (int index) {
                      return ElevatedButton(
                        onPressed: () {
                          goToPosition(index);
                        },
                        child: Text('Go to $index'),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              left: 10,
              bottom: 10,
              child: Text('Position: $position',
                  style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
