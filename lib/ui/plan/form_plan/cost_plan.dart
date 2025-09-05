import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:app_flutter/model/category_model.dart';
import 'package:app_flutter/model/plan/cost_model.dart';
import 'package:app_flutter/shared/dialog.dart';
import 'package:app_flutter/ui/plan/manager/category_manager.dart';
import 'package:app_flutter/ui/plan/manager/cost_plan_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CostPlan extends StatefulWidget {
  static const routerName = '/cost';

  const CostPlan({super.key});

  @override
  State<CostPlan> createState() => _GeneralInfomationState();
}

class _GeneralInfomationState extends State<CostPlan> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController selectController = TextEditingController();
  List<DateTime>? dateTimeList;
  late String selected;
  List<CategoryModel> categories = [];
  int total = 0;

  Future getAllCategories(BuildContext context) async {
    await context.read<CategoryManager>().getAll();
  }

  CostModel data = CostModel(loaiChiPhiID: 1);

  submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    context.read<CostPlanManager>().addCostPlan(data);
    DialogForm.successDialog(context);
    _formKey.currentState!.reset();
    data = CostModel(loaiChiPhiID: 1);
  }

  @override
  void initState() {
    super.initState();
    getAllCategories(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi phí công tác'),
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
                    child: const Text('hạng mục'),
                  ),
                  _selectCategory(),
                  Container(
                    height: 25,
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text('Số lượng'),
                  ),
                  _textfieldQuantiy(),
                  Container(
                    height: 25,
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text('Đơn giá'),
                  ),
                  _textfieldUnitPrice(),
                  Container(
                    height: 25,
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text('Thành tiền'),
                  ),
                  _textfieldTotalPrice(),
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

  Widget _selectCategory() {
    return Consumer<CategoryManager>(builder: (ctx, categoryManager, index) {
      List<String> weeksName = [];
      categories = [];
      categories = categoryManager.categories;
      for (var elm in categories) {
        weeksName.add(elm.tenHangMuc.toString());
      }
      return CustomDropdown<String>.search(
        validator: (value) {
          if (value == null) {
            return 'Chọn hạng mục';
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
        hintText: 'Chọn hạng mục',
        items: weeksName,
        excludeSelected: false,
        onChanged: (value) {
          final selectedCategory =
              categories.firstWhere((element) => element.tenHangMuc == value);
          data.hangMucChiPhiID = selectedCategory.id;
          data.hangMuc = value;
        },
      );
    });
  }

  Widget _textfieldQuantiy() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          data.soLuong = int.parse(value);
          int soLuong = int.parse(value);
          int donGia = data.donGia ?? 0; // Nếu value là giá trị đơn giá

          data.thanhTien = soLuong * donGia;
        });
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
          hintText: 'Số lượng',
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
          return 'Nhập số lượng';
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        data.soLuong = int.parse(newValue!);
      },
    );
  }

  Widget _textfieldUnitPrice() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          // Chuyển đổi value sang int
          data.donGia = int.parse(value);
          int soLuong = data.soLuong ?? 0;
          int donGia = int.parse(value); // Nếu value là giá trị đơn giá

          data.thanhTien = soLuong * donGia;

          // Tính toán thành tiền
          // print(soLuong * donGia);
        });
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
          hintText: 'Đơn giá',
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
          return 'Nhập đơn giá';
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        data.donGia = int.parse(newValue!);
      },
    );
  }

  Widget _textfieldTotalPrice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 17),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black38, width: 1.25),
          borderRadius: BorderRadius.circular(10)),
      child: Text(' ${data.thanhTien ?? 0}'),
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
