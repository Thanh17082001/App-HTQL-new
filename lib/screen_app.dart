import 'dart:async';
import 'dart:convert';

import 'package:app_flutter/model/auth/auth_model.dart';
import 'package:app_flutter/ui/auth/auth_manager.dart';
import 'package:app_flutter/ui/plan/plan_list.dart';
import 'package:app_flutter/ui/plan/plan_screen.dart';
import 'package:app_flutter/ui/staff/location_manager.dart';
import 'package:app_flutter/ui/staff/staff_screen.dart';
import 'package:app_flutter/ui/task/list_task.dart';
import 'package:app_flutter/ui/task/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './ui/staff/staff_checkin.dart';

// import './ui/auth_screen.dart';
class ScreenApp extends StatefulWidget {
  const ScreenApp({super.key});

  @override
  State<ScreenApp> createState() => _ScreenAppState();
}

class _ScreenAppState extends State<ScreenApp> {
  AuthModel? user;
  Future<AuthModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var initUser = prefs.getString('user');
    if (initUser != null) {
      user = AuthModel.fromJson(jsonDecode(initUser));
      return user;
    }
    return null;
  }

  late int _currentIndex = 0;
  final pages = [const StaffCheckinScreen(), const StaffScreen(), const PlanScreen(), const PlanListScreen(), const TaskScreen(), const ListTask()];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: FutureBuilder(
            future: getUser(),
            builder: (context, snapshot) {
              final userInfo = snapshot.data;
              if (userInfo != null) {
                return Text(userInfo.hoVaTen.toString());
              } else {
                return const Text('kho lưu trữ trống');
              }
            }),
        leading: Builder(
          builder: (context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu,size: 28,));
          },
        ),
        actions: [logoutButton()],
      ),
      
      body: pages[_currentIndex],
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: <Widget>[
            Container(
              height: 120,
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image/LogoGD.png',
                    fit: BoxFit.cover,
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'HỆ THỐNG QUẢN LÝ GD GROUP',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            ListTile(
              selectedColor: Colors.orange,
              leading: const Icon(Icons.location_on),
              title: const Text('Định vị'),
              selected: _currentIndex == 0,
              onTap: () {
                _onItemTapped(0);
              },
            ),
            ListTile(
              selectedColor: Colors.orange,
              leading: const Icon(Icons.follow_the_signs_sharp),
              title: const Text('Theo dõi'),
              selected: _currentIndex == 1,
              onTap: () {
                _onItemTapped(1);
              },
            ),
            ListTile(
              selectedColor: Colors.orange,
              leading: const Icon(Icons.add),
              title: const Text('Lập kế hoạch công tác'),
              selected: _currentIndex == 2,
              onTap: () {
                _onItemTapped(2);
              },
            ),
            ListTile(
              selectedColor: Colors.orange,
              leading: const Icon(Icons.check),
              title: const Text('Duyệt kế hoạch'),
              selected: _currentIndex == 3,
              onTap: () {
                _onItemTapped(3);
              },
            ),
            ListTile(
              selectedColor: Colors.orange,
              leading: const Icon(Icons.add_task),
              title: const Text('Giao việc'),
              selected: _currentIndex == 4,
              onTap: () {
                _onItemTapped(4);
              },
            ),
            ListTile(
              selectedColor: Colors.orange,
              leading: const Icon(Icons.task),
              title: const Text('Việc được giao'),
              selected: _currentIndex == 5,
              onTap: () {
                _onItemTapped(5);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget logoutButton() {
    return IconButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.remove('user');
          // ignore: use_build_context_synchronously
          context.read<AuthManager>().logout();
          setState(() {
            
          });
          // ignore: use_build_context_synchronously
          context.read<LocationManager>().setChecked = false;
        },
        icon: const Icon(Icons.logout));
  }
}
