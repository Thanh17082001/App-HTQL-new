import 'dart:async';
import 'dart:convert';

import 'package:app_flutter/model/auth/auth_model.dart';
import 'package:app_flutter/shared/loading.dart';
import 'package:app_flutter/ui/auth/auth_manager.dart';
import 'package:app_flutter/ui/staff/location_manager.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import './ui/auth_screen.dart';
class StaffCheckinScreen extends StatefulWidget {
  const StaffCheckinScreen({super.key});

  @override
  State<StaffCheckinScreen> createState() => _StaffCheckinScreenState();
}

class _StaffCheckinScreenState extends State<StaffCheckinScreen> {
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

  late bool servicePermisson = false;
  late LocationPermission _permission;
  late Position _currentPositon;
  String address = '';

  _getAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPositon.latitude, _currentPositon.longitude);

      Placemark placemark = placemarks.first;
      String city = placemark.locality ?? '';
      String district = placemark.subAdministrativeArea ?? '';
      String state = placemark.administrativeArea ?? '';
      String streetNumber = placemark.subThoroughfare ?? '';
      String streetName = placemark.thoroughfare ?? '';
      String fullAddress =
          '$streetNumber $streetName, $district, $city, $state';
      setState(() {
        address = fullAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Position> _getlocation() async {
    servicePermisson = await Geolocator.isLocationServiceEnabled();
    if (servicePermisson) {
      _permission = await Geolocator.checkPermission();
      if (_permission == LocationPermission.denied) {
        _permission = await Geolocator.requestPermission();
      }
    }
    _currentPositon = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPositon.latitude, _currentPositon.longitude);

    Placemark placemark = placemarks.first;
    String city = placemark.locality ?? '';
    String district = placemark.subAdministrativeArea ?? '';
    String state = placemark.administrativeArea ?? '';
    String streetNumber = placemark.subThoroughfare ?? '';
    String streetName = placemark.thoroughfare ?? '';
    // String placeName = placemark.name ?? '';
    address = '$streetNumber $streetName, $district, $city, $state';
    return _currentPositon;
  }

  late bool isLoading = false;
  _loading(value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getlocation();
  }

  @override
  Widget build(BuildContext context) {
    late bool isCheckIn = context.watch<LocationManager>().isCheckIn;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    return isLoading
        ? loading()
        : Column(
            children: [
              Container(
                width: double.infinity,
                height: 100,
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    // Đây là nơi bạn sử dụng boxShadow
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset.zero,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Ngày hiện tại'),
                            Text(formattedDate.toString())
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 100,
                      child: Icon(
                        Icons.calendar_today, // Icon lịch từ Material Icons
                        size: 48, // Kích thước của icon// Màu sắc của icon
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: _getlocation(),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          color: Colors.white,
                          boxShadow: [
                            // Đây là nơi bạn sử dụng boxShadow
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 7,
                              blurRadius: 7,
                              offset: Offset.zero,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              height: 100,
                              child: Column(
                                children: [
                                  const Text(
                                    'CHECK IN',
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue),
                                  ),
                                  Text(address)
                                ],
                              ),
                            ),
                            Expanded(child: checkInButton(isCheckIn)),
                          ],
                        ),
                      );
                    }),
              )
            ],
          );
  }

  Widget logoutButton() {
    return IconButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.remove('user');
          // ignore: use_build_context_synchronously
          context.read<AuthManager>().logout();
        },
        icon: const Icon(Icons.logout));
  }

  Widget checkInButton(isCheckIn) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          try {
            if (isCheckIn) {
              _loading(false);
              showFailureDialog(context, 'Đã check in!');
              return;
            }
            _loading(true);
            final Position curentPossition = await _getlocation();
            final AuthModel? _authModel = await getUser();
            final Map<String, dynamic> locationInfo = {
              'userID': _authModel?.userID,
              'viDo': curentPossition.latitude,
              'kinhDo': curentPossition.longitude,
              'diachi': address,
              'ngayCheckIn': DateTime.now()
            };

            final b = await context
                .read<LocationManager>()
                .checkCheckIn(locationInfo);
            if (b) {
              _loading(false);
              // ignore: use_build_context_synchronously
              showFailureDialog(context, 'Vị trí này đã được check in');
              setState(() {
                isCheckIn = true;
              });
              return;
            } else {
              final a =
                  // ignore: use_build_context_synchronously
                  await context.read<LocationManager>().CheckIn(locationInfo);
              _loading(false);
              a
                  ? showSuccessDialog(context)
                  : showFailureDialog(context, 'Check in thất bại thử lại sau');
            }
          } catch (e) {
            print(e);
            _loading(false);
            showFailureDialog(context, 'Không thể check in thử lại sau');
          }
        },
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: !isCheckIn ? Colors.red : Colors.green),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  !isCheckIn ? Icons.pan_tool_alt : Icons.check,
                  size: 55,
                  color: Colors.white,
                ),
                Text(
                  !isCheckIn ? 'Check in' : 'Đã Check in',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thành công"),
          content: Text('Check in thành công!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  void showFailureDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Thất bại",
            style: TextStyle(color: Colors.red),
          ),
          content: Text(title),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text("Đóng"),
            ),
          ],
        );
      },
    );
  }
}
