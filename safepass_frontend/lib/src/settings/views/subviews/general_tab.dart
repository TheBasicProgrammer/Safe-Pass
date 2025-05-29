import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:safepass_frontend/common/const/app_theme/app_text_styles.dart";
import "package:safepass_frontend/common/const/kconstants.dart";
import "package:safepass_frontend/common/widgets/app_button_widget.dart";
import "package:safepass_frontend/common/widgets/app_circular_progress_indicator_widget.dart";
import "package:safepass_frontend/common/widgets/app_dropdownbuttonformfield_widget.dart";
import "package:safepass_frontend/common/widgets/app_switch_widget.dart";
import "package:safepass_frontend/src/settings/controllers/settings_tab_notifier.dart";
import "package:safepass_frontend/src/settings/models/settings_model.dart";
import "package:safepass_frontend/src/settings/models/temp_settings_model.dart";

class GeneralTab extends StatefulWidget {
  const GeneralTab({super.key});

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab> {
  // Make these nullable to start, and initialize them once data is fetched
  Security? securitySettings;
  Notifications? notificationsSettings;
  Visitors? visitorsSettings;

  // Initializing dropdown models is fine here as they are static data
  DropdownOptionsModel sessionTimeoutOptionsModel = DropdownOptionsModel(
      dropdownOptions: [
        DropdownOption(label: "30 min", value: "30"),
        DropdownOption(label: "60 min", value: "60"),
        DropdownOption(label: "90 min", value: "90"),
        DropdownOption(label: "120 min", value: "120"),
      ]);
  DropdownOptionsModel maximumVisitorsPerDayModel = DropdownOptionsModel(
      dropdownOptions: [
        DropdownOption(label: "50 people", value: "50"),
        DropdownOption(label: "100 people", value: "100"),
        DropdownOption(label: "150 people", value: "150"),
        DropdownOption(label: "200 people", value: "200"),
      ]);
  DropdownOptionsModel maximumVisitDurationModel = DropdownOptionsModel(
      dropdownOptions: [
        DropdownOption(label: "30 min", value: "30"),
        DropdownOption(label: "60 min", value: "60"),
        DropdownOption(label: "90 min", value: "90"),
        DropdownOption(label: "120 min", value: "120"),
      ]);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Listen to the notifier to initialize settings once data is available
      context.read<SettingsTabNotifier>().fetchSettings(context).then((_) {
        // After fetching, initialize the state variables
        final TempSettings? initialSettings = context.read<SettingsTabNotifier>().getSettings.isNotEmpty
            ? context.read<SettingsTabNotifier>().getSettings[0]
            : null;

        if (initialSettings != null) {
          setState(() {
            securitySettings = Security(
              // enableMultiFactorAuth: initialSettings.enableMfa,
              sessionTimeout: sessionTimeoutOptionsModel.dropdownOptions
                  .firstWhere(
                    (e) => e.value == initialSettings.sessionTimeout.toString(),
                    orElse: () => DropdownOption(
                        label: "Custom",
                        value: initialSettings.sessionTimeout.toString()),
                  ),
            );
            notificationsSettings = Notifications(
              // enableVisitorNotifications: initialSettings.enableVisitorNotifs,
              // enableAlerts: initialSettings.enableAlerts,
              enableScheduledReminders: initialSettings.enableScheduledReminders,
            );
            visitorsSettings = Visitors(
              maximumVisitorsPerDay: maximumVisitorsPerDayModel.dropdownOptions
                  .firstWhere(
                    (e) => e.value == initialSettings.maxVisitorsPerDay.toString(),
                    orElse: () => DropdownOption(
                        label: "Custom",
                        value: initialSettings.maxVisitorsPerDay.toString()),
                  ),
              maximumVisitDuration: maximumVisitDurationModel.dropdownOptions
                  .firstWhere(
                    (e) => e.value == initialSettings.maxVisitDuration.toString(),
                    orElse: () => DropdownOption(
                        label: "Custom",
                        value: initialSettings.maxVisitDuration.toString()),
                  ),
            );
          });
        }
      });
    });
  }

  // Updates dropdown value
  void _onDropdownValueChanged({
    required String? selectedOptionValue,
    required List<DropdownOption> dropdownOptions,
    required Function(DropdownOption) saveNewValue,
  }) {
    if (selectedOptionValue == null) return; // Handle null case

    final DropdownOption selectedOption =
        dropdownOptions.firstWhere((element) => element.value == selectedOptionValue);

    setState(() {
      saveNewValue(selectedOption);
    });
  }

  // Updates value of "Custom" dropdown option and the input field
  void _onCustomFieldEditingComplete({
    required DropdownOption chosenOption,
    required List<DropdownOption> dropdownOptions,
    required TextEditingController inputFieldController,
    required Function(DropdownOption) saveNewValue,
  }) {
    final DropdownOption selectedOption = dropdownOptions.firstWhere(
        (element) => element.value == inputFieldController.text, orElse: () {
      chosenOption.value = inputFieldController.text;
      return chosenOption;
    });

    setState(() {
      saveNewValue(selectedOption);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while settings are being fetched or if they are null
    if (context.watch<SettingsTabNotifier>().getIsLoading ||
        securitySettings == null ||
        notificationsSettings == null ||
        visitorsSettings == null) {
      return Center(child: AppCircularProgressIndicatorWidget());
    }

    // No need to call _setSettingsValue() here anymore as the state is managed internally

    final TextEditingController sessionTimeoutController = TextEditingController(
      text: securitySettings!.sessionTimeout.value,
    );
    final TextEditingController maximumVisitorsPerDayController =
        TextEditingController(
      text: visitorsSettings!.maximumVisitorsPerDay.value,
    );
    final TextEditingController maximumVisitDurationController =
        TextEditingController(
      text: visitorsSettings!.maximumVisitDuration.value,
    );

    return Padding(
      padding: AppConstants.kAppPadding,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Security
            GeneralSettingsGroup(
              title: "Security",
              subItems: [
                // SubItemWidget(
                //   title: "Enable Multi-Factor Authentication",
                //   action: AppSwitchWidget(
                //     value: securitySettings!.enableMultiFactorAuth, // Use the state variable
                //     onChanged: (value) {
                //       setState(() {
                //         print("debug: prev value ${securitySettings!.enableMultiFactorAuth}");
                //         securitySettings!.enableMultiFactorAuth = value; // Update the state variable directly
                //         print("debug: new value $value");
                //         print("debug: set value ${securitySettings!.enableMultiFactorAuth}");
                //       });
                //     },
                //   ),
                // ),
                SubItemWidget(
                  title: "Session Timeout\n(in minutes)",
                  action: AppDropdownButtonFormFieldWidget(
                    chosenOption: securitySettings!.sessionTimeout,
                    dropdownOptions: sessionTimeoutOptionsModel.dropdownOptions,
                    inputFieldController: sessionTimeoutController,
                    onChanged: (value) {
                      _onDropdownValueChanged(
                        selectedOptionValue: value,
                        dropdownOptions: sessionTimeoutOptionsModel.dropdownOptions,
                        saveNewValue: (selectedOption) {
                          setState(() { // setState around the update of securitySettings
                            securitySettings!.sessionTimeout = selectedOption;
                          });
                        },
                      );
                    },
                    onEditingComplete: () {
                      _onCustomFieldEditingComplete(
                        chosenOption: securitySettings!.sessionTimeout,
                        dropdownOptions: sessionTimeoutOptionsModel.dropdownOptions,
                        inputFieldController: sessionTimeoutController,
                        saveNewValue: (selectedOption) {
                          setState(() { // setState around the update of securitySettings
                            securitySettings!.sessionTimeout = selectedOption;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Divider(),
            // Notifications
            GeneralSettingsGroup(
              title: "Notifications",
              subItems: [
                // SubItemWidget(
                //   title: "Enable Visitor Notifications",
                //   action: AppSwitchWidget(
                //     value: notificationsSettings!.enableVisitorNotifications,
                //     onChanged: (value) {
                //       setState(() {
                //         notificationsSettings!.enableVisitorNotifications = value;
                //       });
                //     },
                //   ),
                // ),
                // SubItemWidget(
                //   title: "Enable Alerts",
                //   action: AppSwitchWidget(
                //     value: notificationsSettings!.enableAlerts,
                //     onChanged: (value) {
                //       setState(() {
                //         notificationsSettings!.enableAlerts = value;
                //       });
                //     },
                //   ),
                // ),
                SubItemWidget(
                  title: "Enable Scheduled Reminders",
                  action: AppSwitchWidget(
                    value: notificationsSettings!.enableScheduledReminders,
                    onChanged: (value) {
                      setState(() {
                        notificationsSettings!.enableScheduledReminders = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Divider(),
            // Visitors
            GeneralSettingsGroup(
              title: "Visitors",
              subItems: [
                SubItemWidget(
                  title: "Maximum Visitors Per Day",
                  action: AppDropdownButtonFormFieldWidget(
                    chosenOption: visitorsSettings!.maximumVisitorsPerDay,
                    dropdownOptions: maximumVisitorsPerDayModel.dropdownOptions,
                    inputFieldController: maximumVisitorsPerDayController,
                    onChanged: (value) {
                      _onDropdownValueChanged(
                        selectedOptionValue: value,
                        dropdownOptions: maximumVisitorsPerDayModel.dropdownOptions,
                        saveNewValue: (selectedOption) {
                          setState(() {
                            visitorsSettings!.maximumVisitorsPerDay = selectedOption;
                          });
                        },
                      );
                    },
                    onEditingComplete: () {
                      _onCustomFieldEditingComplete(
                        chosenOption: visitorsSettings!.maximumVisitorsPerDay,
                        dropdownOptions: maximumVisitorsPerDayModel.dropdownOptions,
                        inputFieldController: maximumVisitorsPerDayController,
                        saveNewValue: (selectedOption) {
                          setState(() {
                            visitorsSettings!.maximumVisitorsPerDay = selectedOption;
                          });
                        },
                      );
                    },
                  ),
                ),
                SubItemWidget(
                  title: "Maximum Visit Duration\n(in minutes)",
                  action: AppDropdownButtonFormFieldWidget(
                    chosenOption: visitorsSettings!.maximumVisitDuration,
                    dropdownOptions: maximumVisitDurationModel.dropdownOptions,
                    inputFieldController: maximumVisitDurationController,
                    onChanged: (value) {
                      _onDropdownValueChanged(
                        selectedOptionValue: value,
                        dropdownOptions: maximumVisitDurationModel.dropdownOptions,
                        saveNewValue: (selectedOption) {
                          setState(() {
                            visitorsSettings!.maximumVisitDuration = selectedOption;
                          });
                        },
                      );
                    },
                    onEditingComplete: () {
                      _onCustomFieldEditingComplete(
                        chosenOption: visitorsSettings!.maximumVisitDuration,
                        dropdownOptions: maximumVisitDurationModel.dropdownOptions,
                        inputFieldController: maximumVisitDurationController,
                        saveNewValue: (selectedOption) {
                          setState(() {
                            visitorsSettings!.maximumVisitDuration = selectedOption;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            context.watch<SettingsTabNotifier>().getIsLoading
                ? Center(child: AppCircularProgressIndicatorWidget())
                : AppButtonWidget(
                    onTap: () {
                      context.read<SettingsTabNotifier>().updateSettings(
                            context: context,
                            // enableMfa: securitySettings!.enableMultiFactorAuth,
                            sessionTimeout: securitySettings!.sessionTimeout.value,
                            // enableVisitorNotifs:
                                // notificationsSettings!.enableVisitorNotifications,
                            // enableAlerts: notificationsSettings!.enableAlerts,
                            enableScheduledReminders:
                                notificationsSettings!.enableScheduledReminders,
                            maxVisitorsPerDay:
                                visitorsSettings!.maximumVisitorsPerDay.value,
                            maxVisitDuration:
                                visitorsSettings!.maximumVisitDuration.value,
                          );
                    },
                    text: "Save",
                    width: 200,
                  ),
          ],
        ),
      ),
    );
  }
}

// Keep your GeneralSettingsGroup and SubItemWidget as they are, no changes needed.

class GeneralSettingsGroup extends StatelessWidget {
  const GeneralSettingsGroup({
    required this.title,
    required this.subItems,
    super.key
  });

  final String title;
  final List<Widget> subItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.biggerStyleBold
        ),
        Padding(
          padding: EdgeInsets.only(
            left: AppConstants.kAppPadding.left
          ),
          child: SizedBox(
            width: 800,
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                subItems.length, 
                (index) {
                  return subItems[index];
                }
              )
            ),
          )
        )
      ],
    );
  }
}

class SubItemWidget extends StatelessWidget {
  const SubItemWidget({
    required this.title,
    required this.action,
    super.key
  });

  final String title;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.defaultStyle,
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          width: 150,
          child: action
        )
      ],
    );
  }
}