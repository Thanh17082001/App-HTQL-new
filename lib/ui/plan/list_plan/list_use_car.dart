
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:app_flutter/model/plan/use_car_model.dart';
import 'package:app_flutter/ui/plan/form_plan/use_car.dart';
import 'package:app_flutter/ui/plan/manager/use_car_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListUseCar extends StatefulWidget {
  const ListUseCar({super.key});

  @override
  State<ListUseCar> createState() => _ListCompanionState();
}

class _ListCompanionState extends State<ListUseCar> {
  List<UseCarModel> cars = [];
  @override
  void initState() {
    super.initState();
    cars = [];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UseCarManager>(builder: (context, carManager, idx) {
      cars = carManager.cars;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
           GestureDetector(
            onTap: () async {
              await Navigator.of(context).pushNamed(UseCar.routerName);
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
            child: cars.isEmpty ? const Center(
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
                children: _section(cars, context)),
          ),
         
        ],
      );
    });
  }

  List<AccordionSection> _section(cars, BuildContext context) {
    List<AccordionSection> accs = [];
    cars.forEach((car) {
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
                    context.read<UseCarManager>().deleteAt(car);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.red,
                    weight: 700,
                  )),
              const SizedBox(
                width: 15,
              ),
              Text(car.ngaySuDung.toString(),
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
                'Nơi đi : ${car.noiDi.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Nơi đến : ${car.noiDen.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Số km tạm tính : ${car.kmTamTinh.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
               Text(
                'Ngày sử dụng : ${car.ngaySuDung.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
               Text(
                'Ghi chú : ${car.ghiChu.toString()}',
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
