<script setup>
import Footer from '../components/Footer.vue'
import { ref, onMounted } from 'vue'
import axiosInstance from '../axios'
import { useAuth } from '../composables/useAuth'

const { logout } = useAuth()
const message = ref('')

const sendName = async () => {
  try {
    const res = await axiosInstance.post('api/hello/')
    message.value = res.data.message
  } catch (err) {
    message.value = 'Errore nella richiesta'
    console.error(err)
  }
}

onMounted(() => {
  sendName()
})
</script>

<template>
  <div >
    <main >
      <h2>{{ message }}</h2>
      <button @click="logout">Logout</button>
    </main>
  </div>
  <Footer />
</template>
