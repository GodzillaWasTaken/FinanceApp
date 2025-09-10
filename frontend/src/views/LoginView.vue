<script setup>
import { ref, computed } from 'vue';
import { useAuth } from '../composables/useAuth';
import Footer from '../components/Footer.vue';
import Title from '../components/Title.vue';
import ShowHideButton from '../components/ShowHideButton.vue';

const username = ref('');
const password = ref('');
const showPassword = ref(false);

const { login, authError } = useAuth();

const passwordFieldType = computed(() => showPassword.value ? 'text' : 'password');

const handleLogin = () => {
  login(username.value, password.value);
};

const togglePasswordVisibility = () => {
  showPassword.value = !showPassword.value;
};

const isFormValid = computed(() => {
  return username.value.length > 0 && password.value.length > 0;
});

</script>

<template>
  <div class="flex flex-col min-h-screen bg-background">
    <div class="flex-grow flex justify-center items-center p-6">
      <div class="w-full max-w-lg">
        <div class="bg-white rounded-2xl shadow-lg p-8">
          <Title title="FinanceApp" class="text-5xl" />
          <h2 class="text-center text-2xl font-bold mb-4 text-text">Accedi</h2>

          <form @submit.prevent="handleLogin" class="space-y-6">
            <div>
              <label for="username" class="block text-text font-semibold mb-1">Username</label>
              <input
                id="username"
                v-model="username"
                type="text"
                placeholder="Username"
                required
                class="w-full px-4 py-2 rounded-lg border border-neutral bg-primary-clear text-text focus:outline-none focus:ring-2 focus:ring-secondary-light"
              />
            </div>

            <div class="relative">
              <label for="password" class="block text-text font-semibold mb-1">Password</label>
              <input
                :type="passwordFieldType"
                id="password"
                v-model="password"
                placeholder="Password"
                required
                class="w-full px-4 py-2 rounded-lg border border-neutral bg-primary-clear text-text focus:outline-none focus:ring-2 focus:ring-secondary-light"
              />
              <ShowHideButton 
                class="show-button"
                :showPassword="showPassword"
                @toggle="togglePasswordVisibility"
              />
            </div>

            <button
              type="submit"
              :disabled="!isFormValid"
              :class="isFormValid ? 'bg-primary hover:bg-primary-hover text-neutral cursor-pointer' : 'bg-primary-light text-text cursor-not-allowed'"
              class="w-full py-3 rounded-lg font-bold transition-colors"
            >
              Accedi
            </button>

            <p v-if="authError" class="text-red-600 mt-3 text-center">{{ authError }}</p>
            
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>

.relative {
  position: relative;
}

.show-button {
  position: absolute;
  right: 45px;
  top: 70%
}

</style>