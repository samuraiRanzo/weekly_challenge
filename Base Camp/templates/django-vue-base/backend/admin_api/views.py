from rest_framework import generics
from rest_framework.permissions import AllowAny, IsAdminUser
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.pagination import PageNumberPagination
from rest_framework_simplejwt.views import TokenObtainPairView

from .serializers import (
    AdminEmailTokenObtainPairSerializer,
)


class AdminLoginView(TokenObtainPairView):
    permission_classes = [AllowAny]
    serializer_class = AdminEmailTokenObtainPairSerializer


class AdminMeView(APIView):
    permission_classes = [IsAdminUser]

    def get(self, request):
        u = request.user
        return Response({
            'id': u.id,
            'username': u.username,
            'email': u.email,
            'first_name': u.first_name,
            'last_name': u.last_name,
            'is_staff': u.is_staff,
            'is_superuser': u.is_superuser,
        })


class AdminPagination(PageNumberPagination):
    page_size = 20
    page_size_query_param = 'page_size'
    max_page_size = 100
