import { createRouter, createWebHistory } from 'vue-router';
import HelloWorld from '../views/HelloWorld.vue';
import LoginView from '../views/LoginView.vue';
import RegisterView from '../views/RegisterView.vue';


const routes = [
  {
    path: '/',
    name: 'Home',
    component: HelloWorld,
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
    path: '/register',
    name: 'Registration',
    component: RegisterView,
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
