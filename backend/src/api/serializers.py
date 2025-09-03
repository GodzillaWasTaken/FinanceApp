from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Conto, Categoria, Movimento

# -------------------------------------------------------------------
# SHORT SERIALIZERS (per riferimenti annidati)
# permette di ottenre api piu rapide e con payload minore, utile per ottenere le
# informazioni essenziali di un oggetto quando e' referenziato in un altro
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
# EDIT SERIALIZERS (per creare o aggiornare)
# per relazioni e chiavi esterne mandi solo l'id di referenza (o la chiave primaria) non tutto l'oggetto
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
# LIST SERIALIZERS (per API con paginazione)
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
# DETAIL SERIALIZERS (per visualizzazione dettagliata)
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
