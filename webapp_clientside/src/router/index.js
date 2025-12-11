import { createRouter, createWebHistory } from 'vue-router'
import Libraryhome from '../components/libraryhome.vue'
import Contact from '../components/contact.vue'
import Profile from '../components/profile.vue'
import Admin from '../components/admin.vue'
import Login from '../components/Login.vue'

//creating routes for different components

const routes = [
  {
    path: '/',
    name: 'home',
    component: Libraryhome
  },
  {
    path: '/contact',
    name: 'contact',
    component: Contact
  },
  {
    path: '/login',
    name: 'login',
    component: Login
  },
  {
    path: '/profile',
    name: 'profile',
    component: Profile
  },
  {
    path:'/admin',
    name:'admin',
    component : Admin
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
