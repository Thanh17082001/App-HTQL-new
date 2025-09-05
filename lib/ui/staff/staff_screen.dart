

import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:app_flutter/ui/map/google_map_screen.dart';
import 'package:app_flutter/ui/staff/history_checkin.dart';
import 'package:app_flutter/ui/staff/location_manager.dart';
import 'package:app_flutter/ui/staff/staff_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  Future getAllStaff(BuildContext context) async {
    await context.read<StaffManager>().getAll();
  }

  @override
  Widget build(BuildContext context) {
    // final _item = context.read<StaffManager>().staffs;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 20),
          child: const Center(
              child: Text(
            'DANH SÁCH NHÂN VIÊN',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          )),
        ),
        Expanded(
          child: FutureBuilder(
              future: getAllStaff(context),
              builder: (context, snapshot) {
                return Consumer<StaffManager>(
                    builder: (ctx, staffManager, index) {
                  if (staffManager.itemCount > 0) {
                    return ListView.builder(
                      itemCount: staffManager.itemCount,
                      itemBuilder: (context, index) {
                        return Container(
                            child: itemList(staffManager.staffs[index]));
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('Chưa có nhân viên'),
                    );
                  }
                });
              }),
        ),
      ],
    );
  }

  Widget itemList(StaffModel staff) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(staff.tenNhanVien.toString()),
              GestureDetector(
                onTap: () async {
                 
                  await Navigator.of(context).pushNamed(
                      HistoryCheckIn.routerName,
                      arguments: staff.nhanVienID);
                },
                child: const Text(
                  'Xem lịch sử đi',
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                      color: Colors.blue),
                ),
              )
            ],
          ),
          SizedBox(
            width: 50,
            child: GestureDetector(
              onTap: () async {
                // await context
                //     .read<LocationManager>()
                //     .getByStaffId(staff.nhanVienID);
                await Navigator.of(context).pushNamed(
                    LocationOnGoogleMap.routerName,
                    arguments: staff.nhanVienID);
                // ignore: use_build_context_synchronously
                await context
                    .read<LocationManager>()
                    .getByStaffId(staff.nhanVienID);
              },
              child: const Icon(
                Icons.location_on,
                size: 30,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }
}
