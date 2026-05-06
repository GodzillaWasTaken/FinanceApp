<script setup>
import { onMounted, onUnmounted } from 'vue'
import { ExclamationTriangleIcon, XMarkIcon } from '@heroicons/vue/24/outline'

const props = defineProps({
  show: Boolean,
  title: { type: String, default: 'Conferma operazione' },
  message: { type: String, default: 'Sei sicuro di voler procedere?' },
  confirmText: { type: String, default: 'Conferma' },
  cancelText: { type: String, default: 'Annulla' },
  type: { type: String, default: 'warning' } // 'warning', 'danger', 'info'
})

const emit = defineEmits(['confirm', 'cancel'])

// Bloack scroll when modal is open
onMounted(() => {
  if (props.show) document.body.style.overflow = 'hidden'
})

onUnmounted(() => {
  document.body.style.overflow = ''
})
</script>

<template>
  <Teleport to="body">
    <Transition name="fade">
      <div v-if="show" class="fixed inset-0 z-[100] flex items-center justify-center p-4 sm:p-6">
        <!-- Backdrop -->
        <div 
          class="absolute inset-0 bg-gray-900/60 backdrop-blur-sm transition-opacity" 
          @click="emit('cancel')"
        ></div>

        <!-- Modal Card -->
        <Transition name="scale">
          <div 
            class="relative w-full max-w-sm bg-white rounded-[2rem] shadow-2xl overflow-hidden z-10 border border-gray-100"
            @click.stop
          >
            <!-- Close Button -->
            <button 
              @click="emit('cancel')"
              class="hidden md:block absolute top-4 right-4 p-2 text-gray-400 hover:text-gray-600 hover:bg-gray-100 rounded-full transition-all"
            >
              <XMarkIcon class="h-5 w-5" />
            </button>

            <div class="p-8">
              <!-- Icon Header -->
              <div 
                :class="[
                  'w-16 h-16 rounded-3xl flex items-center justify-center mb-6 mx-auto',
                  type === 'danger' ? 'bg-red-50 text-red-600' : 'bg-amber-50 text-amber-600'
                ]"
              >
                <ExclamationTriangleIcon class="w-8 h-8" />
              </div>

              <!-- Text Content -->
              <div class="text-center mb-8">
                <h3 class="text-xl font-black text-gray-800 mb-2 tracking-tight">{{ title }}</h3>
                <p class="text-sm text-gray-500 leading-relaxed">{{ message }}</p>
              </div>

              <!-- Actions -->
              <div class="flex flex-col gap-3">
                <button 
                  @click="emit('confirm')"
                  :class="[
                    'w-full py-4 rounded-2xl font-bold text-white shadow-lg transition-all active:scale-95',
                    type === 'danger' ? 'bg-red-500 hover:bg-red-600 shadow-red-200' : 'bg-primary-light hover:bg-primary shadow-primary/20'
                  ]"
                >
                  {{ confirmText }}
                </button>
                <button 
                  @click="emit('cancel')"
                  class="w-full py-4 rounded-2xl font-bold text-gray-500 hover:bg-gray-50 hover:text-gray-700 transition-all active:scale-95"
                >
                  {{ cancelText }}
                </button>
              </div>
            </div>
          </div>
        </Transition>
      </div>
    </Transition>
  </Teleport>
</template>

<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}

.scale-enter-active, .scale-leave-active {
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.scale-enter-from, .scale-leave-to {
  transform: scale(0.9) translateY(10px);
  opacity: 0;
}
</style>
