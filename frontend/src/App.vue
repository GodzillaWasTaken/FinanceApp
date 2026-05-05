<script setup>
import { RouterView } from 'vue-router'
import { computed } from 'vue'
import { useAuth } from './composables/useAuth'
import UnlockVault from './components/UnlockVault.vue'

const { authToken } = useAuth()

// Check if the user is logged in (has JWT) but does NOT have the Master Key in memory
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