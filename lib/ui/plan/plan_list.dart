import 'dart:convert';

import 'package:app_flutter/ui/plan/manager/plan_manager.dart';
import 'package:app_flutter/ui/plan/plan_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PlanListScreen extends StatefulWidget {
  const PlanListScreen({super.key});

  @override
  State<PlanListScreen> createState() => _PlanListScreenState();
}

class _PlanListScreenState extends State<PlanListScreen> {
  Future getAllPlanDay({required BuildContext context}) async {
    context.read<PlanManager>().getAllPlanDay();
  }

  @override
  void initState() {
    super.initState();
    getAllPlanDay(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(bottom: 20),
              height: 25,
              child: Text(
                'Danh sách kế hoạch công tác'.toUpperCase(),
                style: const TextStyle(fontSize: 20),
              )),
          Expanded(child:
              Consumer<PlanManager>(builder: (context, planManager, idx) {
            final plan = planManager.planDays;
            return ListView.builder(
                itemCount: plan.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                        border: Border(
                            top: index == 0
                                ? const BorderSide(
                                    width: 1.25, color: Colors.black12)
                                : BorderSide.none,
                            bottom: const BorderSide(
                                width: 1.25, color: Colors.black12))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text('${(index + 1).toString()} .')),
                              Expanded(
                                  flex: 13,
                                  child: Text(plan[index].hoTen.toString(), style: const TextStyle(fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),)),
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            PlanDetailScreen.routerName,
                                            arguments: plan[index].ngayID);
                                      },
                                      child: const Icon(
                                        Icons.remove_red_eye,
                                        color:
                                            Color.fromARGB(255, 117, 191, 252),
                                      )))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(flex: 2, child: Text('Mục đích: ${plan[index].mucDich}',
                               overflow: TextOverflow.ellipsis,
                               maxLines: 2,
                                    softWrap: true,
                                  )),
                              Expanded(flex: 1, child: Text(' ${dateFormatString(plan[index].tuNgay.toString())}')),
                              Expanded(flex: 1, child: Text(' ${dateFormatString(plan[index].denNgay.toString())}'))
                            ],
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Text('Trạng thái: ', style: TextStyle(fontWeight: FontWeight.w500),),
                                  Text('${plan[index].khcTNgayLichSu![0].khcTNgayTrangThai?.tenTrangThai}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(': ${plan[index].khcTNgayLichSu![0].nhanVien?.tenNhanVien}',style: TextStyle(fontWeight: FontWeight.w500),),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
          }))
        ],
      ),
    );
  }

  String dateFormatString(String dateTimeString) {
    DateFormat inputFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
    DateTime dateTime = inputFormat.parse(dateTimeString);

    // Định dạng chuỗi đầu ra
    DateFormat outputFormat = DateFormat("dd/MM/yyyy");
    String formattedDate = outputFormat.format(dateTime);

    return formattedDate;
  }
}
