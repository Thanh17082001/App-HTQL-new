import 'package:app_flutter/ui/plan/form_plan/general_info.dart';
import 'package:app_flutter/ui/plan/list_plan/list_companion.dart';
import 'package:app_flutter/ui/plan/list_plan/list_cost.dart';
import 'package:app_flutter/ui/plan/list_plan/list_cost_business.dart';
import 'package:app_flutter/ui/plan/list_plan/list_cost_other.dart';
import 'package:app_flutter/ui/plan/list_plan/list_use_car.dart';
import 'package:app_flutter/ui/plan/list_plan/list_working_content.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: OnboardingPagePresenter(),
    );
  }
}

class OnboardingPagePresenter extends StatefulWidget {
  final VoidCallback? onSkip;
  final VoidCallback? onFinish;

  const OnboardingPagePresenter({super.key, this.onSkip, this.onFinish});

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  // Store the currently visible page
  int _currentPage = 0;
  // Define a controller for the pageview
  final PageController _pageController = PageController(initialPage: 0);
  final List<String> titles = [
    'Danh sách người đi cùng',
    'Nội dung công tác',
    'Đề nghị sử dụng xe',
    'Chi phí công tác',
    'Chi phí kinh doanh',
    'Chi phí khác',
    'Thông tin chung',
  ];

  final List<Widget> contents = [
     const ListCompanion(),
     const ListWorkingcontent(),
     const ListUseCar(),
     const ListCostPlan(),
     const ListCostBusiness(),
     const ListCostOther(),
     const GeneralInfomation(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top button control
            Container(
              margin: const EdgeInsets.only(top: 30),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //lùi
                  TextButton(
                      style: TextButton.styleFrom(
                          visualDensity: VisualDensity.comfortable,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        _pageController.animateToPage(_currentPage - 1,
                            curve: Curves.easeInOutCubic,
                            duration: const Duration(milliseconds: 250));
                      },
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.black,
                        weight: 700,
                        size: 40,
                      )),
                  SizedBox(
                    child: Text(
                      titles[_currentPage].toUpperCase(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  //Tới
                  TextButton(
                    style: TextButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      if (_currentPage == titles.length - 1) {
                        widget.onFinish?.call();
                      } else {
                        _pageController.animateToPage(_currentPage + 1,
                            curve: Curves.easeInOutCubic,
                            duration: const Duration(milliseconds: 250));
                      }
                    },
                    child: const Icon(Icons.chevron_right,
                        color: Colors.black, size: 40),
                  ),
                ],
              ),
            ),

            //trang
            Expanded(
              // Pageview to render each page
              child: PageView.builder(
                controller: _pageController,
                itemCount: titles.length,
                onPageChanged: (idx) {
                  // Change current page when pageview changes
                  setState(() {
                    _currentPage = idx;
                  });
                },
                itemBuilder: (context, idx) {
                  return contents[idx];
                },
              ),
            ),

            // Current page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: titles
                  .map((item) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: _currentPage == titles.indexOf(item) ? 30 : 8,
                        height: 8,
                        margin: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10.0)),
                      ))
                  .toList(),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}


