import axios from 'axios'

const axiosInstance = axios.create({
  baseURL: `http://${import.meta.env.VITE_API_URL}/`,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Attach token to each request if available
axiosInstance.interceptors.request.use(config => {
  const token = localStorage.getItem('authToken')
  if (token) {
    config.headers['Authorization'] = `Token ${token}`
  }
  return config
})

export default axiosInstance