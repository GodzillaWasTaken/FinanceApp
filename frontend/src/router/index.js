import { createRouter, createWebHistory } from 'vue-router';
import MainDashboard from '../views/MainDashboard.vue';
import LoginView from '../views/LoginView.vue';


const routes = [
  {
    path: '/',
    name: 'Home',
    component: MainDashboard,
    meta: {
      authenticationRequired: true,
    },
  },
  {
    path: '/login',
    name: 'Login',
    component: LoginView,
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((to, from, next) => {
  const isAuthenticated = !!localStorage.getItem('authToken');
  if (to.meta.authenticationRequired && !isAuthenticated) {
    next('/login');
  } else {
    next();
  }
});

export default router;
