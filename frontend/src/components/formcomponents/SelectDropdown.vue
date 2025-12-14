<script setup>
import { ref, computed, onMounted, onUnmounted, defineAsyncComponent } from 'vue'
import { ChevronDownIcon, CheckIcon, PlusIcon } from '@heroicons/vue/24/outline'
const CreateCategoryModal = defineAsyncComponent(() => import('@/components/modals/CreateCategoryModal.vue'))

const props = defineProps({
  items: { type: Array, default: () => [] },
  modelValue: { type: [String, Number], default: '' },
  placeholder: { type: String, default: 'Select' },
  itemLabel: { type: String, default: 'name' },
  showColor: { type: Boolean, default: false },
  clearable: { type: Boolean, default: true },
  searchEnabled: { type: Boolean, default: true },
  required: { type: Boolean, default: false },

  allowCreateCategory: { type: Boolean, default: false }
})

const emit = defineEmits(['update:modelValue', 'select', 'clear', 'item-created'])

const open = ref(false)
const search = ref('')

const containerRef = ref(null)
const showCreateModal = ref(false)

const filtered = computed(() => {
  if (!props.searchEnabled || !search.value) return props.items || []
  const q = String(search.value).toLowerCase()
  return (props.items || []).filter(i => (String(i[props.itemLabel] || '')).toLowerCase().includes(q))
})

const selectedItem = computed(() => {
  return (props.items || []).find(i => String(i.id) === String(props.modelValue)) || null
})

function toggle() { open.value = !open.value }

function choose(item) {
  emit('update:modelValue', item.id)
  emit('select', item)
  search.value = ''
  open.value = false
}

function clearSelection(e) {
  e && e.stopPropagation()
  emit('update:modelValue', '')
  emit('clear')
  search.value = ''
  open.value = false
}

function onClickOutside(e) {
  if (!containerRef.value) return
  if (!containerRef.value.contains(e.target)) open.value = false
}

function onKeydown(e) {
  if (e.key === 'Escape') open.value = false
}

onMounted(() => {
  document.addEventListener('click', onClickOutside)
  document.addEventListener('keydown', onKeydown)
})
onUnmounted(() => {
  document.removeEventListener('click', onClickOutside)
  document.removeEventListener('keydown', onKeydown)
})
</script>

<template>
  <div class="relative" ref="containerRef">
    <button type="button" @click="toggle" :aria-expanded="open" aria-haspopup="listbox"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-light flex items-center justify-between gap-2 text-gray-700">
       <div class="flex items-center gap-3">
        <span v-if="selectedItem && props.showColor && selectedItem.color" :style="{ backgroundColor: selectedItem.color }" class="w-3.5 h-3.5 rounded-full inline-block"></span>
        <span
          class="block whitespace-normal"
          :title="selectedItem ? selectedItem[props.itemLabel] : placeholder"
        >
          {{ selectedItem ? selectedItem[props.itemLabel] : placeholder }}
        </span>
      </div>

      <div class="flex items-center gap-2">
        <button v-if="selectedItem && props.clearable" @click.stop="clearSelection" type="button" class="text-gray-400 hover:text-gray-600 px-1">×</button>
        <ChevronDownIcon :class="['h-5 w-5 transition-transform', open ? 'rotate-180' : 'rotate-0']" />
      </div>
    </button>

    <transition name="fade">
      <div v-if="open" class="absolute z-50 w-full mt-2 bg-white border border-gray-200 rounded-md shadow-lg">
        <div v-if="props.searchEnabled" class="p-2">
          <input v-model="search" type="search" placeholder="Cerca..."
                 class="w-full px-3 py-2 border border-gray-100 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-light" />
        </div>

        <ul role="listbox" class="max-h-56 overflow-y-auto divide-y divide-gray-100">
          <li v-if="(filtered || []).length === 0" class="px-3 py-2 text-sm text-gray-500">Nessuna voce trovata</li>
          <li v-for="item in filtered" :key="item.id" @click="choose(item)"
              class="px-3 py-2 cursor-pointer flex items-center justify-between hover:bg-10"
              :aria-selected="selectedItem && selectedItem.id === item.id">
            <div class="flex items-center gap-3">
              <span v-if="props.showColor && item.color" :style="{ backgroundColor: item.color }" class="w-3.5 h-3.5 rounded-full inline-block"></span>
              <span class="text-sm text-text">{{ item[props.itemLabel] }}</span>
            </div>
            <span v-if="selectedItem && selectedItem.id === item.id" class="text-primary"><CheckIcon class="h-4 w-4" /></span>
          </li>
        </ul>

        <div v-if="props.allowCreateCategory" class="group p-2 border-t border-gray-100 flex items-center justify-center">
          <div class="flex items-center justify-center gap-2  text-sm text-text">
            <button type="button" @click="showCreateModal = true" class=" cursor-pointer flex items-center gap-2 justify-center transition-colors hover:bg-primary/10 rounded-lg px-3 py-2">
                <PlusIcon class="h-4 w-4" />
                <span>Crea nuova categoria</span>
            </button>
          </div>
        </div>
      </div>
    </transition>
    
    <CreateCategoryModal 
      :is-open="showCreateModal" 
      @close="showCreateModal = false"
      @created="(newItem) => { 
        emit('item-created', newItem); 
        choose(newItem); 
        showCreateModal = false; 
      }" 
    />
  </div>
</template>

<style scoped>
.fade-enter-active, .fade-leave-active { 
    transition: opacity .15s ease, transform .15s ease;
}
.fade-enter-from, .fade-leave-to {
    opacity: 0; transform: translateY(-4px); 
}
.truncate { 
    max-width: calc(100% - 3rem); display: inline-block; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; 
}
</style>
