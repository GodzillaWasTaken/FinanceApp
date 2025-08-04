import { createRouter, createWebHistory } from 'vue-router';
import HelloWorld from '../components/HelloWorld.vue';


const routes = [
  {
    path: '/',
    name: 'Home',
    component: HelloWorld,
    meta: {
      authenticationRequired: false,
    },
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
