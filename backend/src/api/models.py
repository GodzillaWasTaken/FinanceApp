from django.db import models
from django.contrib.auth.models import User
from django.db.models.signals import post_save
from django.dispatch import receiver

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="profile")
    encrypted_master_key = models.TextField(blank=True, null=True, help_text="Master Key encrypted with the user's password KEK")
    recovery_encrypted_master_key = models.TextField(blank=True, null=True, help_text="Master Key encrypted with the Recovery Key KEK")

    def __str__(self):
        return f"Profile of {self.user.username}"

@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        UserProfile.objects.create(user=instance)

@receiver(post_save, sender=User)
def save_user_profile(sender, instance, **kwargs):
    instance.profile.save()

class Conto(models.Model):
    # (saved_value, label), value saved in the db, displayed label
    TIPO_CHOICES = [
        ("conto_corrente", "Conto Corrente"),
        ("revolut", "Revolut"),
        ("contanti", "Contanti"),
    ]

    user = models.ForeignKey('auth.User', on_delete=models.CASCADE, related_name="conti")
    nome = models.CharField(max_length=100, primary_key=True)
    tipo = models.CharField(max_length=20, choices=TIPO_CHOICES, default="contanti")
    valuta = models.CharField(max_length=10, default="EUR")
    saldo_iniziale = models.DecimalField(max_digits=12, decimal_places=2, default=0)

    class Meta:
        unique_together = ("user", "nome")
        verbose_name_plural = "Conti"

    def __str__(self):
        return f"{self.nome} ({self.tipo})"


class Categoria(models.Model):
    TIPO_CHOICES = [
        ("entrata", "Entrata"),
        ("uscita", "Spesa"),
        ("giroconto", "Giroconto"),
    ]

    user = models.ForeignKey('auth.User', on_delete=models.CASCADE, related_name="categorie")
    nome = models.CharField(max_length=100, primary_key=True)
    tipo = models.CharField(max_length=10, choices=TIPO_CHOICES)

    class Meta:
        unique_together = ("user", "nome", "tipo")
        verbose_name_plural = "Categorie"

    def __str__(self):
        return f"{self.nome} ({self.tipo})"


class Movimento(models.Model):
    TIPO_CHOICES = [
        ("entrata", "Entrata"),
        ("uscita", "Spesa"),
        ("giroconto", "Giroconto"),
    ]

    id = models.AutoField(primary_key=True)
    user = models.ForeignKey('auth.User', on_delete=models.CASCADE, related_name="movimenti")
    categoria = models.ForeignKey(Categoria, on_delete=models.SET_NULL, null=True, related_name="movimenti")
    titolo = models.TextField()
    conto = models.ForeignKey(Conto, on_delete=models.SET_NULL, null=True, related_name="movimenti")
    data = models.DateField()
    importo = models.DecimalField(max_digits=12, decimal_places=2)
    tipo = models.CharField(max_length=10, choices=TIPO_CHOICES)
    descrizione = models.TextField(blank=True, null=True)

    class Meta:
        ordering = ["-data"]

    def save(self, *args, **kwargs):
        if self.categoria:
            # automatically assigns the type from the category type
            self.tipo = self.categoria.tipo
        super().save(*args, **kwargs)

    def __str__(self):
        conto_nome = self.conto.nome if self.conto else "Nessun conto"
        return f"{self.tipo.capitalize()} - {self.importo}€ ({conto_nome}) il {self.data}"


class GlobalSettings(models.Model):
    allow_registration = models.BooleanField(default=True, help_text="Permetti nuove registrazioni")

    class Meta:
        verbose_name = "Global Settings"
        verbose_name_plural = "Global Settings"

    def __str__(self):
        return "Impostazioni Globali"

    def save(self, *args, **kwargs):
        # Singleton pattern: there must always and only be one row (ID 1)
        self.pk = 1
        super().save(*args, **kwargs)

    @classmethod
    def load(cls):
        obj, created = cls.objects.get_or_create(pk=1)
        return obj
