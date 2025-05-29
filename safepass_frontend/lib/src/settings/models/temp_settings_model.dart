// To parse this JSON data, do
//
//     final tempSettingsModel = tempSettingsModelFromJson(jsonString);

import 'dart:convert';

TempSettingsModel tempSettingsModelFromJson(String str) => TempSettingsModel.fromJson(json.decode(str));

String tempSettingsModelToJson(TempSettingsModel data) => json.encode(data.toJson());

class TempSettingsModel {
    TempSettings tempSettings;

    TempSettingsModel({
        required this.tempSettings,
    });

    factory TempSettingsModel.fromJson(Map<String, dynamic> json) => TempSettingsModel(
        tempSettings: TempSettings.fromJson(json["temp_settings"]),
    );

    Map<String, dynamic> toJson() => {
        "temp_settings": tempSettings.toJson(),
    };
}

class TempSettings {
    int id;
    // bool enableMfa;
    int sessionTimeout;
    // bool enableVisitorNotifs;
    // bool enableAlerts;
    bool enableScheduledReminders;
    int maxVisitorsPerDay;
    int maxVisitDuration;

    TempSettings({
        required this.id,
        // required this.enableMfa,
        required this.sessionTimeout,
        // required this.enableVisitorNotifs,
        // required this.enableAlerts,
        required this.enableScheduledReminders,
        required this.maxVisitorsPerDay,
        required this.maxVisitDuration,
    });

    factory TempSettings.fromJson(Map<String, dynamic> json) => TempSettings(
        id: json["id"],
        // enableMfa: json["enable_mfa"],
        sessionTimeout: json["session_timeout"],
        // enableVisitorNotifs: json["enable_visitor_notifs"],
        // enableAlerts: json["enable_alerts"],
        enableScheduledReminders: json["enable_scheduled_reminders"],
        maxVisitorsPerDay: json["max_visitors_per_day"],
        maxVisitDuration: json["max_visit_duration"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        // "enable_mfa": enableMfa,
        "session_timeout": sessionTimeout,
        // "enable_visitor_notifs": enableVisitorNotifs,
        // "enable_alerts": enableAlerts,
        "enable_scheduled_reminders": enableScheduledReminders,
        "max_visitors_per_day": maxVisitorsPerDay,
        "max_visit_duration": maxVisitDuration,
    };
}
