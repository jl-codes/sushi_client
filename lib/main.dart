import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zenpo Bullet Train - General Lithium',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Zenpo Bullet Train Sushi - General Lithium'),
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
  Timer? timer;
  bool isRobot1Selected = true;

  String get robotIpAddress => isRobot1Selected ? '192.168.1.201' : '192.168.1.207';

  Future<void> sendCommand(String command) async {
    try {
      final response = await http.get(Uri.parse('http://$robotIpAddress/$command'));
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
    } catch (e) {
      setState(() {
        sensorData = 'Error: $e';
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

  void returnToOriginal() {
    sendCommand('RETURN');
  }

  void goToPosition(int targetPosition) {
    sendCommand('GOTO$targetPosition').then((_) {
      getSensorData();
    });
  }

  void getSensorData() {
    sendCommand('SENSOR');
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => getSensorData());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Robot 1'),
                      Switch(
                        value: isRobot1Selected,
                        onChanged: (value) {
                          setState(() {
                            isRobot1Selected = value;
                          });
                        },
                      ),
                      Text('Robot 2'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ElevatedButton(
                          //   onPressed: () {
                          //     goToPosition(3);
                          //   },
                          //   child: Text('Go to 3'),
                          // ),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     goToPosition(4);
                          //   },
                          //   child: Text('Go to 4'),
                          // ),
                          ElevatedButton(
                            onPressed: () {
                              goToPosition(5);
                            },
                            child: Text('Go to 14'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              goToPosition(13);
                            },
                            child: Text('Go to 13'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              goToPosition(8);
                            },
                            child: Text('Go to 12'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              goToPosition(10);
                            },
                            child: Text('Go to 11'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              goToPosition(12);
                            },
                            child: Text('Go to 10'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              goToPosition(15);
                            },
                            child: Text('Go to 9'),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              goToPosition(2);
                            },
                            child: Text('Go to 2'),
                          ),
                          Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              goToPosition(6);
                            },
                            child: Text('Go to 3'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              goToPosition(7);
                            },
                            child: Text('Go to 4'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              goToPosition(9);
                            },
                            child: Text('Go to 5'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              goToPosition(11);
                            },
                            child: Text('Go to 6'),
                          ),                          
                          ElevatedButton(
                            onPressed: () {
                              goToPosition(14);
                            },
                            child: Text('Go to 7'),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              goToPosition(1);
                            },
                            child: Text('Go to 1'),
                          ),
                          Spacer(flex: 6),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
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
                    onPressed: returnToOriginal,
                    child: Text('Return to Original Position'),
                  ),
                  SizedBox(height: 20),
                  Text(sensorData),
                ],
              ),
//               Positioned(
//                 left: 10,
//                 bottom: 10,
//                 child: Text('Position: $position',
//                     style: TextStyle(fontSize: 20, color: Colors.black)),
//               ),
            ],
          ),
        ),
      ),
    );
  }
}
