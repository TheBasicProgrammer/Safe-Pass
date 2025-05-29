import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/utils/routes.dart';
import 'package:safepass_frontend/src/auth/controller/jwt_notifier.dart';
import 'package:safepass_frontend/src/auth/controller/password_notifier.dart';
import 'package:safepass_frontend/src/check_in/controller/visit-purpose_controller.dart';
import 'package:safepass_frontend/src/check_in/controller/visitor_search_controller.dart';
import 'package:safepass_frontend/src/check_out/controller/check_out_controller.dart';
import 'package:safepass_frontend/src/check_out/repository/check_out_repository.dart';
import 'package:safepass_frontend/src/dashboard/controllers/notif_controller.dart';
import 'package:safepass_frontend/src/entrypoint/controllers/sidebar_notifier.dart';
import 'package:safepass_frontend/src/registration/controller/id_types_controller.dart';
import 'package:safepass_frontend/src/settings/controllers/settings_tab_notifier.dart';
import 'package:safepass_frontend/src/logs/controllers/visitorlogs_controller.dart';
import 'package:safepass_frontend/src/visitor/controllers/visitor_details_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env.development'); //comment for checkpoint

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SidebarNotifier()),
      ChangeNotifierProvider(create: (_) => PasswordNotifier()),
      ChangeNotifierProvider(create: (_) => SettingsTabNotifier()),
      ChangeNotifierProvider(create: (_) => JwtNotifier()),
      ChangeNotifierProvider(create: (_) => VisitorLogsController()),
      ChangeNotifierProvider(create: (_) => IdTypesController()),
      ChangeNotifierProvider(create: (_) => VisitPurposesController()),
      ChangeNotifierProvider(create: (_) => VisitorDetailsController()),
      ChangeNotifierProvider(create: (_) => VisitorSearchController()),
      ChangeNotifierProvider(create: (_) => CheckOutController()),
      ChangeNotifierProvider(create: (_) => NotifController()),
    ],
    child: MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Safe Pass",
      routerConfig: router,
      theme: ThemeData(
        splashColor: AppColors.kDarkBlue.withValues(
          alpha: 0.2
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: AppColors.kWhite
        ),
        listTileTheme: ListTileThemeData(
          selectedTileColor: AppColors.kDarkBlue.withValues(
            alpha: 0.8
          ),
          selectedColor: AppColors.kWhite
        ),
        scaffoldBackgroundColor: AppColors.kWhite,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.kDarkBlue,
          selectionColor: AppColors.kDarkBlue.withValues(
            alpha: 0.2
          )
        )
      ),
      builder: (context, child) {
        final double width = MediaQuery.sizeOf(context).width;
        final double height = MediaQuery.sizeOf(context).height;
        
        return Scaffold(
          body: Stack(
            children: [
              child!,

              Text(
                "$width x $height",
                style: TextStyle(
                  fontSize: 8,
                  color: AppColors.kDarkGray,
                )
              )
            ]
          )
        );
      },
    );
  }
}