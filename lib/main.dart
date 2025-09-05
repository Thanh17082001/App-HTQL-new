import 'package:app_flutter/screen_app.dart';
import 'package:app_flutter/ui/auth/auth_manager.dart';
import 'package:app_flutter/ui/plan/manager/category_manager.dart';
import 'package:app_flutter/ui/plan/manager/company_manager.dart';
import 'package:app_flutter/ui/map/google_map_screen.dart';
import 'package:app_flutter/ui/plan/form_plan/companion.dart';
import 'package:app_flutter/ui/plan/form_plan/cost_business.dart';
import 'package:app_flutter/ui/plan/form_plan/cost_other.dart';
import 'package:app_flutter/ui/plan/form_plan/cost_plan.dart';
import 'package:app_flutter/ui/plan/form_plan/use_car.dart';
import 'package:app_flutter/ui/plan/form_plan/working_content.dart';
import 'package:app_flutter/ui/plan/manager/companion_manager.dart';
import 'package:app_flutter/ui/plan/manager/cost_business_manager.dart';
import 'package:app_flutter/ui/plan/manager/cost_other_manager.dart';
import 'package:app_flutter/ui/plan/manager/cost_plan_manager.dart';
import 'package:app_flutter/ui/plan/manager/organ_manager.dart';
import 'package:app_flutter/ui/plan/manager/plan_manager.dart';
import 'package:app_flutter/ui/plan/manager/use_car_manager.dart';
import 'package:app_flutter/ui/plan/manager/working_content_manager.dart';
import 'package:app_flutter/ui/plan/plan_detail_screen.dart';
import 'package:app_flutter/ui/staff/history_checkin.dart';
import 'package:app_flutter/ui/staff/location_manager.dart';
import 'package:app_flutter/ui/staff/staff_manager.dart';
import 'package:app_flutter/ui/task/manager/task_manager.dart';
import 'package:app_flutter/ui/task/task_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/auth/auth_screen.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthManager()),
        ChangeNotifierProvider(create: (ctx) => LocationManager()),
        ChangeNotifierProvider(create: (ctx) => StaffManager()),
        ChangeNotifierProvider(create: (ctx) => PlanManager()),
        ChangeNotifierProvider(create: (ctx) => CompanionManager()),
        ChangeNotifierProvider(create: (ctx) => WorkingContentManager()),
        ChangeNotifierProvider(create: (ctx) => UseCarManager()),
        ChangeNotifierProvider(create: (ctx) => CostPlanManager()),
        ChangeNotifierProvider(create: (ctx) => CostBusinessManager()),
        ChangeNotifierProvider(create: (ctx) => CostOtherManager()),
        ChangeNotifierProvider(create: (ctx) => CompanyManager()),
        ChangeNotifierProvider(create: (ctx) => CategoryManager()),
        ChangeNotifierProvider(create: (ctx) => OrganManager()),
        ChangeNotifierProvider(create: (ctx) => TaskManager()),
        
      ],
      child: Consumer<AuthManager>(builder: (ctx, authMangager, child) {
        return MaterialApp(
          
          locale: const Locale('vi', 'VN'),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 248, 248, 248)),
            useMaterial3: true,
          ),
          home: authMangager.isLogin ? const ScreenApp() : const AuthScreen(),
          onGenerateRoute: (set) {
            if (set.name == LocationOnGoogleMap.routerName) {
              if(set.arguments !=null){
              final   staff = set.arguments as int;
              return MaterialPageRoute(builder: (ctx) {
                    return LocationOnGoogleMap(staff);
                  });
              }
            }
            else if (set.name == HistoryCheckIn.routerName) {
              if(set.arguments !=null){
              final   staff = set.arguments as int;
              return MaterialPageRoute(builder: (ctx) {
                    return HistoryCheckIn(staff);
                  });
              }
            }
            else if (set.name == Companion.routerName) {
              return MaterialPageRoute(builder: (ctx) {
                return const Companion();
              });
            }
            else if (set.name == WorkingContent.routerName) {
              return MaterialPageRoute(builder: (ctx) {
                return const WorkingContent();
              });
            }
            else if (set.name == UseCar.routerName) {
              return MaterialPageRoute(builder: (ctx) {
                return const UseCar();
              });
            }
            else if (set.name == CostPlan.routerName) {
              return MaterialPageRoute(builder: (ctx) {
                return const CostPlan();
              });
            }
            else if (set.name == CostBusiness.routerName) {
              return MaterialPageRoute(builder: (ctx) {
                return const CostBusiness();
              });
            }
            else if (set.name == CostOther.routerName) {
              return MaterialPageRoute(builder: (ctx) {
                return const CostOther();
              });
            }
            else if (set.name == PlanDetailScreen.routerName) {
             if (set.arguments != null) {
                final id = set.arguments as int;
                return MaterialPageRoute(builder: (ctx) {
                  return PlanDetailScreen(id);
                });
              }
            }
            else if (set.name == TaskDetail.routerName) {
              if (set.arguments != null) {
                final index = set.arguments as int;
                return MaterialPageRoute(builder: (ctx) {
                  return TaskDetail(index);
                });
              }
            }
            return null;
          },
        );
      }),
    );
  }
}