from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Conto, Categoria, Movimento

# -------------------------------------------------------------------
# SHORT SERIALIZERS (for nested references)
# allows for faster APIs and smaller payloads, useful for obtaining the
# essential information of an object when it's referenced in another
# -------------------------------------------------------------------
class ContoShortSerializer(serializers.ModelSerializer):
    class Meta:
        model = Conto
        fields = "__all__"

class CategoriaShortSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categoria
        fields = "__all__"

class MovimentoShortSerializer(serializers.ModelSerializer):
    categoria = CategoriaShortSerializer(read_only=True)
    conto = ContoShortSerializer(read_only=True)

    class Meta:
        model = Movimento
        fields = "__all__"

# -------------------------------------------------------------------
# EDIT SERIALIZERS (for creating or updating)
# for relations and foreign keys, send only the reference ID (or primary key), not the entire object
# -------------------------------------------------------------------
class ContoEditSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())

    class Meta:
        model = Conto
        fields = "__all__"

class CategoriaEditSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())

    class Meta:
        model = Categoria
        fields = "__all__"

class MovimentoEditSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    categoria = serializers.PrimaryKeyRelatedField(queryset=Categoria.objects.all())
    conto = serializers.PrimaryKeyRelatedField(queryset=Conto.objects.all(), required=False)

    class Meta:
        model = Movimento
        fields = "__all__"

# -------------------------------------------------------------------
# LIST SERIALIZERS (for APIs with pagination)
# -------------------------------------------------------------------
class ContoListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Conto
        fields = "__all__"

class CategoriaListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categoria
        fields = "__all__"

class MovimentoListSerializer(serializers.ModelSerializer):
    categoria = CategoriaShortSerializer(read_only=True)
    conto = ContoShortSerializer(read_only=True)

    class Meta:
        model = Movimento
        fields = "__all__"

# -------------------------------------------------------------------
# DETAIL SERIALIZERS (for detailed view)
# -------------------------------------------------------------------
class ContoDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Conto
        fields = "__all__"

class CategoriaDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categoria
        fields = "__all__"

class MovimentoDetailSerializer(serializers.ModelSerializer):
    categoria = CategoriaShortSerializer(read_only=True)
    conto = ContoShortSerializer(read_only=True)

    class Meta:
        model = Movimento
        fields = "__all__"

class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        from .models import UserProfile
        model = UserProfile
        fields = ["encrypted_master_key", "recovery_encrypted_master_key"]

class UserMeSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'is_staff', 'is_superuser']
