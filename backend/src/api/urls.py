from django.urls import include, path
from . import views
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register('conti', views.ContoViewSet)
router.register('categorie', views.CategoriaViewSet)
router.register('movimenti', views.MovimentoViewSet)

urlpatterns = [
    path('auth/register/', views.CustomRegistrationView.as_view(), name='custom-register'),
    path('auth/', include('djoser.urls')),
    path('auth/', include('djoser.urls.jwt')),
    path('auth/profile/', views.UserProfileView.as_view(), name='user-profile'),
    path('settings/', views.GlobalSettingsView.as_view(), name='global-settings'),
    path('stats/monthly/', views.MonthlyStatsView.as_view(), name='monthly-stats'),
    path('meta/choices/', views.MetaChoicesView.as_view(), name='meta-choices'),
    path('', include(router.urls)),
]
