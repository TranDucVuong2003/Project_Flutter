import 'package:flutter/material.dart';

class WeeklyWeatherScreen extends StatelessWidget {
  const WeeklyWeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Thời tiết trong tuần'),
      ),
      body: Container(
        color: const Color(0xFF676BD0),

        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Chưa có thông tin chi tiết!',
                style: TextStyle(fontSize: 18.0),
              ),
              // Nếu nghĩ ra thêm cái gì thì thêm vô đây
            ],
          ),
        ),
      ),
    );
  }
}
