import 'package:app_flutter/model/plan/plan_model.dart';
import 'package:app_flutter/model/plan/use_car_model.dart';
import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:app_flutter/shared/dialog.dart';
import 'package:app_flutter/ui/plan/manager/plan_manager.dart';
import 'package:app_flutter/ui/plan/manager/use_car_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
class UseCar extends StatefulWidget {
  static const routerName = '/car';
  const UseCar({super.key});

  @override
  State<UseCar> createState() => _GeneralInfomationState();
}

class _GeneralInfomationState extends State<UseCar> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController selectController = TextEditingController();
  List<DateTime>? dateTimeList;
  late String selected;
  List<WeekModel> weeks = [];
  List<StaffModel> staffs = [];
  bool isDate = false;

  Future getPlanWeekByIdUser(BuildContext context) async {
    await context.read<PlanManager>().getPlanWeekByIdUser();
    // ignore: use_build_context_synchronously
    await context.read<PlanManager>().getStaffByRoles();
  }

   UseCarModel data = UseCarModel();

  submit() {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        isDate = true;
      });
      return;
    }
    _formKey.currentState!.save();

    context.read<UseCarManager>().addUseCar(data);
    DialogForm.successDialog(context);
    _formKey.currentState!.reset();
    data = UseCarModel();
  }

  @override
  void initState() {
    super.initState();
    getPlanWeekByIdUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sử dụng xe'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 25,
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text('Nơi đi'),
                  ),
                  _textfieldStart(),
                  Container(
                    height: 25,
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text('Nơi đến'),
                  ),
                  _textfieldEnd(),
                  Container(
                    height: 25,
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text('Số km tạm tính'),
                  ),
                  _textfieldDistance(),
                  Container(
                    height: 25,
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text('Ngày sử dụng'),
                  ),
                  _dateTiemPicker(),
                  if (isDate)
                    const SizedBox(
                      height: 20,
                      child: Text(
                        'Chọn ngày sử dụng',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  Container(
                    height: 25,
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text('Ghi chú'),
                  ),
                  _textfieldNote(),
                  Container(
                    height: 25,
                    margin: const EdgeInsets.only(top: 20),
                  ),
                  _buttonSubmit(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textfieldStart() {
    return TextFormField(
      decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
          hintText: 'Nơi đi',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.black38, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(12)),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.25),
            borderRadius: BorderRadius.circular(12),
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Nhập Nơi đi';
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        data.noiDi = newValue!;
      },
    );
  }

  Widget _textfieldEnd() {
    return TextFormField(
      decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
          hintText: 'Nơi đến',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.black38, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(12)),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.25),
            borderRadius: BorderRadius.circular(12),
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Nhập Nơi đến';
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        data.noiDen = newValue!;
      },
    );
  }

  Widget _textfieldDistance() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
          hintText: 'Số km tạm tính',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.black38, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(12)),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.25),
            borderRadius: BorderRadius.circular(12),
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Nhập Số km tạm tính';
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        data.kmTamTinh = int.parse(newValue!);
      },
    );
  }

  Widget _textfieldNote() {
    return TextFormField(
      decoration: InputDecoration(
          hintText: 'Ghi chú',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.black38, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(12)),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.25),
            borderRadius: BorderRadius.circular(12),
          )),
      onSaved: (newValue) {
        data.ghiChu = newValue;
      },
    );
  }

  Widget _dateTiemPicker() {
    return GestureDetector(
      onTap: () async {
        dateTimeList = await showOmniDateTimeRangePicker(
          isForceEndDateAfterStartDate: true,
          theme: ThemeData(
            cardColor: Colors.red,
          ),
          context: context,
          startInitialDate: DateTime.now(),
          startFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
          startLastDate: DateTime.now().add(
            const Duration(days: 3652),
          ),
          type: OmniDateTimePickerType.dateAndTime,
          is24HourMode: true,
          isShowSeconds: false,
          minutesInterval: 1,
          secondsInterval: 1,
          isForce2Digits: true,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          constraints: const BoxConstraints(
            maxWidth: 350,
            maxHeight: 650,
          ),
          transitionBuilder: (context, anim1, anim2, child) {
            return FadeTransition(
              opacity: anim1.drive(
                Tween(
                  begin: 0,
                  end: 1,
                ),
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 200),
          barrierDismissible: true,
          selectableDayPredicate: (dateTime) {
            // Disable 25th Feb 2023
            if (dateTime == DateTime(2023, 2, 25)) {
              return false;
            } else {
              return true;
            }
          },
        );
        data.ngaySuDung = formatDate(dateTimeList![0]);

        setState(() {
          if (dateTimeList?[0] != null) {
            setState(() {
              isDate = false;
            });
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
            border: Border.all(
                width: 1.25, color: !isDate ? Colors.black38 : Colors.red),
            color: const Color.fromARGB(26, 192, 192, 192),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateTimeList?[0] != null
                  ? formatDate(dateTimeList![0])
                  : 'Ngày sử dụng',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const Icon(Icons.date_range)
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    String formattedDate =
        dateFormat.format(date.toUtc().add(const Duration(hours: 7)));
    return formattedDate;
  }

  Widget _buttonSubmit() {
    return GestureDetector(
      onTap: () {
        submit();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(4)),
        child: const Center(
            child: Text(
          'Thêm',
          style: TextStyle(color: Colors.white, fontSize: 18),
        )),
      ),
    );
  }
}
