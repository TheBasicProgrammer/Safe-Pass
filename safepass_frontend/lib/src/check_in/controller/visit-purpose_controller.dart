import 'package:flutter/material.dart';
import 'package:http/browser_client.dart' as http;
import 'package:safepass_frontend/common/const/kcolors.dart';
import 'package:safepass_frontend/common/const/kurls.dart';
import 'package:safepass_frontend/common/utils/common_json_model.dart';
import 'package:safepass_frontend/common/utils/refresh_access_token.dart';
import 'package:safepass_frontend/src/check_in/models/visit_purposes_model.dart';

class VisitPurposesController with ChangeNotifier {
  bool _isLoading = false;
  get getIsLoading => _isLoading;
  
  List<Purpose> _visitPurposes = [];
  List<Purpose> get getVisitPurposes => _visitPurposes;
  
  Future<void> fetchVisitPurposes(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      var client = http.BrowserClient();
      client.withCredentials = true;
      var url = Uri.parse(ApiUrls.visitPurposesUrl);
      var response = await client.get(url);

      if (response.statusCode == 200) {
        VisitPurposesModel model = visitPurposesModelFromJson(response.body);
        _visitPurposes = model.purposes;
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          await refetch(context, fetch: () => fetchVisitPurposes(context));
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
      print("VisitPurposesController:");
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}