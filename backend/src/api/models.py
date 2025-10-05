from django.db import models

class Conto(models.Model):
    #(valore_salvato, etichetta), valore salvato nel db, etichetta visualizzata
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
    titolo = models.CharField(max_length=200)
    conto = models.ForeignKey(Conto, on_delete=models.SET_NULL, null=True, related_name="movimenti")
    data = models.DateField()
    importo = models.DecimalField(max_digits=12, decimal_places=2)
    tipo = models.CharField(max_length=10, choices=TIPO_CHOICES)
    descrizione = models.TextField(blank=True, null=True)

    class Meta:
        ordering = ["-data"]

    def save(self, *args, **kwargs):
        if self.categoria:
            # assegna automaticamente il tipo dal tipo della categoria
            self.tipo = self.categoria.tipo
        super().save(*args, **kwargs)

    def __str__(self):
        conto_nome = self.conto.nome if self.conto else "Nessun conto"
        return f"{self.tipo.capitalize()} - {self.importo}€ ({conto_nome}) il {self.data}"
