import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter GetX PWA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Controller for state management
class CounterController extends GetxController {
  var count = 0.obs;
  var name = 'Guest'.obs;

  void increment() {
    count++;
  }

  void decrement() {
    if (count > 0) count--;
  }

  void updateName(String newName) {
    name.value = newName;
  }
}

// Home Page
class HomePage extends StatelessWidget {
  final CounterController controller = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter GetX PWA Demo'),
        elevation: 2,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome Section
              Obx(() => Text(
                'Welcome, ${controller.name}!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )),
              SizedBox(height: 20),

              // Name Input
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter your name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  onChanged: (value) {
                    controller.updateName(value.isEmpty ? 'Guest' : value);
                  },
                ),
              ),
              SizedBox(height: 40),

              // Counter Section
              Text(
                'Counter Value:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Obx(() => Text(
                '${controller.count}',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              )),
              SizedBox(height: 30),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: controller.decrement,
                    icon: Icon(Icons.remove),
                    label: Text('Decrease'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: controller.increment,
                    icon: Icon(Icons.add),
                    label: Text('Increase'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Navigation Button
              OutlinedButton.icon(
                onPressed: () => Get.to(() => SecondPage()),
                icon: Icon(Icons.arrow_forward),
                label: Text('Go to Second Page'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Second Page (demonstrates navigation)
class SecondPage extends StatelessWidget {
  final CounterController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'This is the second page!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Obx(() => Text(
              'Counter from previous page: ${controller.count}',
              style: TextStyle(fontSize: 18),
            )),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back),
              label: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}