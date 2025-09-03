from django.urls import include, path
from . import views
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register('conti', views.ContoViewSet, basename='conto')
router.register('categorie', views.CategoriaViewSet, basename='categoria')
router.register('movimenti', views.MovimentoViewSet, basename='movimento')

urlpatterns = [
    path('auth/', include('djoser.urls')),
    path('auth/', include('djoser.urls.jwt')),
    path('', include(router.urls)),
]
