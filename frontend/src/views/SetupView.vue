<script setup>
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import { useAuth } from '../composables/useAuth';
import Title from '../components/Title.vue';
import ShowHideButton from '../components/buttons/ShowHideButton.vue';

const username = ref('');
const email = ref('');
const password = ref('');
const showPassword = ref(false);
const recoveryKey = ref(null);

const { register, authError } = useAuth();
const router = useRouter();

const passwordFieldType = computed(() => showPassword.value ? 'text' : 'password');

const handleSetup = async () => {
  try {
    await register(email.value, username.value, password.value);
    recoveryKey.value = sessionStorage.getItem('tempRecoveryKey');
    // Set application to initialized so the guard lets us through
    sessionStorage.setItem('isInitialized', 'true');
  } catch (e) {
    // Error is handled in useAuth
  }
};

const togglePasswordVisibility = () => {
  showPassword.value = !showPassword.value;
};

const isFormValid = computed(() => {
  return username.value.length > 0 && password.value.length > 0 && email.value.length > 0;
});

</script>

<template>
  <div class="flex flex-col min-h-screen bg-background">
    <div class="flex-grow flex justify-center items-center p-6">
      <div class="w-full max-w-lg">

        <div v-if="recoveryKey" class="bg-card-background rounded-2xl shadow-lg p-8 text-center border-2 border-primary">
            <h2 class="text-3xl font-bold mb-4 text-primary">Setup Completato!</h2>
            <p class="text-text mb-4">Questa è la tua <strong>Recovery Key</strong>. Salvala in un posto sicuro, preferibilmente offline (es. su un foglio di carta o un password manager sicuro).</p>
            
            <div class="bg-neutral p-4 rounded-lg text-xl font-mono text-white mb-6 select-all break-words">
                {{ recoveryKey }}
            </div>

            <p class="text-red-500 font-bold mb-6">
                ATTENZIONE: I tuoi dati sono protetti da crittografia End-To-End. Se perdi sia la password che questa Recovery Key, i tuoi dati saranno persi per sempre!
            </p>

            <router-link to="/cashflow" class="w-full py-3 px-6 bg-primary text-white rounded-lg font-bold inline-block">
                Ho salvato la chiave, vai alla Dashboard
            </router-link>
        </div>

        <div v-else class="bg-card-background rounded-2xl shadow-lg p-8 border border-primary/30">
          <Title title="PiggyPath" class="text-5xl" />
          <p class="text-center text-md text-primary-light font-bold mb-8">Benvenuto nel tuo nuovo sistema finanziario</p>
          
          <div class="bg-primary/10 border border-primary/20 rounded-lg p-4 mb-6 text-sm text-text">
            <strong>Primo Avvio:</strong> L'applicazione non è ancora configurata. Crea il tuo account principale per iniziare. Questo utente avrà automaticamente i privilegi di <strong class="text-primary">Amministratore</strong>.
          </div>

          <h2 class="text-center text-2xl font-bold mb-4 text-text">Crea Amministratore</h2>

          <form @submit.prevent="handleSetup" class="space-y-6">
            <div>
              <label for="username" class="block text-text font-semibold mb-1">Username</label>
              <input
                id="username"
                v-model="username"
                type="text"
                placeholder="Username"
                required
                class="w-full px-4 py-2 rounded-lg border border-neutral bg-primary-clear text-text focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
              />
            </div>

            <div>
              <label for="email" class="block text-text font-semibold mb-1">Email</label>
              <input
                id="email"
                v-model="email"
                type="email"
                placeholder="Email dell'Amministratore"
                required
                class="w-full px-4 py-2 rounded-lg border border-neutral bg-primary-clear text-text focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
              />
            </div>

            <div class="relative">
              <label for="password" class="block text-text font-semibold mb-1">Password</label>
              <input
                :type="passwordFieldType"
                id="password"
                v-model="password"
                placeholder="Password (cifrerà i tuoi dati)"
                required
                class="w-full px-4 py-2 rounded-lg border border-neutral bg-primary-clear text-text focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
              />
              <ShowHideButton 
                class="show-button"
                :showPassword="showPassword"
                @toggle="togglePasswordVisibility"
              />
            </div>

            <button
              type="submit"
              :disabled="!isFormValid"
              :class="isFormValid ? 'bg-primary-light hover:bg-primary text-white cursor-pointer' : 'bg-primary-light text-text cursor-not-allowed'"
              class="w-full py-3 rounded-lg font-bold transition-colors"
            >
              Crea Account e Inizia
            </button>

            <p v-if="authError" class="text-red-600 mt-3 text-center">{{ authError }}</p>
            
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.relative {
  position: relative;
}
.show-button {
  position: absolute;
  right: 45px;
  top: 70%
}
</style>
