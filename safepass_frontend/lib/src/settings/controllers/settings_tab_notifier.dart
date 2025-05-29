import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/utils/common_json_model.dart';
import 'package:safepass_frontend/common/utils/cookies.dart';
import 'package:safepass_frontend/common/utils/refresh_access_token.dart';
import 'package:safepass_frontend/src/entrypoint/controllers/sidebar_notifier.dart';
import 'package:safepass_frontend/src/settings/models/temp_settings_model.dart';
import 'package:safepass_frontend/src/settings/models/visitor_details_model.dart';
import 'package:http/browser_client.dart' as http;

class SettingsTabNotifier with ChangeNotifier {
  int _tabIndex = 0;
  int get getTabIndex => _tabIndex;
  set setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  List<Visitor> _visitorDetails = [];
  List<Visitor> get getVisitorDetails => _visitorDetails;
  bool _isLoading = false;
  get getIsLoading => _isLoading;

  Visitor? _visitor;
  Visitor? get getVisitor => _visitor;
  set setVisitor(int id) {
    _visitor = _visitorDetails[id];
    notifyListeners();
  }

  Future<void> fetchVisitors(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      var client = http.BrowserClient();
      client.withCredentials = true;
      var url = Uri.parse(ApiUrls.visitorsUrl);
      var response = await client.get(url);

      if (response.statusCode == 200) {
        VisitorsModel model = visitorsModelFromJson(response.body);
        _visitorDetails = model.visitors;
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await refetch(context, fetch: () => fetchVisitors(context));
        }
      } else {
        CommonJsonModel model = commonJsonModelFromJson(response.body);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(model.detail),
              backgroundColor: AppColors.kDarkRed,
            ),
          );
        }
      }

    } catch (e) {
      print("SettingsTabNotifier:");
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  List<TempSettings> _settings = [];
  List<TempSettings> get getSettings => _settings;

  Future<void> fetchSettings(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      var client = http.BrowserClient();
      client.withCredentials = true;
      var url = Uri.parse(ApiUrls.settingsUrl);
      var response = await client.get(url);

      print("debug: ${response.body}");

      if (response.statusCode == 200) {
        TempSettingsModel model = tempSettingsModelFromJson(response.body);
        _settings = [model.tempSettings];
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await refetch(context, fetch: () => fetchVisitors(context));
        }
      } else {
        if (context.mounted) {
          CommonJsonModel model = commonJsonModelFromJson(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(model.detail)
            )
          );
        }
      }


    } catch (e) {
      print("SettingsTabNotifier:");
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
      print("debug: finished loading");
    }
  }

  Future<void> updateSettings({
    required BuildContext context,
    // required bool enableMfa,
    required String sessionTimeout,
    // required bool enableVisitorNotifs,
    // required bool enableAlerts,
    required bool enableScheduledReminders,
    required String maxVisitorsPerDay,
    required String maxVisitDuration
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      var client = http.BrowserClient();
      client.withCredentials = true;
      var url = Uri.parse(ApiUrls.updateSettingsUrl);
      var response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': AppCookies.getCSRFToken()
        },
        body: jsonEncode({
          "updated_settings": {
            // "enable_mfa": enableMfa,
            "session_timeout": sessionTimeout,
            // "enable_visitor_notifs": enableVisitorNotifs,
            // "enable_alerts": enableAlerts,
            "enable_scheduled_reminders": enableScheduledReminders,
            "max_visitors_per_day": maxVisitorsPerDay,
            "max_visit_duration": maxVisitDuration
          }
        })
      );
      
      CommonJsonModel model = commonJsonModelFromJson(response.body);
      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(model.detail),
              backgroundColor: AppColors.kDarkBlue,
            )
          );
        }
        if (context.mounted) {
          context.read<SidebarNotifier>().setIndex = 2;
          context.read<SettingsTabNotifier>().setTabIndex = 0;
        }
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await refetch(context, fetch: () => updateSettings(context: context, sessionTimeout: sessionTimeout, enableScheduledReminders: enableScheduledReminders, maxVisitorsPerDay: maxVisitorsPerDay, maxVisitDuration: maxVisitDuration));
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(model.detail),
              backgroundColor: AppColors.kDarkRed,
            )
          );
        }
      }
    } catch (e) {
      print("SettingsTabNotifier:");
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}