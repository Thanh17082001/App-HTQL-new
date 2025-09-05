import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:app_flutter/model/plan/companion_model.dart';
import 'package:app_flutter/ui/plan/form_plan/companion.dart';
import 'package:app_flutter/ui/plan/manager/companion_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCompanion extends StatefulWidget {
  const ListCompanion({super.key});

  @override
  State<ListCompanion> createState() => _ListCompanionState();
}

class _ListCompanionState extends State<ListCompanion> {
  List<CompanionModel> coms = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coms = [];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompanionManager>(builder: (context, comManager, idx) {
      coms = comManager.companions;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () async {
              await Navigator.of(context).pushNamed(Companion.routerName);
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
            child: coms.isEmpty
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
                    children: _section(coms, context)),
          ),
        ],
      );
    });
  }

  List<AccordionSection> _section(coms, BuildContext context) {
    List<AccordionSection> accs = [];
    coms.forEach((companion) {
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
          contentHorizontalPadding: 10,
          header: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    context.read<CompanionManager>().deleteByIndex(companion);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.red,
                    weight: 700,
                  )),
              const SizedBox(
                width: 15,
              ),
              Text(companion.tenNhanVien.toString(),
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
                'Họ Tên : ${companion.tenNhanVien.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Công ty : ${companion.tenCongTy.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Phòng ban : ${companion.tenPhongBan.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Chức vụ : ${companion.tenChuVu.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
            ],
          ),
        ),
      );
    });
    return accs;
  }
}
