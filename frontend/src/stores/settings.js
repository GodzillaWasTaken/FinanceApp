import { defineStore } from "pinia";
import { ref, watch } from 'vue';

export const useSettingsStore = defineStore('settings', () => {
  const currencyFormat = ref(localStorage.getItem('currencyFormat') || 'it-IT')
  const defaultMenuOpen = ref(localStorage.getItem('defaultMenuOpen') === 'true')

  watch(currencyFormat, (val) => localStorage.setItem('currencyFormat', val))
  watch(defaultMenuOpen, (val) => localStorage.setItem('defaultMenuOpen', val))

  return { currencyFormat, defaultMenuOpen }
})