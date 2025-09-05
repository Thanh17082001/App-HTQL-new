import 'package:app_flutter/model/location/location_model.dart';
import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:app_flutter/ui/staff/location_manager.dart';
import 'package:app_flutter/ui/staff/staff_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LocationOnGoogleMap extends StatefulWidget {
  static const routerName = '/google-map';
  final int nhanVienID;
  const LocationOnGoogleMap(this.nhanVienID, {super.key});

  @override
  State<LocationOnGoogleMap> createState() => _LocationOnGoogleMapState();
}

class _LocationOnGoogleMapState extends State<LocationOnGoogleMap> {
  GoogleMapController? _mapController;
  final PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  final Set<Marker> _markers = {};
  late StaffModel staff = StaffModel();
  Future getLocationByNhanVienID(BuildContext context) async {
    await context.read<LocationManager>().getByStaffId(widget.nhanVienID);
    await getNhanVienByID(context);
  }

  Future getNhanVienByID(BuildContext context) async {
    staff = (await context
        .read<StaffManager>()
        .getNhanVienByID(widget.nhanVienID))!;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_mapController != null) {
      _mapController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vị trí trên bản đồ'),
          backgroundColor: Colors.blue,
        ),
        body: FutureBuilder(
          future: getLocationByNhanVienID(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Consumer<LocationManager>(
                  builder: (context, locationManager, index) {
                final locations = toaDo(locationManager.locations);
                getLocations(locationManager.locations);
                // getDirections();
                Polyline polyline = Polyline(
                  polylineId: const PolylineId('route1'),
                  color: Colors.red,
                  width: 5,
                  points: locations,
                );
                Set<Polyline> polylines = {};
                polylines.add(polyline);
                return Stack(alignment: Alignment.center, children: [
                  GoogleMap(
                    polylines: polylines,
                    initialCameraPosition: CameraPosition(
                        target: locations.isEmpty
                            ? const LatLng(10.0458, 105.7469)
                            : locations.first,
                        zoom: 13),
                    markers: locations.isEmpty ? {} : _markers,
                    onMapCreated: (controller) {
                      _mapController ??= controller;
                    },
                  ),
                  Positioned(
                    top: 20.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                          )
                        ],
                      ),
                      child: Text(
                        staff.tenNhanVien.toString(),
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ]);
              });
            }
          },
        ));
  }

  List<LatLng> toaDo(List<LocationModel> locations) {
    final List<LatLng> locationsResult = [];
    for (var i = 0; i < locations.length; i++) {
      if (locations[i].viDo != null && locations[i].kinhDo != null) {
        final viDo = locations[i].viDo!;
        final kinhDo = locations[i].kinhDo!;
        locationsResult.add(LatLng(viDo, kinhDo));
      }
    }
    return locationsResult;
  }

  getLocations(List<LocationModel> locations) {
    final List<Map<String, dynamic>> locationsResult = [];
    for (var i = 0; i < locations.length; i++) {
      if (locations[i].viDo != null && locations[i].kinhDo != null) {
        final viDo = locations[i].viDo!;
        final kinhDo = locations[i].kinhDo!;
        final thoiGian = locations[i].thoiGian!;
        final diaChi = locations[i].diaChi!;
        locationsResult.add({
          'viDo': viDo,
          'kinhDo': kinhDo,
          'diaChi': diaChi,
          'thoiGian': thoiGian,
        });

        _markers.add(
          Marker(
            markerId: MarkerId(LatLng(viDo, kinhDo).toString()),
            position: LatLng(viDo, kinhDo),
            infoWindow: InfoWindow(
              title: diaChi.toString(),
              snippet: formattedDateTime(thoiGian.toString()),
            ),
            onTap: () {
              // Handle marker tap
              print('Marker Tapped');
            },
          ),
        );
      }
    }
  }

  String formattedDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    String formatted = formatter.format(dateTime);

    return formatted;
  }

// hàm này đang test
  // void getDirections() async {
  //   try {
  //     String apiKey = 'AIzaSyCmYZvHyila52BYEXk0uLwDcviwu2l3xm4  ';
  //     Map<String, double> origin = {'lat': 37.7749, 'lng': -122.4194}; // San Francisco, CA
  //   Map<String, double> destination = {'lat': 34.0522, 'lng': -118.2437}; // Los Angeles, CA

  //   List<Map<String, double>> waypointsList = [
  //     {'lat': 37.8044, 'lng': -122.2711}, // Oakland, CA
  //     {'lat': 37.3382, 'lng': -121.8863}  // San Jose, CA
  //   ];

  //   String originStr = '${origin['lat']},${origin['lng']}';
  //   String destinationStr = '${destination['lat']},${destination['lng']}';
  //   String waypoints = waypointsList
  //       .map((waypoint) => '${waypoint['lat']},${waypoint['lng']}')
  //       .join('|');

  //     String url =
  //         'https://maps.googleapis.com/maps/api/directions/json?origin=$originStr&destination=$destinationStr&waypoints=$waypoints&key=$apiKey';

  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> data = jsonDecode(response.body);
  //       print('======== LỖi =========');
  //       print(data);
  //       List<dynamic> routes = data['routes'];

  //       if (routes.isNotEmpty) {
  //         List<Map<String, dynamic>> waypointsList = [];
  //         List<List<LatLng>> polylinesList = [];

  //         for (var route in routes) {
  //           List<LatLng> polylinePoints = [];
  //           Map<String, dynamic> legs = route['legs'][0];

  //           // Lấy thông tin khoảng cách và thời gian từng tuyến đường đi
  //           String distance = legs['distance']['text'];
  //           String duration = legs['duration']['text'];

  //           List<dynamic> steps = legs['steps'];
  //           Duration totalDuration = Duration();
  //           double totalDistance = 0;

  //           for (var step in steps) {
  //             //tính tổng thời gian
  //             int durationInSeconds = step['duration']['value'];
  //             totalDuration += Duration(seconds: durationInSeconds);
  //             // tính tổng quãng đường
  //             double distanceInMeters = step['distance']['value'].toDouble();
  //             totalDistance += distanceInMeters;

  //             // Lấy các điểm của tuyến đường để vẽ lên bản đồ
  //             List<dynamic> polyline = step['polyline']['points'].split(' ');
  //             polyline.forEach((point) {
  //               double lat = double.parse(point.split(',')[0]);
  //               double lng = double.parse(point.split(',')[1]);
  //               polylinePoints.add(LatLng(lat, lng));
  //             });
  //           }

  //           waypointsList.add({
  //             'distance': distance,
  //             'duration': duration,
  //           });

  //           polylinesList.add(polylinePoints);
  //         }

  //         // Kết quả thu được: waypointsList chứa thông tin về khoảng cách và thời gian, polylinesList chứa danh sách các điểm để vẽ lên bản đồ
  //         print('Waypoints:');
  //         for (var waypoint in waypointsList) {
  //           print(
  //               'Distance: ${waypoint['distance']}, Duration: ${waypoint['duration']}');
  //         }
  //         print('Polylines:');
  //         for (var polyline in polylinesList) {
  //           print(polyline);
  //         }
  //       } else {
  //         print("No routes found.");
  //       }
  //     } else {
  //       print("Failed to fetch data. Error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
