import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:app_flutter/model/organ/organe_model.dart';
import 'package:app_flutter/model/plan/working_content_model.dart';
import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:app_flutter/shared/dialog.dart';
import 'package:app_flutter/ui/plan/manager/organ_manager.dart';
import 'package:app_flutter/ui/plan/manager/plan_manager.dart';
import 'package:app_flutter/ui/plan/manager/working_content_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

class WorkingContent extends StatefulWidget {
  static const routerName = '/work';

  const WorkingContent({super.key});

  @override
  State<WorkingContent> createState() => _GeneralInfomationState();
}

class _GeneralInfomationState extends State<WorkingContent> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController selectController = TextEditingController();
  List<DateTime>? dateTimeList;
  late String selected;
  List<OrganModel> organs = [];
  List<StaffModel> staffs = [];
  bool isDate = false;

  Future getAllOrgan({required BuildContext context}) async {
    try {
      await context.read<OrganManager>().getAll();
    } catch (e) {
      print(e);
    }
  }

  WorkingContentModel data = WorkingContentModel();

  submit() {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        isDate = true;
      });
      return;
    }
    _formKey.currentState!.save();

    context.read<WorkingContentManager>().addWorkingContent(data);
    DialogForm.successDialog(context);
    _formKey.currentState!.reset();
    data = WorkingContentModel();
  }

  @override
  void initState() {
    super.initState();
    getAllOrgan(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nội dung công tác'),
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
                    child: const Text('Nơi đến'),
                  ),
                  _selectFrom(),
                  Container(
                    height: 25,
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text('Bước thị trường'),
                  ),
                  _selectMarketStep(),
                  Container(
                    height: 25,
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text('Nội dung'),
                  ),
                  _textfieldContent(),
                  Container(
                    height: 25,
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text('Ngày thực hiện'),
                  ),
                  _dateTiemPicker(),
                  if (isDate)
                    const SizedBox(
                      height: 20,
                      child: Text(
                        'Chọn ngày thực hiện',
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
                  _buttonSubmit()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectFrom() {
    return Consumer<OrganManager>(builder: (ctx, organManager, index) {
      List<String> weeksName = [];
      organs = organManager.organs;
      for (var elm in organs) {
        weeksName.add(elm.tenCoQuan.toString());
      }
      return CustomDropdown<String>.search(
        validator: (value) {
          if (value == null) {
            return 'Chọn nơi đến';
          } else {
            return null;
          }
        },
        decoration: CustomDropdownDecoration(
            headerStyle: const TextStyle(color: Colors.blue),
            expandedBorderRadius: BorderRadius.circular(1),
            closedBorderRadius: BorderRadius.circular(4),
            closedBorder: Border.all(
                color: Colors.black38, width: 1, style: BorderStyle.solid)),
        hintText: 'Chọn nơi đến',
        items: weeksName,
        excludeSelected: false,
        onChanged: (value) {
          final selectedOrgan =
              organs.firstWhere((element) => element.tenCoQuan == value);
          data.noiDen = value;
          data.coQuanID = selectedOrgan.coQuanID;
        },
      );
    });
  }

  Widget _selectMarketStep() {
    return Consumer<PlanManager>(builder: (ctx, planManager, index) {
      final itmes = [
        'Thông tin',
        'Công thức',
        'Cách làm',
        'Tiềm năng',
        'Cơ hội',
        'Cơ hội rõ ràng',
        'Quy trình mua sắm'
      ];
      return CustomDropdown<String>.search(
        validator: (value) {
          if (value == null) {
            return 'Chọn bước thị trường';
          } else {
            return null;
          }
        },
        decoration: CustomDropdownDecoration(
            headerStyle: const TextStyle(color: Colors.blue),
            expandedBorderRadius: BorderRadius.circular(1),
            closedBorderRadius: BorderRadius.circular(4),
            closedBorder: Border.all(
                color: Colors.black38, width: 1, style: BorderStyle.solid)),
        hintText: 'Chọn bước thị trường',
        items: itmes,
        excludeSelected: false,
        onChanged: (value) {
          data.tenBuocThiTruong = value;
        },
      );
    });
  }

  Widget _textfieldContent() {
    return TextFormField(
      decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
          hintText: 'Nội dung',
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
          return 'Nhập nội dung';
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        data.chiTiet = newValue!;
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
        data.ngayThucHien = formatDate(dateTimeList![0]);
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
                  : 'Ngày thực hiện',
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
