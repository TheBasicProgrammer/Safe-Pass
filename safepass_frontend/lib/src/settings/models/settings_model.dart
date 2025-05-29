import 'dart:convert';

SettingsValuesModel settingsValuesModelFromJson(String str) => SettingsValuesModel.fromJson(json.decode(str));

String settingsValuesModelToJson(SettingsValuesModel data) => json.encode(data.toJson());

class SettingsValuesModel {
    Settings settings;

    SettingsValuesModel({
        required this.settings,
    });

    factory SettingsValuesModel.fromJson(Map<String, dynamic> json) => SettingsValuesModel(
        settings: Settings.fromJson(json["settings"]),
    );

    Map<String, dynamic> toJson() => {
        "settings": settings.toJson(),
    };
}

class Settings {
    Security security;
    Notifications notifications;
    Visitors visitors;
    Exports exports;

    Settings({
        required this.security,
        required this.notifications,
        required this.visitors,
        required this.exports,
    });

    factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        security: Security.fromJson(json["security"]),
        notifications: Notifications.fromJson(json["notifications"]),
        visitors: Visitors.fromJson(json["visitors"]),
        exports: Exports.fromJson(json["exports"]),
    );

    Map<String, dynamic> toJson() => {
        "security": security.toJson(),
        "notifications": notifications.toJson(),
        "visitors": visitors.toJson(),
        "exports": exports.toJson(),
    };
}

class Exports {
    DropdownOption exportFormat;

    Exports({
        required this.exportFormat,
    });

    factory Exports.fromJson(Map<String, dynamic> json) => Exports(
        exportFormat: DropdownOption.fromJson(json["export_format"]),
    );

    Map<String, dynamic> toJson() => {
        "export_format": exportFormat.toJson(),
    };
}

class Notifications {
    // bool enableVisitorNotifications;
    // bool enableAlerts;
    bool enableScheduledReminders;

    Notifications({
        // required this.enableVisitorNotifications,
        // required this.enableAlerts,
        required this.enableScheduledReminders,
    });

    factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        // enableVisitorNotifications: json["enable_visitor_notifications"],
        // enableAlerts: json["enable_alerts"],
        enableScheduledReminders: json["enable_scheduled_reminders"],
    );

    Map<String, dynamic> toJson() => {
        // "enable_visitor_notifications": enableVisitorNotifications,
        // "enable_alerts": enableAlerts,
        "enable_scheduled_reminders": enableScheduledReminders,
    };
}

class Security {
    // bool enableMultiFactorAuth;
    DropdownOption sessionTimeout;

    Security({
        // required this.enableMultiFactorAuth,
        required this.sessionTimeout,
    });

    factory Security.fromJson(Map<String, dynamic> json) => Security(
        // enableMultiFactorAuth: json["enable_multi_factor_auth"],
        sessionTimeout: DropdownOption.fromJson(json["session_timeout"]),
    );

    Map<String, dynamic> toJson() => {
        // "enable_multi_factor_auth": enableMultiFactorAuth,
        "session_timeout": sessionTimeout.toJson(),
    };
}

class Visitors {
    DropdownOption maximumVisitorsPerDay;
    DropdownOption maximumVisitDuration;

    Visitors({
        required this.maximumVisitorsPerDay,
        required this.maximumVisitDuration,
    });

    factory Visitors.fromJson(Map<String, dynamic> json) => Visitors(
        maximumVisitorsPerDay: DropdownOption.fromJson(json["max_visitors_per_day"]),
        maximumVisitDuration: DropdownOption.fromJson(json["max_visit_duration"]),
    );

    Map<String, dynamic> toJson() => {
        "max_visitors_per_day": maximumVisitorsPerDay.toJson(),
        "max_visit_duration": maximumVisitDuration.toJson(),
    };
}

DropdownOptionsModel dropdownOptionsModelFromJson(String str) => DropdownOptionsModel.fromJson(json.decode(str));

String dropdownOptionsModelToJson(DropdownOptionsModel data) => json.encode(data.toJson());

class DropdownOptionsModel {
    List<DropdownOption> dropdownOptions;

    DropdownOptionsModel({
        required this.dropdownOptions,
    });

    factory DropdownOptionsModel.fromJson(Map<String, dynamic> json) => DropdownOptionsModel(
        dropdownOptions: List<DropdownOption>.from(json["session_timeout_options"].map((x) => DropdownOption.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "session_timeout_options": List<dynamic>.from(dropdownOptions.map((x) => x.toJson())),
    };
}

class DropdownOption {
    String label;
    String value;

    DropdownOption({
        required this.label,
        required this.value,
    });

    factory DropdownOption.fromJson(Map<String, dynamic> json) => DropdownOption(
        label: json["label"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
    };
}