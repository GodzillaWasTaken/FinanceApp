<script setup>
import { ref, onMounted } from 'vue';
import Footer from '../components/Footer.vue';
import { 
  getMovimenti, createMovimento, 
  getAllCategorie, createCategoria, 
  getAllConti, createConto 
} from '../apicalls/apiCalls.js';
import { useAuth } from '../composables/useAuth.js';

const movimenti = ref([]);
const conti = ref([]);
const categorie = ref([]);
const loading = ref(false);
const message = ref('Benvenuto nella tua dashboard finanziaria!');
const { logout } = useAuth();
// Form nuovo movimento
const nuovoMovimento = ref({
  tipo: 'spesa',       // 'spesa' o 'entrata'
  importo: 0,
  categoria: '',
  conto: '',
  descrizione: ''
});

// Form nuovo conto/categoria inline
const nuovoConto = ref({ nome: '', tipo: 'contanti', valuta: 'EUR', saldo_iniziale: 0 });
const nuovaCategoria = ref({ nome: '', tipo: 'spesa' });

async function fetchMovimenti() {
  loading.value = true;
  try {
    const data = await getMovimenti();
    movimenti.value = data.results || data;
  } finally {
    loading.value = false;
  }
}

async function fetchCategorie() {
  const data = await getAllCategorie();
  categorie.value = data.results || data;
}

async function fetchConti() {
  const data = await getAllConti();
  conti.value = data.results || data;
}

// Aggiungi nuovo movimento
async function aggiungiMovimento() {
  if (!nuovoMovimento.value.importo || !nuovoMovimento.value.categoria || !nuovoMovimento.value.conto) {
    alert('Compila tutti i campi obbligatori!');
    return;
  }
  try {
    const created = await createMovimento(nuovoMovimento.value);
    movimenti.value.unshift(created);
    nuovoMovimento.value = { tipo: 'spesa', importo: 0, categoria: '', conto: '', descrizione: '' };
  } catch (err) {
    console.error(err);
    alert('Errore nella creazione del movimento');
  }
}

// Aggiungi nuovo conto inline
async function aggiungiConto() {
  if (!nuovoConto.value.nome) return alert('Inserisci il nome del conto');
  try {
    const created = await createConto(nuovoConto.value);
    conti.value.push(created);
    nuovoMovimento.value.conto = created.nome;
    nuovoConto.value = { nome: '', tipo: 'contanti', valuta: 'EUR', saldo_iniziale: 0 };
  } catch (err) {
    console.error(err);
    alert('Errore nella creazione del conto');
  }
}

// Aggiungi nuova categoria inline
async function aggiungiCategoria() {
  if (!nuovaCategoria.value.nome) return alert('Inserisci il nome della categoria');
  try {
    const created = await createCategoria(nuovaCategoria.value);
    categorie.value.push(created);
    nuovoMovimento.value.categoria = created.nome;
    nuovaCategoria.value = { nome: '', tipo: 'spesa' };
  } catch (err) {
    console.error(err);
    alert('Errore nella creazione della categoria');
  }
}

onMounted(() => {
  fetchMovimenti();
  fetchCategorie();
  fetchConti();
});
</script>

<template>
  <div class="min-h-screen flex flex-col bg-gray-50">
    <main class="flex-1 container mx-auto p-6">
      <h1 class="text-2xl font-bold mb-6">{{ message }}</h1>

      <!-- Form aggiunta movimento -->
      <div class="bg-white shadow-md rounded p-4 mb-8">
        <h2 class="text-xl font-semibold mb-4">Aggiungi nuovo movimento</h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
          <select v-model="nuovoMovimento.tipo" class="border rounded px-2 py-1">
            <option value="entrata">Entrata</option>
            <option value="spesa">Spesa</option>
          </select>
          <input type="number" v-model="nuovoMovimento.importo" placeholder="Importo" class="border rounded px-2 py-1" />
          
          <!-- Categoria dropdown -->
          <div>
            <select v-if="categorie.length" v-model="nuovoMovimento.categoria" class="border rounded px-2 py-1 w-full">
              <option value="" disabled>Seleziona categoria</option>
              <option v-for="c in categorie" :key="c.nome" :value="c.nome">{{ c.nome }}</option>
            </select>
            <div v-else class="flex gap-2">
              <input type="text" v-model="nuovaCategoria.nome" placeholder="Nuova categoria" class="border rounded px-2 py-1 flex-1"/>
              <button @click="aggiungiCategoria" class="bg-green-600 text-white px-2 py-1 rounded hover:bg-green-700">+</button>
            </div>
          </div>

          <!-- Conto dropdown -->
          <div>
            <select v-if="conti.length" v-model="nuovoMovimento.conto" class="border rounded px-2 py-1 w-full">
              <option value="" disabled>Seleziona conto</option>
              <option v-for="c in conti" :key="c.nome" :value="c.nome">{{ c.nome }}</option>
            </select>
            <div v-else class="flex gap-2">
              <input type="text" v-model="nuovoConto.nome" placeholder="Nuovo conto" class="border rounded px-2 py-1 flex-1"/>
              <button @click="aggiungiConto" class="bg-green-600 text-white px-2 py-1 rounded hover:bg-green-700">+</button>
            </div>
          </div>

          <input type="text" v-model="nuovoMovimento.descrizione" placeholder="Descrizione (opzionale)" class="border rounded px-2 py-1 col-span-2" />
          <button @click="aggiungiMovimento" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">Aggiungi</button>
        </div>
      </div>

      <!-- Tabelle movimenti -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <!-- Entrate -->
        <div class="bg-white shadow-md rounded p-4">
          <h2 class="text-xl font-semibold mb-4">Entrate</h2>
          <table class="w-full text-left border-collapse">
            <thead>
              <tr class="border-b">
                <th class="p-2">Importo</th>
                <th class="p-2">Categoria</th>
                <th class="p-2">Conto</th>
                <th class="p-2">Descrizione</th>
                <th class="p-2">Data</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="m in movimenti.filter(m => m.tipo === 'entrata')" :key="m.id" class="border-b">
                <td class="p-2 text-green-600 font-semibold">{{ m.importo }} €</td>
                <td class="p-2">{{ m.categoria?.nome || m.categoria }}</td>
                <td class="p-2">{{ m.conto?.nome || m.conto }}</td>
                <td class="p-2">{{ m.descrizione }}</td>
                <td class="p-2">{{ m.data }}</td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Spese -->
        <div class="bg-white shadow-md rounded p-4">
          <h2 class="text-xl font-semibold mb-4">Spese</h2>
          <table class="w-full text-left border-collapse">
            <thead>
              <tr class="border-b">
                <th class="p-2">Importo</th>
                <th class="p-2">Categoria</th>
                <th class="p-2">Conto</th>
                <th class="p-2">Descrizione</th>
                <th class="p-2">Data</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="m in movimenti.filter(m => m.tipo === 'spesa')" :key="m.id" class="border-b">
                <td class="p-2 text-red-600 font-semibold">{{ m.importo }} €</td>
                <td class="p-2">{{ m.categoria?.nome || m.categoria }}</td>
                <td class="p-2">{{ m.conto?.nome || m.conto }}</td>
                <td class="p-2">{{ m.descrizione }}</td>
                <td class="p-2">{{ m.data }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <button @click="logout">Logout</button>
    </main>



    <Footer />
  </div>
</template>
