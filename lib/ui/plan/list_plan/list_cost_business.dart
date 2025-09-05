
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:app_flutter/model/plan/cost_model.dart';
import 'package:app_flutter/ui/plan/form_plan/cost_business.dart';
import 'package:app_flutter/ui/plan/manager/cost_business_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCostBusiness extends StatefulWidget {
  const ListCostBusiness({super.key});

  @override
  State<ListCostBusiness> createState() => _ListCompanionState();
}

class _ListCompanionState extends State<ListCostBusiness> {
  List<CostModel> costs = [];
  @override
  void initState() {
    super.initState();
    costs = [];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CostBusinessManager>(builder: (context, costBusinessManager, idx) {
      costs = costBusinessManager.costs;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () async {
              await Navigator.of(context).pushNamed(CostBusiness.routerName);
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
            child: costs.isEmpty ? const Center(
                    child: Text(
                    'Chưa có dữ liệu',
                    style: TextStyle(fontSize: 18),
                  )) : Accordion(
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
                children: _section(costs, context)),
          ),
          
        ],
      );
    });
  }

  List<AccordionSection> _section(costs, BuildContext context) {
    List<AccordionSection> accs = [];
    costs.forEach((cost) {
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
                    context.read<CostBusinessManager>().deleteAt(cost);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.red,
                    weight: 700,
                  )),
              const SizedBox(
                width: 15,
              ),
              Text(cost.hangMuc.toString(),
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
                'Hạng mục : ${cost.hangMuc.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Số lượng : ${cost.soLuong.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Đơn giá : ${cost.donGia.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Thành tiền : ${cost.thanhTien.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Ghi chú : ${cost.ghiChu.toString()}',
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
