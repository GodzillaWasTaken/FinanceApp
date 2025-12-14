<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import BaseButton from '@/components/buttons/BaseButton.vue'
import SelectDropdown from '@/components/formcomponents/SelectDropdown.vue'

const props = defineProps({
  isOpen: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['close', 'created'])

const form = ref({
  name: '',
  type: 'expense',
  color: '#1FBC9C'
})

const loading = ref(false)
const error = ref('')

const isMobile = ref(false)

function updateIsMobile() {
  isMobile.value = window.innerWidth < 640
}

onMounted(() => {
  updateIsMobile()
  window.addEventListener('resize', updateIsMobile)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', updateIsMobile)
})


function resetForm() {
  form.value = {
    name: '',
    type: 'expense',
    color: '#000000'
  }
  error.value = ''
}

async function save() {
  if (!form.value.name) {
    error.value = 'Il nome è obbligatorio'
    return
  }

  loading.value = true
  error.value = ''

  try {
    console.log(form.value)
    // const res = await createCategoria(form.value)
    // emit('created', res)
    resetForm()
    emit('close')
  } catch (err) {
    error.value = 'Errore durante il salvataggio'
    console.error(err)
  } finally {
    loading.value = false
  }
}

function close() {
  resetForm()
  emit('close')
}
</script>

<template>
  <Teleport to="body">
    <div v-if="isOpen" class="fixed inset-0 z-[9999] flex items-center justify-center p-4">
      <div class="absolute inset-0 bg-black/40 backdrop-blur-sm" @click="close"></div>
      <div class="relative bg-white rounded-lg shadow-xl p-6 w-full max-w-md z-10 transform transition-all">
        <h3 class="text-lg font-semibold mb-4 text-gray-900">Nuova Categoria</h3>

        <form @submit.prevent="save" class="space-y-4">

          <!-- Name -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Nome</label>
            <input v-model="form.name" type="text" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-light" placeholder="Es. Viaggi" />
          </div>

          <!-- Type -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Tipo</label>
            <SelectDropdown
              v-model="form.type"
              :items="[
                { id: 'income', name: 'Entrata' },
                { id: 'expense', name: 'Uscita' }
              ]"
              placeholder="Seleziona tipo"
              :search-enabled="false"
              :clearable="false"
              class="w-full"
            />
          </div>

          <!-- Color -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Colore</label>
            <div class="flex items-center">
                <v-swatches
                v-model="form.color"
                :inline="isMobile"
                class="flex py-2 justify-center items-center"
              />
            </div>
          </div>

          <!-- Error -->
          <div v-if="error" class="text-red-500 text-sm">{{ error }}</div>

          <!-- Buttons -->
          <div class="flex flex-col-reverse sm:flex-row justify-end gap-3 mt-6">
            <BaseButton as="button" type="button" class="w-full sm:w-auto px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-md transition-colors" @click="close">
              Annulla
            </BaseButton>
            <BaseButton as="button" type="submit" :disabled="loading" class="w-full sm:w-auto px-4 py-2 bg-primary hover:bg-primary-dark text-white rounded-md transition-colors">
              {{ loading ? 'Salvataggio...' : 'Salva' }}
            </BaseButton>
          </div>

        </form>
      </div>
    </div>
  </Teleport>
</template>
