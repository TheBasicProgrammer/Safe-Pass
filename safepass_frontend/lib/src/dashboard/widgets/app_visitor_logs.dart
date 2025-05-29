import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safepass_frontend/src/logs/controllers/visitorlogs_controller.dart';
import 'package:safepass_frontend/common/const/app_theme/app_text_styles.dart';
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kconstants.dart';
import 'package:safepass_frontend/src/logs/models/visitor_logs_model.dart';
// hello just to git add.
class VisitorLogsWidget extends StatefulWidget {
  const VisitorLogsWidget({super.key});

  @override
  State<VisitorLogsWidget> createState() => _VisitorLogsWidgetState();
}

class _VisitorLogsWidgetState extends State<VisitorLogsWidget> {
  static const int logsPerPage = 5;
  int currentPage = 0;

  List<VisitorLog> _getTodayLogs(List<VisitorLog> logs) {
    final today = DateTime.now();
    return logs.where((log) {
      final logDate = DateTime.tryParse(log.visitDate);
      return logDate != null &&
          logDate.year == today.year &&
          logDate.month == today.month &&
          logDate.day == today.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VisitorLogsController>(
      builder: (context, controller, _) {
        final todayLogs = _getTodayLogs(controller.visitorLogs);
        final totalPages = (todayLogs.length / logsPerPage).ceil();
        final start = currentPage * logsPerPage;
        final end = (start + logsPerPage).clamp(0, todayLogs.length);
        final paginatedLogs = todayLogs.sublist(start, end);

        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: AppConstants.kAppBorderRadius,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 238, 232, 232),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Today's Visitation Logs",
                      style: AppTextStyles.bigStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Image.asset(
                      'assets/images/visitor_logs_icon.png',
                      height: 24,
                      width: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _HeaderText('Name'),
                    _HeaderText('Check-in Time'),
                    _HeaderText('Check-out Time'),
                    _HeaderText('Visit Purpose'),
                    _HeaderText('Status'),
                  ],
                ),
                const Divider(thickness: 1.5),
                if (paginatedLogs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text("No visitor logs for today.")),
                  )
                else
                  ...paginatedLogs.map(
                    (log) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _DataText(log.visitorName),
                          _DataText(log.checkInTime),
                          _DataText(log.checkOutTime ?? "-"),
                          _DataText(log.purpose),
                          _DataText(log.status),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                if (totalPages > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${currentPage + 1}/$totalPages',
                        style: AppTextStyles.defaultStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: currentPage > 0
                                ? () => setState(() => currentPage--)
                                : null,
                            color: AppColors.kDarkBlue,
                            iconSize: 28,
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: currentPage < totalPages - 1
                                ? () => setState(() => currentPage++)
                                : null,
                            color: AppColors.kDarkBlue,
                            iconSize: 28,
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        style: AppTextStyles.defaultStyle.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _DataText extends StatelessWidget {
  final String text;
  const _DataText(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        style: AppTextStyles.defaultStyle.copyWith(color: Colors.black54),
      ),
    );
  }
}
