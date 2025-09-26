<script setup>
import { CalendarDateRangeIcon } from '@heroicons/vue/24/outline'
import { CalendarDateRangeIcon as CalendarDateRangeIconSolid } from '@heroicons/vue/24/solid'
import { ref, onMounted, onBeforeUnmount, watch, nextTick } from 'vue'

const isOpen = ref(false)
const root = ref(null)
const trigger = ref(null)
const panel = ref(null)
const content = ref(null)
const isHoverSelectDateIcon = ref(false)

function toggle() {
  isOpen.value = !isOpen.value
}
function close() {
  isOpen.value = false
}

const emit = defineEmits(['update'])
function bottoneCliccato() {
  // qui puoi decidere il “risultato” interno, senza passare nulla dal bottone
  const risultato = "qualcosa"  
  emit('update', risultato)  // invia al genitore
}

// click fuori
function onDocClick(e) {
  if (!root.value) return
  if (!root.value.contains(e.target)) close()
}
// esc
function onKeyDown(e) {
  if (e.key === 'Escape') close()
}

async function focusFirstInPanel() {
  await nextTick()
  if (!panel.value) return
  const focusable = panel.value.querySelectorAll(
    'a[href], button:not([disabled]), textarea, input, select, [tabindex]:not([tabindex="-1"])'
  )
  if (focusable.length) {
    focusable[0].focus()
  } else if (content.value) {
    content.value.focus()
  }
}

onMounted(() => {
  document.addEventListener('click', onDocClick)
  document.addEventListener('keydown', onKeyDown)
})
onBeforeUnmount(() => {
  document.removeEventListener('click', onDocClick)
  document.removeEventListener('keydown', onKeyDown)
})

watch(isOpen, (val) => {
  if (val) focusFirstInPanel()
  else trigger.value?.focus()
})
</script>

<template>
    <div class="relative inline-block" ref="root">
    <!-- Trigger -->
    <button 
        class="px-4 py-1 rounded-md text-white text-sm bg-primary-light hover:bg-primary flex items-center justify-center gap-2 cursor-pointer"
        ref="trigger"
        @click="toggle"
        @mouseenter="isHoverSelectDateIcon = true"
        @mouseleave="isHoverSelectDateIcon = false"
        >
            <transition name="fade" mode="out-in">
                <component 
                :is="isHoverSelectDateIcon ? CalendarDateRangeIconSolid : CalendarDateRangeIcon" 
                class=
                "h-5.5 w-5.5 !duration-100"
                
                />
            </transition>
            Seleziona Periodo
    </button>

    <!-- Popover -->
    <transition
      enter-active-class="transition ease-out duration-150"
      enter-from-class="opacity-0 translate-y-1 scale-95"
      enter-to-class="opacity-100 translate-y-0 scale-100"
      leave-active-class="transition ease-in duration-100"
      leave-from-class="opacity-100 translate-y-0 scale-100"
      leave-to-class="opacity-0 translate-y-1 scale-95"
    >
      <div
        v-if="isOpen"
        ref="panel"
        class="absolute left-0 mt-2 w-48 origin-top-left rounded-md border border-gray-200 bg-white shadow-lg z-50 focus:outline-none"
      >
        <!-- Arrow -->
        <div
          class="absolute left-4 -top-2 w-3 h-3 bg-white border-l border-t border-gray-200 rotate-45"
          aria-hidden="true"
        ></div>

        <!-- Content -->
        <div class="p-2 flex flex-col gap-1" ref="content" tabindex="-1">
            <button
              class="w-full px-3 py-2 text-left rounded-md text-sm hover:bg-gray-100"
              @click="bottoneCliccato"
            >
              Bottone 1
            </button>
            <button
              class="w-full px-3 py-2 text-left rounded-md text-sm hover:bg-gray-100"
              @click="bottoneCliccato"
            >
              Bottone 2
            </button>
        </div>
      </div>
    </transition>
  </div>
</template>

<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0.6;
}
</style>