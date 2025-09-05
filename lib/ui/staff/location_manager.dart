
import 'package:app_flutter/model/location/location_model.dart';
import 'package:app_flutter/service/location/location_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LocationManager with ChangeNotifier {
  final LocationService _locationService = LocationService();
  late bool checked = false;
  List<LocationModel> _items = [];
  bool get isCheckIn {
    return checked;
  }

  int get itemCount {
    return _items.length;
  }

  set setChecked(newvalue) {
    checked = newvalue;
    notifyListeners();
  }

  List<LocationModel> get locations {
    _items.sort((a, b) {
      DateTime timeA = DateTime.parse(a.thoiGian.toString());
      DateTime timeB = DateTime.parse(b.thoiGian.toString());
      return timeB.compareTo(timeA);
    });
    return [..._items];
  }

  Future<bool> checkCheckIn(Map<String, dynamic> location) async {
    final Map<String, dynamic> infoCheckin = {
      'userID': location['userID'],
      'diachi': location['diachi'],
      'ngayCheckIn': formattedDateTime(location['ngayCheckIn'])
    };
    _items = [];
    if (_items.isEmpty) {
      await getByStaffId(location['userID']);
    }
    final infoCheckined = getLocationNew();
    if (infoCheckined != null) {
      for (var key in infoCheckin.keys) {
        if (!infoCheckined.containsKey(key) ||
            infoCheckin[key] != infoCheckined[key]) {
          checked = false;
          notifyListeners();
          return false;
        }

      }
    } else {
      return false;
    }
    checked = true;
    notifyListeners();
    return true;
  }

  Future<bool> CheckIn(Map<String, dynamic> location) async {
    final ischecked = await _locationService.checkIn(location);
    if (ischecked) {
      checked = true;
      notifyListeners();
    } else {
      checked = false;
    }
    return checked;
  }

  Future getByStaffId(nhanVienID) async {
    DateFormat inputFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
    DateFormat outputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    _items = await _locationService.getByStaffId(nhanVienID);

    for (var i = 0; i < _items.length; i++) {
      DateTime dateTime = inputFormat.parse(_items[i].thoiGian.toString());
      String formattedDateTimeString = outputFormat.format(dateTime);
      _items[i].thoiGian = formattedDateTimeString;
    }
    notifyListeners();
  }

  Map<String, dynamic>? getLocationNew() {
    if (_items.isNotEmpty) {
      final Map<String, dynamic> item = {
        'userID': _items[_items.length -1].nhanVienID,
        'diachi': _items[_items.length -1].diaChi,
        'ngayCheckIn':
            formatDateTimeString(_items[_items.length - 1].thoiGian.toString())
      };
      return item;
    } else {
      return null;
    }
  }

  String formattedDateTime(dateTimeString) {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String formatted = formatter.format(dateTimeString);
    return formatted;
  }

  String formatDateTimeString(String dateTimeString) {
    // Parse chuỗi ngày và giờ thành đối tượng DateTime
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Định dạng lại ngày và giờ thành chuỗi "yyyy-MM-dd HH:mm:ss"
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }
}
