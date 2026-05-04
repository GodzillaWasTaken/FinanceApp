from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from .models import Conto, Categoria, Movimento, UserProfile
from .serializers import (
    ContoListSerializer, ContoDetailSerializer, ContoEditSerializer,
    CategoriaListSerializer, CategoriaDetailSerializer, CategoriaEditSerializer,
    MovimentoListSerializer, MovimentoDetailSerializer, MovimentoEditSerializer,
    UserProfileSerializer
)
from .pagination import DefaultPagination
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.models import User
from django.db import transaction
from rest_framework.permissions import AllowAny, IsAdminUser



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


class UserProfileView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        profile = getattr(request.user, 'profile', None)
        if not profile:
            profile = UserProfile.objects.create(user=request.user)
        serializer = UserProfileSerializer(profile)
        return Response(serializer.data)

    def patch(self, request):
        profile = getattr(request.user, 'profile', None)
        if not profile:
            profile = UserProfile.objects.create(user=request.user)
        serializer = UserProfileSerializer(profile, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class CustomRegistrationView(APIView):
    permission_classes = [] # Public

    def post(self, request):
        from .models import GlobalSettings
        is_first_user = not User.objects.exists()
        settings = GlobalSettings.load()
        
        if not is_first_user and not settings.allow_registration:
            return Response({"error": "Le registrazioni sono chiuse."}, status=status.HTTP_403_FORBIDDEN)
        
        username = request.data.get("username")
        password = request.data.get("password")
        email = request.data.get("email", "")
        encrypted_master_key = request.data.get("encrypted_master_key")
        recovery_encrypted_master_key = request.data.get("recovery_encrypted_master_key")

        if not username or not password or not encrypted_master_key or not recovery_encrypted_master_key:
            return Response({"error": "Campi mancanti."}, status=status.HTTP_400_BAD_REQUEST)

        if User.objects.filter(username=username).exists():
            return Response({"error": "Username già in uso."}, status=status.HTTP_400_BAD_REQUEST)

        # Creazione atomica utente e salvataggio chiavi

        with transaction.atomic():
            user = User.objects.create_user(username=username, email=email, password=password)
            if is_first_user:
                user.is_staff = True
                user.is_superuser = True
                user.save()
                
            # Il profilo viene creato dal signal
            profile = user.profile
            profile.encrypted_master_key = encrypted_master_key
            profile.recovery_encrypted_master_key = recovery_encrypted_master_key
            profile.save()

        return Response({"message": "Utente creato con successo.", "is_admin": is_first_user}, status=status.HTTP_201_CREATED)


class GlobalSettingsView(APIView):
    # GET è pubblico per sapere se poter mostrare il bottone
    # PATCH è solo per gli admin
    
    def get_permissions(self):
        if self.request.method == 'GET':
            return [AllowAny()]
        return [IsAdminUser()]

    def get(self, request):
        from .models import GlobalSettings
        settings = GlobalSettings.load()
        is_initialized = User.objects.exists()
        return Response({
            "allow_registration": settings.allow_registration,
            "is_initialized": is_initialized
        })

    def patch(self, request):
        from .models import GlobalSettings
        settings = GlobalSettings.load()
        allow_registration = request.data.get("allow_registration")
        if allow_registration is not None:
            settings.allow_registration = bool(allow_registration)
            settings.save()
        return Response({"allow_registration": settings.allow_registration})

