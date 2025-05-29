import 'package:flutter/material.dart';
import 'package:http/browser_client.dart' as http;
import 'package:safepass_frontend/common/utils/refresh_access_token.dart';

import '../models/visitor_logs_model.dart';

import '../../widgets/snackbar_widget.dart';

import 'dart:developer' as developer;
import 'package:safepass_frontend/common/const/kurls.dart';
import 'dart:convert';
// hello just to git add.
class VisitorLogsController with ChangeNotifier {
  bool _isLoading = false;
  int _statusCode = -1;
  List<VisitorLog> _visitorLogs = [];
  String? _error;

  bool get isLoading => _isLoading;
  int get statusCode => _statusCode;
  List<VisitorLog> get visitorLogs => _visitorLogs;
  String? get error => _error;

  List<VisitorLog> getTodayLogs() {
  final today = DateTime.now();
  return _visitorLogs.where((log) {
    final logDate = DateTime.tryParse(log.visitDate);
    return logDate != null &&
        logDate.year == today.year &&
        logDate.month == today.month &&
        logDate.day == today.day;
  }).toList();
}

  Future<void> getVisitorLogs(BuildContext context) async {
    if (_isLoading) return;

    developer.log('Starting to fetch visitor logs');
    _statusCode = -1;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      var client = http.BrowserClient();
      client.withCredentials = true;
      final url = ApiUrls.visitorLogsUrl;
      developer.log('Fetching from URL: $url');

      if (url.contains('ERROR')) {
        throw Exception('Invalid base URL. Check your .env.development file.');
      }

      final response = await client.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          // Skip Authorization header for now
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      developer.log('Response status: ${response.statusCode}');
      developer.log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final jsonData = json.decode(response.body);
          developer.log('Parsed JSON: $jsonData');

          _visitorLogs = visitorLogsFromJson(response.body);
          _statusCode = response.statusCode;
          _error = null;
          developer.log('Successfully loaded ${_visitorLogs.length} logs');
        } catch (e) {
          developer.log('Error parsing response: $e');
          _error = 'Failed to parse server response: $e';
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              appErrorSnackBarWidget(
                context: context,
                text: "Error parsing data: $e",
              ),
            );
          }
        }
      }  else if (response.statusCode == 401) {
        developer.log('Refetching logs');
        if (context.mounted) {
          await refetch(context, fetch: () => getVisitorLogs(context));
        }
      } else {
        _error = 'Server returned ${response.statusCode}';
        developer.log('Error response: ${response.statusCode} - ${response.body}');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            appErrorSnackBarWidget(
              context: context,
              text: "Failed to fetch visitor logs (${response.statusCode})",
            ),
          );
        }
      }
    } catch (e) {
      developer.log('Exception in getVisitorLogs:', error: e);
      _error = e.toString();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          appErrorSnackBarWidget(
            context: context,
            text: "Error: $e",
          ),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
      developer.log('Finished fetch attempt. Success: ${_error == null}');
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => message;
}
