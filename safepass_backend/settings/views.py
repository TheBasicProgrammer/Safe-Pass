from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, IsAdminUser
from . import models, serializers
from rest_framework.views import APIView


class AppSettingsView(APIView):
    permission_classes = [IsAuthenticated, IsAdminUser]

    def get(self, request):
        try:
            settings = models.AppSettings.objects.get(id=1)
            serializer = serializers.AppSettingsSerializer(settings)
            return Response({"temp_settings": serializer.data}, status=status.HTTP_200_OK)
        except Exception as e:
            print(F"AppSettingsView: {str(e)}")
            return Response({"detail": "Unexpected error"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class UpdateSettingsView(APIView):
    permission_classes = [IsAuthenticated, IsAdminUser]

    def post(self, request):
        updated_settings = request.data.get('updated_settings')
        # enable_mfa = updated_settings.get('enable_mfa')
        session_timout = updated_settings.get('session_timeout')
        # enable_visitor_notifs = updated_settings.get('enable_visitor_notifs')
        # enable_alerts = updated_settings.get('enable_alerts')
        enable_scheduled_reminders = updated_settings.get('enable_scheduled_reminders')
        max_visitors_per_day = updated_settings.get('max_visitors_per_day')
        max_visit_duration = updated_settings.get('max_visit_duration')

        print(f"debug: ${updated_settings}")
        
        try:
            curr_settings = models.AppSettings.objects.get(id=1)
            # curr_settings.enable_mfa = enable_mfa
            curr_settings.session_timeout = session_timout
            # curr_settings.enable_visitor_notifs = enable_visitor_notifs
            # curr_settings.enable_alerts = enable_alerts
            curr_settings.enable_scheduled_reminders = enable_scheduled_reminders
            curr_settings.max_visitors_per_day = max_visitors_per_day
            curr_settings.max_visit_duration = max_visit_duration
            curr_settings.save()
            
            return Response({"detail": "Settings updated successfully"}, status=status.HTTP_200_OK)
        except Exception as e:
            print(f"UpdateSettingsView: {str(e)}")
            return Response({"detail": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)