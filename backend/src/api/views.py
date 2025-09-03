from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from .models import Conto, Categoria, Movimento
from .serializers import (
    ContoListSerializer, ContoDetailSerializer, ContoEditSerializer,
    CategoriaListSerializer, CategoriaDetailSerializer, CategoriaEditSerializer,
    MovimentoListSerializer, MovimentoDetailSerializer, MovimentoEditSerializer,
)
from .pagination import DefaultPagination


# ----------------- MIXIN PER CAMBIO SERIALIZER -----------------

class DynamicSerializerMixin:
    short_serializer_class = None
    detail_serializer_class = None
    edit_serializer_class = None

    def get_serializer_class(self):
        # Detail view -> detail serializer
        if getattr(self, 'action', None) == 'retrieve':
            return self.detail_serializer_class or self.serializer_class

        # Create/Update -> edit serializer
        if getattr(self, 'action', None) in ('create', 'update', 'partial_update'):
            return self.edit_serializer_class or self.serializer_class

        # List (con paginazione) -> list serializer
        return self.serializer_class


# ----------------- BASE VIEWSET -----------------

class BaseModelViewSet(DynamicSerializerMixin, viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    pagination_class = DefaultPagination

    def get_queryset(self):
        # restituisce solo i dati dell’utente loggato
        return super().get_queryset().filter(user=self.request.user)

    def perform_create(self, serializer):
        # forza user = utente loggato
        serializer.save(user=self.request.user)

# ----------------- VIEWSET PER OGNI MODELLO -----------------
class ContoViewSet(BaseModelViewSet):
    queryset = Conto.objects.all().order_by("nome")
    serializer_class = ContoListSerializer
    detail_serializer_class = ContoDetailSerializer
    edit_serializer_class = ContoEditSerializer


class CategoriaViewSet(BaseModelViewSet):
    queryset = Categoria.objects.all().order_by("nome")
    serializer_class = CategoriaListSerializer
    detail_serializer_class = CategoriaDetailSerializer
    edit_serializer_class = CategoriaEditSerializer


class MovimentoViewSet(BaseModelViewSet):
    queryset = Movimento.objects.select_related("categoria", "conto").order_by("-data")
    serializer_class = MovimentoListSerializer
    detail_serializer_class = MovimentoDetailSerializer
    edit_serializer_class = MovimentoEditSerializer
