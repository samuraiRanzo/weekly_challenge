from django.urls import path
from .views import (
    AdminLoginView,
    AdminMeView,
    AdminBlogListCreateView,
    AdminBlogDetailView,
)

urlpatterns = [
    path('auth/login/', AdminLoginView.as_view(), name='admin-auth-login'),
    path('auth/me/', AdminMeView.as_view(), name='admin-auth-me'),
]
