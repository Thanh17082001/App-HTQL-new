import 'package:app_flutter/model/location/location_model.dart';
import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:app_flutter/ui/staff/location_manager.dart';
import 'package:app_flutter/ui/staff/staff_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryCheckIn extends StatefulWidget {
  static const routerName = '/history-checkin';
  final int nhanVienID;
  const HistoryCheckIn(this.nhanVienID, {super.key});

  @override
  State<HistoryCheckIn> createState() => _HistoryCheckInState();
}

class _HistoryCheckInState extends State<HistoryCheckIn> {
  late StaffModel staff = StaffModel();
  Future getLocationsByNhanVienID(BuildContext context) async {
    await context.read<LocationManager>().getByStaffId(widget.nhanVienID) ?? [];
  }

  Future getNhanVienByID(BuildContext context) async {
    staff = (await context
        .read<StaffManager>()
        .getNhanVienByID(widget.nhanVienID))!;
  }

  @override
  void initState() {
    super.initState();
    getLocationsByNhanVienID(context);
    getNhanVienByID(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Container(
            height: 30,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Center(
                child: Text(
              'Danh sách các địa điểm đã check in'.toUpperCase(),
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            )),
          ),
          FutureBuilder(
              future: getNhanVienByID(context),
              builder: (context, staffManager) {
                return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => ShowDialog(staff: staff));
                      },
                      child: Text(
                        staff.tenNhanVien ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ));
              }),
          Expanded(
            child: Consumer<LocationManager>(
                builder: (ctx, locationManager, child) {
              return ListView.builder(
                  itemCount: locationManager.itemCount,
                  itemBuilder: (ctx, index) {
                    if (index == locationManager.itemCount) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListItem(locationManager.locations[index]);
                  });
            }),
          )
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ListItem(LocationModel location) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              location.diaChi.toString(),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            Text(formattedDateTime(location.thoiGian.toString()))
          ],
        ),
      ),
    );
  }

  String formattedDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    String formatted = formatter.format(dateTime);

    return formatted;
  }
}

class ShowDialog extends StatefulWidget {
  final staff;
  const ShowDialog({Key? key, required this.staff}) : super(key: key);

  @override
  State<ShowDialog> createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Đóng")),
      ],
      title: Text(
        'Thông tin nhân viên'.toUpperCase(),
        style: TextStyle(color: Colors.blue),
      ),
      content: SizedBox(
        height: 150.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 30.0,
                child:
                    Text('Họ và tên: ${widget.staff.tenNhanVien.toString()}')),
            SizedBox(
                height: 30.0,
                child: Text(
                    'Số điện thoại: ${widget.staff.soDienThoai ?? 'Chưa có'}')),
            SizedBox(
                height: 30.0,
                child: Text('Email: ${widget.staff.email ?? 'Chưa có'}'))
          ],
        ),
      ),
    );
  }
}
