import axios from 'axios'

export const axiosEventBus = new EventTarget()

const baseURL = import.meta.env.PROD
  ? `https://${import.meta.env.VITE_API_URL}/`
  : `http://${import.meta.env.VITE_API_URL}/`

const axiosInstance = axios.create({
  baseURL,
  headers: {
    'Content-Type': 'application/json',
  },
})


// Request interceptor: attach access token
axiosInstance.interceptors.request.use(config => {
  const token = localStorage.getItem('authToken')
  if (token) {
    config.headers['Authorization'] = `Bearer ${token}`
  }
  return config
})

// Response interceptor: handle 401 and refresh token
axiosInstance.interceptors.response.use(
  response => response,
  async error => {
    const originalRequest = error.config
    if (
      error.response &&
      error.response.status === 401 &&
      !originalRequest._retry &&
      !originalRequest.url.endsWith('api/auth/jwt/refresh/') &&
      localStorage.getItem('refreshToken')
    ) {
      originalRequest._retry = true
      try {
        const refreshToken = localStorage.getItem('refreshToken')
        const res = await axiosInstance.post('api/auth/jwt/refresh/', {
          refresh: refreshToken,
        })
        const newAccess = res.data.access
        localStorage.setItem('authToken', newAccess)
        originalRequest.headers['Authorization'] = `Bearer ${newAccess}`
        return axiosInstance(originalRequest)
      } catch (refreshError) {
        // Instead of redirecting, emit an event
        axiosEventBus.dispatchEvent(new Event('auth:logout'))
        return Promise.reject(refreshError)
      }
    }
    return Promise.reject(error)
  }
)

export default axiosInstance