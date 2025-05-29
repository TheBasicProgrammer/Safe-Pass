from rest_framework_simplejwt.tokens import RefreshToken
from django.middleware import csrf
from rest_framework.views import APIView
from rest_framework.response import Response
from django.contrib.auth import authenticate
from django.conf import settings
from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework_simplejwt.views import TokenRefreshView
from . import serializers
from rest_framework.serializers import ValidationError
from settings import models as settings_models
from datetime import timedelta


def get_tokens_for_user(user, exp):
    refresh = RefreshToken.for_user(user)
    refresh.set_exp(lifetime=exp)
    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }

class CustomLoginView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        refresh_exp = timedelta(minutes=settings_models.AppSettings.objects.get(id=1).session_timeout)
        # User credentials from request
        data = request.data.get("credentials")
        response = Response()
        email = data.get('email')
        password = data.get('password')

        user = authenticate(email=email, password=password)
        if user is not None:
            if user.is_active:
                data = get_tokens_for_user(user, refresh_exp)
                # TODO: store tokens in db
                response.set_cookie(
                    key=settings.SIMPLE_JWT['ACCESS_TOKEN'],
                    value=data['access'],
                    expires=settings.SIMPLE_JWT['ACCESS_TOKEN_LIFETIME'],
                    secure=settings.SIMPLE_JWT['AUTH_COOKIE_SECURE'],
                    httponly=settings.SIMPLE_JWT['AUTH_COOKIE_HTTP_ONLY'],
                    samesite=settings.SIMPLE_JWT['AUTH_COOKIE_SAMESITE']
                )
                response.set_cookie(
                    key=settings.SIMPLE_JWT['REFRESH_TOKEN'],
                    value=data['refresh'],
                    expires=refresh_exp,
                    secure=settings.SIMPLE_JWT['AUTH_COOKIE_SECURE'],
                    httponly=settings.SIMPLE_JWT['AUTH_COOKIE_HTTP_ONLY'],
                    samesite=settings.SIMPLE_JWT['AUTH_COOKIE_SAMESITE']
                )
                csrf.get_token(request)
                response.data = {"detail": "Login Successful"}
                response.status_code = status.HTTP_200_OK
                return response
            else:
                return Response({"detail": "Unauthorized"}, status=status.HTTP_401_UNAUTHORIZED)
        else:
            return Response({"detail": "Incorrect email or password"}, status=status.HTTP_404_NOT_FOUND)
        

class CookieTokenRefreshView(TokenRefreshView):
    serializer_class = serializers.CookieTokenRefreshSerializer

    def post(self, request, *args, **kwargs):
        try:
            response = super().post(request, *args, **kwargs)
            if 'access' in response.data:
                response.set_cookie(
                    key=settings.SIMPLE_JWT['ACCESS_TOKEN'],
                    value=response.data['access'],
                    expires=settings.SIMPLE_JWT['ACCESS_TOKEN_LIFETIME'],
                    secure=settings.SIMPLE_JWT['AUTH_COOKIE_SECURE'],
                    httponly=settings.SIMPLE_JWT['AUTH_COOKIE_HTTP_ONLY'],
                    samesite=settings.SIMPLE_JWT['AUTH_COOKIE_SAMESITE']
                )
            del response.data['access']

            return response
        except ValidationError:
            return Response({"detail": "Session Expired"}, status=status.HTTP_401_UNAUTHORIZED)
        except Exception as e:
            print(f"in CookieTokenRefreshView: {e}")
            return Response({"detail": "Error. Please try again later."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)