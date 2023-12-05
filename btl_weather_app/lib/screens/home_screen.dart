import 'dart:convert';
import 'package:btl_weather_app/screens/weeklyWeatherScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Weather> fetchWeather() async { // fetchWeather() là một hàm để gửi yêu cầu HTTP đến API của OpenWeatherMap để lấy dữ liệu thời tiết
    final resp = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=HaNoi&units=metric&appid=82d78aef7a2755507e23056a5b7b885f"));

    if (resp.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(resp.body);

      return Weather.fromJson(json);
    } else {
      throw Exception('Không thể tải được dữ liệu...');
    }
  }

  late Future<Weather> myWeather;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myWeather = fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF676BD0),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          top: 30.0,
        ),
        child: Stack(
          children: [
            SafeArea(
              top: true, // Đảm bảo không gian trên cùng của màn hình không bị che khuất.
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, //Đặt cách chia đều các thành phần bên trong theo chiều ngang
                    children: [
                      Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/admin.png'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<Weather>(
                    future: myWeather,
                    builder: (context, snapshot) {    //Hàm này sẽ xây dựng giao diện dựa trên snapshot của Future.
                      if (snapshot.hasData) { // Kiểm tra xem dữ liệu đã được load thành công chưa.
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data!.name,  //Hiển thị tên thành phố từ dữ liệu Weather.
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              snapshot.data!.weather[0]['main'].toString(),   //Hiển thị trạng thái thời tiết chính (ví dụ: mây, mưa)
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                letterSpacing: 1.3,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              '8 - 12 - 2023',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              height: 250,
                              width: 250,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage(
                                  'assets/cloudy.png',
                                ),
                              )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,  //các cột sẽ được căn giữa theo chiều ngang
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      'Nhiệt Độ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${snapshot.data!.main['temp']}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Tốc độ gió',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${snapshot.data!.wind['speed']} km/h',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Độ ẩm',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${snapshot.data!.main['humidity']}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => WeeklyWeatherScreen(),
                                ),
                              );},
                              child: const Text('Xem thời tiết hàng tuần'),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.deepPurpleAccent[100],  //Thiết lập màu sắc chính của nút độ sáng 100
                                  minimumSize: Size(
                                    MediaQuery.of(context).size.width / 1.1,
                                    50,
                                  )),
                            )
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return const Text('Không thể tải dữ liệu');
                      } else {
                        return const CircularProgressIndicator(
                          color: Colors.white,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
