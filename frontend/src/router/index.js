import { createRouter, createWebHistory } from 'vue-router';
import CashFlowDashboardView from '../views/CashFlowDashboardView.vue';
import LoginView from '../views/LoginView.vue';


const routes = [
  {
    path: '/cashflow',
    name: 'CashFlowDashboard',
    component: CashFlowDashboardView,
    meta: {
      authenticationRequired: true,
    },
  },
  {
    path: '/login',
    name: 'Login',
    component: LoginView,
  },
    {
      // temporanea per sviluppo una volta inclusa la dashbpard completa sarà quella l'endpoint
    path: '/',
    name: 'Home',
    component: CashFlowDashboardView,
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
