<script setup>
import Footer from '../components/Footer.vue'
import axiosInstance from '../axios'
import { useAuth } from '../composables/useAuth'
import { ref, onMounted } from 'vue'


const { logout } = useAuth()
const message = ref('')
const user = ref(null)
const error = ref('')


const fetchUser = async () => {
  try {
    const res = await axiosInstance.get('api/auth/users/me/')
    user.value = res.data
    return user.value
  } catch (e) {
    error.value = 'Errore nel recupero dati utente'
    console.error(e)
  }
}


const sendName = async () => {
  try {
    user.value = await fetchUser()
    const res = await axiosInstance.post('api/hello/', {
      name: user.value.username || 'default_name'
    })
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
  <div>
    <h2>{{ message }}</h2>
    <button @click="logout">Logout</button>
  </div>
  <Footer /> 
</template>
 