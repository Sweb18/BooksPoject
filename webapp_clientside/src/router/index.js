import { createRouter, createWebHistory } from 'vue-router'
import Libraryhome from '../components/libraryhome.vue'
import Contact from '../components/contact.vue'
import Profile from '../components/profile.vue'

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
    path: '/profile',
    name: 'profile',
    component: Profile
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
