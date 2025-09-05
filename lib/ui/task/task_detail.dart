
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:app_flutter/model/task/history_model.dart';
import 'package:app_flutter/model/task/status_task_model.dart';
import 'package:app_flutter/model/task/task_file.dart';
import 'package:app_flutter/model/task/task_image.dart';
import 'package:app_flutter/model/task/task_model.dart';
import 'package:app_flutter/shared/dialog.dart';
import 'package:app_flutter/ui/task/manager/task_manager.dart';
import 'package:app_flutter/ui/task/task_pdf.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class TaskDetail extends StatefulWidget {
  static String routerName = '/task-detail';
  final int index;

  const TaskDetail(this.index, {super.key});

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  late TaskModel task;
  final GlobalKey<FormState> _formKey = GlobalKey();

  late List<StatusTaskModel> statuss;
  late int progress;
  late String status;
  late List<HistoryTaskModel> historys;
  late List<TaskFileModel> fileCongViec;
  // ignore: prefer_typing_uninitialized_variables, avoid_init_to_null
  late int indexFileImage = -1;
  late int indexFilePdf = -1;

  final data = {
    "congViecID": 0,
    "moTa": "string",
    "trangThaiID": 0,
    "tienDo": 0
  };

  _submit() async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();
      final result = await context.read<TaskManager>().updateStatus(data);
      // ignore: use_build_context_synchronously
      await context.read<TaskManager>().getListTask();
      setState(() {
        getTaskByIdex();
      });
      if (result) {
        // ignore: use_build_context_synchronously
        DialogForm.successDialog(context);
        _formKey.currentState?.reset();
      } else {
        // ignore: use_build_context_synchronously
        DialogForm.failureDialog(context);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      DialogForm.failureDialog(context);

      print({'Lỗi': e});
    }
  }

  getTaskByIdex() {
    task = context.read<TaskManager>().getTaskByIdex(widget.index);
    historys = task.lichSuCongViec!;
    progress =
        (historys.isNotEmpty ? historys[historys.length - 1].tienDo : 0)!;
    status = (historys.isNotEmpty
        ? historys[historys.length - 1].trangThaiCongViec?.tenTrangThai
        : 'Chưa thực hiện')!;

    fileCongViec = task.fileCongViec ?? [];
    indexFileImage = fileCongViec.indexWhere((item) => item.loai == 1);
     indexFilePdf = fileCongViec.indexWhere((item) => item.loai == 2);
  }

  Future getListStatus() async {
    await context.read<TaskManager>().getListStatus();
    // ignore: use_build_context_synchronously
    statuss = context.read<TaskManager>().status;
  }

  @override
  void initState() {
    super.initState();
    getTaskByIdex();
  }

  @override
  Widget build(BuildContext context) {
    data['congViecID'] = task.congViecID!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết công việc'),
      ),
      body: Container(
          height: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'I. Thông tin chung'.toUpperCase(),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue),
              ),
              _general(),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'III. lịch sử báo cáo'.toUpperCase(),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue),
              ),
              Expanded(flex: 7, child: _history()),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 50, child: _reportButtom()),
                      percentIndicator(),
                    ],
                  ))
            ],
          )),
    );
  }

  Widget _general() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tên công việc:  ${task.tenCongViec}',
          style: const TextStyle(fontSize: 14),
        ),
        Text(
          'Người thực hiện:  ${task.nguoiThucHienTen}',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          'Mô tả:  ${task.moTa}',
          style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.fade,
          softWrap: true,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          'Ngày bắt đầu:  ${task.ngayBatDau}',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          'Ngày kết thúc:  ${task.ngayKetThuc}',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          'Độ ưu tiên:  ${task.tenDoUuTien}',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          'Ngày kết thúc:  ${task.ngayKetThuc}',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          'Nhóm công việc:  ${task.tenNhomCongViec}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          'Trạng thái:  $status',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          'Tiến độ:  $progress%',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            const Text(
              'File:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              width: 10,
            ),
            if (indexFilePdf ==-1) const Text('Không có dữ liệu'),
            if (indexFilePdf!=-1)
              GestureDetector(
                  onTap: () {
                    final data = fileCongViec[indexFilePdf];
                    
                    final Map<String, dynamic> file = {
                      "fileName": data.fileName,
                      "fileUrl":
                          "${dotenv.env['API_URL_FILE']}${data.fileUrl}"
                    };
                    openPDF(context, file);
                  },
                  child: const Text(
                    'Xem chi tiết',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontStyle: FontStyle.italic,
                        fontSize: 16),
                  ))
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            const Text(
              'Hình ảnh:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              width: 10,
            ),
            if (indexFileImage == -1) const Text('Không có dữ liệu'),
            if (indexFileImage != -1)
              GestureDetector(
                  onTap: () {
                    final data = fileCongViec[indexFileImage];
                    final Map<String, dynamic> file = {
                      "fileName": data.fileName,
                      "fileUrl":
                          "${dotenv.env['API_URL_FILE']}${data.fileUrl}"
                    };
                    openImage(context, file);
                  },
                  child: const Text(
                    'Xem chi tiết',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontStyle: FontStyle.italic,
                        fontSize: 16),
                  ))
          ],
        ),
      ],
    );
  }

  Widget _status() {
    return FutureBuilder(
        future: getListStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<TaskManager>(builder: (ctx, taskManager, index) {
              List<String> priorityTaskNames = [];

              data['trangThaiID'] = statuss.isEmpty
                  ? statuss
                      .firstWhere(
                        (element) => element.tenTrangThai == status,
                      )
                      .trangThaiID!
                  : 1;

              for (var item in statuss) {
                priorityTaskNames.add(item.tenTrangThai.toString());
              }
              priorityTaskNames.add('Chưa thực hiện');
              return CustomDropdown<String>.search(
                initialItem: status,
                validator: (value) {
                  if (value == null) {
                    return 'Chọn độ ưu tiên';
                  } else {
                    return null;
                  }
                },
                decoration: CustomDropdownDecoration(
                    headerStyle: const TextStyle(color: Colors.blue),
                    expandedBorderRadius: BorderRadius.circular(1),
                    closedBorderRadius: BorderRadius.circular(4),
                    closedBorder: Border.all(
                        color: Colors.black38,
                        width: 1,
                        style: BorderStyle.solid)),
                hintText: 'Chọn độ ưu tiên',
                items: priorityTaskNames,
                excludeSelected: false,
                onChanged: (value) async {
                  final selected = statuss.firstWhere(
                    (element) => element.tenTrangThai == value,
                  );

                  setState(() {
                    data["trangThaiID"] = selected.trangThaiID!;
                  });
                },
              );
            });
          } else {
            return Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: const Color.fromARGB(255, 0, 0, 0),
                size: 30,
              ),
            );
          }
        });
  }

  Widget _history() {
    return SizedBox(
      height: 200,
      child: Consumer<TaskManager>(builder: (context, taskManager, ind) {
        return ListView.builder(
          itemCount: historys.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1.25, color: Colors.black26),
                  borderRadius: BorderRadius.circular(5)),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ngày báo cáo: ${historys[index].thoiGian}'),
                  Text('Nội dung: ${historys[index].moTa}'),
                  Text('Tiến độ: ${historys[index].tienDo}%'),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _reportButtom() {
    return GestureDetector(
      onTap: () {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          isDense: true,
          animType: AnimType.scale,
          title: 'Dialog Title',
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(
                    'Báo cáo công việc'.toUpperCase(),
                    style: const TextStyle(fontSize: 16),
                  )),
                  const SizedBox(
                    height: 25,
                    child: Text('Trạng thái'),
                  ),
                  _status(),
                  const SizedBox(
                    height: 25,
                    child: Text('Nội dung báo cáo'),
                  ),
                  _descriptionTaskField(),
                  const SizedBox(
                    height: 25,
                    child: Text('Tiến độ'),
                  ),
                  _processTaskField(),
                ],
              ),
            ),
          ),
          btnOk: GestureDetector(
            onTap: () async {
              await _submit();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                  child: Text(
                'Lưu',
                style: TextStyle(color: Colors.white),
              )),
            ),
          ),
          btnCancel: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                  child: Text(
                'Hủy',
                style: TextStyle(color: Colors.white),
              )),
            ),
          ),
          btnOkOnPress: () async {},
        ).show();
      },
      child: Container(
          width: 90,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(5)),
          child: const Center(
              child: Text(
            'Báo cáo',
            style: TextStyle(color: Colors.white),
          ))),
    );
  }

  Widget percentIndicator() {
    return SingleChildScrollView(
      child: CircularPercentIndicator(
        radius: 36.0,
        lineWidth: 8.0,
        animation: true,
        percent: progress / 100,
        center: Text(
          "$progress%",
          style: const TextStyle(fontSize: 18.0, color: Colors.black87),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        backgroundColor: const Color.fromARGB(255, 197, 197, 197),
        progressColor: progress == 100 ? Colors.green : Colors.blue,
      ),
    );
  }

  Widget _descriptionTaskField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
          hintText: 'Nội dung báo cáo',
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
          return 'Nhập mô tả';
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        data["moTa"] = newValue!;
      },
    );
  }

  Widget _processTaskField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
          hintText: 'Phần trăm tiến độ',
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
        if (value!.isEmpty || int.parse(value) <= 0 || int.parse(value) > 100) {
          return 'Nhập tiến độ';
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        data["tienDo"] = newValue!;
      },
    );
  }

  void openPDF(BuildContext context, Map<String, dynamic> file) =>
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => PDFViewerPageNetwork(file: file)),
      );

  void openImage(BuildContext context, Map<String, dynamic> file) =>
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => TaskImage(file: file)),
      );
}
