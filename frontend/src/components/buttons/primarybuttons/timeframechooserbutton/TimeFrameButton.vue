<script setup>
import { ref, onBeforeUnmount, watch, nextTick, onMounted, onUnmounted} from 'vue'
import { CalendarDateRangeIcon } from '@heroicons/vue/24/outline'
import { CalendarDateRangeIcon as CalendarDateRangeIconSolid } from '@heroicons/vue/24/solid'
import YearMonthChooser from './YearMonthChooser.vue'
import PrimaryButton from '@/components/buttons/primarybuttons/PrimaryButton.vue';

const props = defineProps({
  dataPeriod: {
    type: String,
    default: new Date().getFullYear().toString()
  }
})
const isOpen = ref(false)
const root = ref(null)
const trigger = ref(null)
const panel = ref(null)
const content = ref(null)
const isHoverSelectDateIcon = ref(false)

const buttonDesc = ref(props.dataPeriod)

const preSetButtons = [
  { id: 1, label: 'Totale' }
]

//gestione della dimensinione finestra per mostrare popover mobile o desktop
const windowWidth = ref(window.innerWidth)

function handleResize() {
  windowWidth.value = window.innerWidth
}

onMounted(() => {
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
})

const emit = defineEmits(['timeFrameUpdate', 'buttonToggled'])

function toggle() {
  isOpen.value = !isOpen.value
  emit('buttonToggled', isOpen.value)
}




function timeFrameUpdated(timeFrame, source) {
  emit('timeFrameUpdate', timeFrame, source)

  if (source === 'monthYear') {
    let label = timeFrame.month.toString().padStart(2, '0') + '/' + timeFrame.year
    buttonDesc.value = label
    return
  }

  buttonDesc.value = timeFrame.toString()
  toggle()
}



// doc handlers gestiti dinamicamente
const docClickHandler = (e) => {
  if (!root.value) return
  if (!root.value.contains(e.target)) toggle()
}
const keydownHandler = (e) => {
  if (e.key === 'Escape') toggle()
}
function addDocListeners() {
  document.addEventListener('click', docClickHandler)
  document.addEventListener('keydown', keydownHandler)
}
function removeDocListeners() {
  document.removeEventListener('click', docClickHandler)
  document.removeEventListener('keydown', keydownHandler)
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

// watch su isOpen per aggiungere/rimuovere listener e gestire focus
watch(isOpen, (val) => {
  if (val) {
    addDocListeners()
    focusFirstInPanel()
  } else {
    removeDocListeners()
    trigger.value?.focus()
  }
})

onBeforeUnmount(() => {
  removeDocListeners()
})
</script>

<template>
  <div class="relative inline-block" ref="root">
    <!-- Trigger -->
    <PrimaryButton 
        ref="trigger"
        @click="toggle"
        @mouseenter="isHoverSelectDateIcon = true"
        @mouseleave="isHoverSelectDateIcon = false"
        :aria-expanded="isOpen"
        aria-haspopup="menu"
        class="h-8 w-25 flex gap-2 items-center justify-center px-3 font-medium"
    >
      <transition name="fade" mode="out-in">
        <component 
          :is="isHoverSelectDateIcon ? CalendarDateRangeIconSolid : CalendarDateRangeIcon" 
          class="h-5 w-5 transition duration-100"
        />
      </transition>
      {{buttonDesc}}
    </PrimaryButton>



    <!-- Popover desktop-->
    <transition
      enter-active-class="transition ease-out duration-150"
      enter-from-class="opacity-0 translate-y-2 scale-95"
      enter-to-class="opacity-100 translate-y-0 scale-100"
      leave-active-class="transition ease-in duration-100"
      leave-from-class="opacity-100 translate-y-0 scale-100"
      leave-to-class="opacity-0 translate-y-2 scale-95"
    >
      <div
        v-if="isOpen & windowWidth >= 768"
        ref="panel"
        role="menu"
        class="absolute left-1/2 transform -translate-x-1/2 mt-2 mr-20 w-60 rounded-lg border border-gray-200 bg-white shadow-lg z-50 focus:outline-none"
        style="left: calc(50% + 1rem); transform: translateX(-50%); max-width: 90vw;"
      >
        <!-- Arrow -->
        <div
          class="absolute right-1 -top-2 w-3 h-3 bg-white border-l border-t border-gray-200 rotate-45 -translate-x-1/2"
          aria-hidden="true"
        ></div>

        <!-- Content -->
        <div class="p-3 flex flex-col gap-2" ref="content" tabindex="-1">

          <YearMonthChooser 
            :timeFrame="props.dataPeriod"
            @updateYear="(timeFrame) => timeFrameUpdated(timeFrame, 'year')"
            @updateMonthYear="(timeFrame) => timeFrameUpdated(timeFrame, 'monthYear')"

            />

          <!-- preset buttons -->
          <button v-for="button in preSetButtons" :key="button.id"
            class="w-full px-3 py-2 rounded-md text-center hover:bg-primary-clear/50 transition cursor-pointer"
            @click="timeFrameUpdated(button.label, 'preset')"
          >
            {{button.label}}
          </button>
          <button
            @click="toggle" 
            class="text-center text-sm text-text/50 cursor-pointer hover:underline"
          >
              Chiudi
          </button>
        </div>
      </div>
    </transition>



    <!-- Popover mobile-->

    <transition
      enter-active-class="transition ease-out duration-150"
      enter-from-class="opacity-0 translate-y-2 scale-95"
      enter-to-class="opacity-100 translate-y-0 scale-100"
      leave-active-class="transition ease-in duration-100"
      leave-from-class="opacity-100 translate-y-0 scale-100"
      leave-to-class="opacity-0 translate-y-2 scale-95"
    >
      <div
        v-if="isOpen & windowWidth < 768"
        ref="panel"
        role="menu"
        class="absolute left-1/2 transform -translate-x-1/2 mt-20 mr-20 w-70 rounded-lg border border-gray-200 bg-white shadow-lg z-50 focus:outline-none"
      >
       
        <!-- Content -->
        <div class="p-3 flex flex-col gap-4" ref="content" tabindex="-1">

          <YearMonthChooser
            :timeFrame="props.dataPeriod"
            @updateYear="(timeFrame) => timeFrameUpdated(timeFrame, 'year')"
            @updateMonthYear="(timeFrame) => timeFrameUpdated(timeFrame, 'monthYear')"

          />

          <button v-for="button in preSetButtons" :key="button.id"
            class="w-full px-3 py-2 text-lg rounded-md text-center hover:bg-primary-clear/50 transition cursor-pointer"
            @click="timeFrameUpdated(button.label, 'preset')"
          >
            {{button.label}}
          </button>
          <button
            @click="toggle" 
            class="text-center text-sm text-text/50 cursor-pointer hover:underline"
          >
              Chiudi
          </button>
        </div>
      </div>
    </transition>
  </div>
</template>
