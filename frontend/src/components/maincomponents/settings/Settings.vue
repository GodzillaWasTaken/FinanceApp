<script setup>
import { ref, onMounted } from 'vue';
import { Switch } from '@headlessui/vue';
import { getCurrentUser } from '../../../apicalls/apiCalls';
import { useAuth } from '../../../composables/useAuth';
import { ArrowRightStartOnRectangleIcon } from '@heroicons/vue/24/outline';

defineProps({
    defaultMenuOpen: {
        type: Boolean,
        required: true
    }
});

const emit = defineEmits(['update:defaultMenuOpen']); 

const { logout } = useAuth();

const isAdmin = ref(false);
const loadingAdminSettings = ref(true);

onMounted(async () => {
    try {
        const user = await getCurrentUser();
        isAdmin.value = user.is_staff || user.is_superuser;
    } catch (e) {
        console.error("Failed to load user settings", e);
    } finally {
        loadingAdminSettings.value = false;
    }
});

function toggleMenu(newValue) {
    emit('update:defaultMenuOpen', newValue);
}
</script>

<template>
        <section class="flex-1 h-full pt-10 pb-6">
            <div class = "flex flex-col bg-white rounded-[10px] shadow-lg ">
                <div>
                    <div class="text-text m-6 text-xl font-bold">Menu</div>
                    <div class="flex text-text m-6 gap-6 items-center">
                        <div>Menu fisso (su desktop)</div>
                         <Switch
                            :modelValue="defaultMenuOpen"
                            @update:modelValue="toggleMenu"
                            :class="[
                                defaultMenuOpen ? 'bg-primary-light' : 'bg-gray-300',
                                'relative inline-flex h-6 w-11 items-center rounded-full transition-colors cursor-pointer'
                            ]"
                            >
                            <span
                                :class="[
                                defaultMenuOpen ? 'translate-x-6' : 'translate-x-1',
                                'inline-block h-4 w-4 transform rounded-full bg-white transition-transform duration-300'
                                ]"
                            />
                        </Switch>
                    </div>
                </div>
                
                <div v-if="isAdmin && !loadingAdminSettings" class="border-t border-neutral mt-4 pt-4">
                    <div class="text-primary-light m-6 text-xl font-bold">Impostazioni Amministratore</div>
                    <div class="flex flex-col text-text m-6 gap-4">
                        <p class="text-sm text-gray-500">
                            In quanto amministratore del sistema, puoi accedere al pannello di controllo per gestire permessi e funzioni globali dell'applicazione.
                        </p>
                        <div>
                            <router-link 
                                to="/admin-settings"
                                class="inline-block px-6 py-2.5 bg-primary text-white font-bold rounded-xl hover:bg-primary-hover shadow-lg shadow-primary/20 transition-all duration-200"
                            >
                                Apri Pannello Amministratore
                            </router-link>
                        </div>
                    </div>
                </div>

                <div class="border-t border-gray-100 mt-6 pt-6 mb-8">
                    <div class="flex justify-center px-6">
                        <button 
                            @click="logout"
                            class="flex items-center justify-center gap-2 px-8 py-3.5 bg-red-50 text-red-600 font-bold rounded-2xl cursor-pointer md:hover:bg-red-100 active:scale-95 transition-all duration-200"
                        >
                            <ArrowRightStartOnRectangleIcon class="h-6 w-6" />
                            Esci dall'account
                        </button>
                    </div>
                </div>

            </div>
        </section>
</template>