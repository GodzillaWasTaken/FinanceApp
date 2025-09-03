from django.urls import include, path
from . import views
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register('conti', views.ContoViewSet)
router.register('categorie', views.CategoriaViewSet)
router.register('movimenti', views.MovimentoViewSet)

urlpatterns = [
    path('auth/', include('djoser.urls')),
    path('auth/', include('djoser.urls.jwt')),
    path('', include(router.urls)),
]
