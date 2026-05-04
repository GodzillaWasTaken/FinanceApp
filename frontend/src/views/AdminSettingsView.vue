<script setup>
import { ref, onMounted } from 'vue';
import { getGlobalSettings, updateRegistrationGlobalSettings } from '../apicalls/apiCalls';

const allowRegistration = ref(true);
const loading = ref(true);
const saving = ref(false);
const errorMsg = ref(null);
const successMsg = ref(null);

onMounted(async () => {
    try {
        const settings = await getGlobalSettings();
        allowRegistration.value = settings.allow_registration;
    } catch (e) {
        errorMsg.value = "Impossibile caricare le impostazioni (sei amministratore?)";
        console.error(e);
    } finally {
        loading.value = false;
    }
});

const saveSettings = async () => {
    saving.value = true;
    errorMsg.value = null;
    successMsg.value = null;
    try {
        const settings = await updateRegistrationGlobalSettings(allowRegistration.value);
        allowRegistration.value = settings.allow_registration;
        successMsg.value = "Impostazioni salvate con successo.";
    } catch (e) {
        errorMsg.value = "Errore durante il salvataggio.";
        console.error(e);
    } finally {
        saving.value = false;
    }
};

</script>

<template>
  <div class="flex flex-col min-h-screen bg-background">
    <div class="flex-grow p-6">
      <div class="max-w-2xl mx-auto">
        <div class="bg-card-background rounded-2xl shadow-lg p-8">
            <h1 class="text-3xl font-bold mb-8 text-text border-b pb-6 border-menuborder">Impostazioni Amministratore</h1>
            
            <div v-if="loading" class="text-text">Caricamento...</div>
            
            <div v-else-if="errorMsg && !saving" class="text-red-500 font-bold mb-4">{{ errorMsg }}</div>
            
            <div v-else class="space-y-6">
                <div class="flex items-center justify-between p-5 bg-background border border-menuborder rounded-xl">
                    <div>
                        <h3 class="text-xl font-semibold text-text">Registrazioni Pubbliche</h3>
                        <p class="text-sm text-gray-400">Permetti a nuovi utenti di creare un account.</p>
                    </div>
                    <label class="relative inline-flex items-center cursor-pointer">
                        <input type="checkbox" v-model="allowRegistration" class="sr-only peer" :disabled="saving">
                        <div class="w-14 h-7 bg-gray-400 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-6 after:w-6 after:transition-all peer-checked:bg-primary"></div>
                    </label>
                </div>

                <div class="pt-8 flex justify-end gap-4 border-t border-menuborder">
                    <router-link to="/settings" class="inline-block">
                        <button
                            class="px-6 py-2.5 bg-white border border-menuborder text-text-light font-bold rounded-xl hover:bg-background hover:text-text transition-all duration-200"
                        >
                            Ritorna alle impostazioni
                        </button>
                    </router-link>
                    <button 
                        @click="saveSettings" 
                        :disabled="saving"
                        class="px-6 py-2.5 bg-primary text-white font-bold rounded-xl hover:bg-primary-hover shadow-lg shadow-primary/20 transition-all duration-200 disabled:opacity-50 disabled:shadow-none"
                    >
                        {{ saving ? 'Salvataggio...' : 'Salva Impostazioni' }}
                    </button>
                </div>

                <div v-if="successMsg" class="p-4 bg-green-900/50 text-green-400 border border-green-500 rounded-lg">
                    {{ successMsg }}
                </div>
            </div>
        </div>
      </div>
    </div>
  </div>
</template>
