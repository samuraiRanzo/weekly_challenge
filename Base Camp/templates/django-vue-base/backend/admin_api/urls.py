from django.urls import path
from .views import (
    AdminLoginView,
    AdminMeView,
)

urlpatterns = [
    path('auth/login/', AdminLoginView.as_view(), name='admin-auth-login'),
    path('auth/me/', AdminMeView.as_view(), name='admin-auth-me'),
]
