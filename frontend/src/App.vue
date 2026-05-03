<script setup>
import { RouterView } from 'vue-router'
import { computed } from 'vue'
import { useAuth } from './composables/useAuth'
import UnlockVault from './components/UnlockVault.vue'

const { authToken } = useAuth()

// Controlla se l'utente è loggato (ha il JWT) ma NON ha la Master Key in memoria
const isVaultLocked = computed(() => {
  const hasToken = !!authToken.value;
  const hasKey = !!sessionStorage.getItem('masterKey');
  return hasToken && !hasKey;
})
</script>

<template>
  <RouterView />
  
  <UnlockVault v-if="isVaultLocked" />
</template>

<style scoped>
</style>