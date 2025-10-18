import { defineStore } from "pinia";
import { ref, watch, computed } from 'vue';

export const useSettingsStore = defineStore('settings', () => {
  const currencyFormat = ref(localStorage.getItem('currencyFormat') || 'it-IT')
  const currencySymbol = ref(localStorage.getItem('currencySymbol') || 'EUR')
  const defaultMenuOpen = ref(localStorage.getItem('defaultMenuOpen') === 'true')
  const dataPeriod = ref(localStorage.getItem('dataPeriod') || new Date().getFullYear().toString())

  watch(currencyFormat, (val) => localStorage.setItem('currencyFormat', val))
  watch(defaultMenuOpen, (val) => localStorage.setItem('defaultMenuOpen', val))
  watch(dataPeriod, (val) => localStorage.setItem('dataPeriod', val))
  watch(currencySymbol, (val) => localStorage.setItem('currencySymbol', val))

  const displayCurrencySymbol = computed(() => {
    const formatter = new Intl.NumberFormat(currencyFormat.value, {
      style: 'currency',
      currency: currencySymbol.value,
      minimumFractionDigits: 0,
      maximumFractionDigits: 0
    });
    const parts = formatter.formatToParts(1);
    return parts.find(p => p.type === 'currency')?.value || currencySymbol.value;
  })

  return { currencyFormat, defaultMenuOpen, dataPeriod, currencySymbol, displayCurrencySymbol }
})