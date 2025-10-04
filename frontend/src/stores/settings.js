import { defineStore } from "pinia";
import { ref, watch } from 'vue';

export const useSettingsStore = defineStore('settings', () => {
  const currencyFormat = ref(localStorage.getItem('currencyFormat') || 'it-IT')
  const defaultMenuOpen = ref(localStorage.getItem('defaultMenuOpen') === 'true')
  const dataPeriod = ref(localStorage.getItem('dataPeriod') || new Date().getFullYear().toString())

  watch(currencyFormat, (val) => localStorage.setItem('currencyFormat', val))
  watch(defaultMenuOpen, (val) => localStorage.setItem('defaultMenuOpen', val))
  watch(dataPeriod, (val) => localStorage.setItem('dataPeriod', val))

  return { currencyFormat, defaultMenuOpen, dataPeriod }
})