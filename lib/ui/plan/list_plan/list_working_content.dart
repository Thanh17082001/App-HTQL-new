import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:app_flutter/model/plan/working_content_model.dart';
import 'package:app_flutter/ui/plan/form_plan/working_content.dart';
import 'package:app_flutter/ui/plan/manager/working_content_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListWorkingcontent extends StatefulWidget {
  const ListWorkingcontent({super.key});

  @override
  State<ListWorkingcontent> createState() => _ListCompanionState();
}

class _ListCompanionState extends State<ListWorkingcontent> {
  List<WorkingContentModel> works = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    works = [];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkingContentManager>(
        builder: (context, workManager, idx) {
      works = workManager.works;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () async {
              await Navigator.of(context).pushNamed(WorkingContent.routerName);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Thêm mới'.toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: works.isEmpty
                ? const Center(
                    child: Text(
                    'Chưa có dữ liệu',
                    style: TextStyle(fontSize: 18),
                  ))
                : Accordion(
                    headerBorderColor: Colors.blueGrey,
                    headerBorderColorOpened: Colors.transparent,
                    headerBorderWidth: 1,
                    headerBackgroundColorOpened: Colors.green,
                    contentBackgroundColor: Colors.white,
                    contentBorderColor: Colors.green,
                    contentBorderWidth: 3,
                    scaleWhenAnimating: true,
                    openAndCloseAnimation: true,
                    headerPadding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                    sectionClosingHapticFeedback: SectionHapticFeedback.light,
                    children: _section(works, context)),
          ),
        ],
      );
    });
  }

  List<AccordionSection> _section(works,BuildContext context) {
    List<AccordionSection> accs = [];
    works.forEach((work) {
      accs.add(
        AccordionSection(
          isOpen: false,
          rightIcon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black54,
            size: 20,
          ),
          headerBackgroundColor: Colors.transparent,
          headerBackgroundColorOpened: Colors.white,
          headerBorderColor: Colors.black54,
          headerBorderColorOpened: Colors.black54,
          headerBorderWidth: 1,
          headerBorderRadius: 4,
          headerPadding: const EdgeInsets.all(12),
          contentBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
          contentBorderColor: Colors.black54,
          contentBorderWidth: 1,
          contentVerticalPadding: 15,
          contentHorizontalPadding: 0,
          header: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    context.read<WorkingContentManager>().deleteAt(work);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.red,
                    weight: 700,
                  )),
              const SizedBox(
                width: 15,
              ),
              Text(work.noiDen.toString(),
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nơi đến : ${work.noiDen.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Bước thị trường : ${work.tenBuocThiTruong.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Nội dung : ${work.chiTiet.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Ngày thực hiện : ${work.ngayThucHien.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Ghi chú : ${work.ghiChu.toString()}',
                maxLines: 4,
                style: TextStyle(color: Colors.black45, fontSize: 17),
              ),
            ],
          ),
        ),
      );
    });
    return accs;
  }
}
