<script setup>
import { ref, computed } from 'vue'
import { useAuth } from '../composables/useAuth'
import Footer from '../components/Footer.vue'

const username = ref('')
const password = ref('')
const email = ref('')
const { register, authError } = useAuth()
const showPassword = ref(false);

const passwordFieldType = computed(() => showPassword.value ? 'text' : 'password');

const handleRegistration = async () => {
  //wait for the register funcion to complete  to handle possible errors (thas why we use await)
    await register(email.value, username.value, password.value)
}

const togglePasswordVisibility = () => {
  showPassword.value = !showPassword.value;
};

const isFormValid = computed(() => {
  return username.value.length > 0 && password.value.length > 0;
});

</script>

<template>
  <div class="d-flex flex-column min-vh-100 bg-light">
    <div class="d-flex flex-grow-1 justify-content-center align-items-center p-3">
      <div class="row w-100 justify-content-center">
        <div class="col-sm-10 col-md-8 col-lg-6">
          <div class="card p-4 rounded-4 shadow-lg">
            <h2 class="card-title text-center fw-bold mb-3">Sign up</h2>
            <p class="text-center text-muted mb-4">
              Already have an account? <router-link to="/login" class="text-decoration-none text-primary fw-bold">Log in</router-link>
            </p>

            <form @submit.prevent="handleRegistration">
              <div class="mb-3">
                <label for="username" class="form-label">Your username</label>
                <input id="username" v-model="username" placeholder="Username" class="form-control" required/>
              </div>
              <div class="mb-3">
                <label for="email" class="form-label">Your email</label>
                <input id="email" v-model="email" type="email" placeholder="Email" class="form-control" required/>
              </div>
              <div class="mb-3 position-relative">
                <label for="password" class="form-label">Your password</label>
                <input :type="passwordFieldType" id="password" v-model="password" placeholder="Password" class="form-control" required>
                <span class="password-toggle" @click="togglePasswordVisibility">{{ showPassword ? 'Hide' : 'Show' }}</span>
              </div>

              <button
                type="submit"
                class="btn w-100 mt-4 text-white fw-bold"
                :class="isFormValid ? 'btn-dark' : 'btn-secondary'"
                :disabled="!isFormValid"
              >
                Sign up
              </button>
              <p v-if="authError" class="text-danger mt-3">{{ authError }}</p>
            </form>
          </div>
        </div>
      </div>
    </div>
    <Footer />
  </div>
</template>

<style scoped>
.password-toggle {
  position: absolute;
  right: 15px;
  top: 50%;
  transform: translateY(-50%);
  cursor: pointer;
  color: #6c757d;
  font-size: 0.9rem;
}
</style>