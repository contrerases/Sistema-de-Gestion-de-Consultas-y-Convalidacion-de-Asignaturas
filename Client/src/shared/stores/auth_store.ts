import { defineStore } from 'pinia';

interface AuthState {
  id : number | null;
  username: string | null;
  email: string | null;
  name: string | null;
  rut: string | null;
  rol: string | null;
  role: 'admin' | 'student' | null;
}

export const useAuthStore = defineStore('user', {
  
  state: (): AuthState => ({
    id: 1,
    username: 'Camilo',
    email: "Camilo@gmail.com",
    name: "Camilo Contreras",
    rut: "20369538-1",
    role: null,
    rol: "201873063-7",
  }),


  getters: {
    isAdmin: (state): boolean => state.role === 'admin',
    isStudent: (state): boolean => state.role === 'student',
    isAuthenticated: (state): boolean => state.id !== null,
    
  },


  actions: {
    setUser(id: number, username: string, email: string, name: string, rut: string, role: 'admin' | 'student', rol: string | null) {
      this.id = id;
      this.username = username;
      this.email = email;
      this.name = name;
      this.rut = rut;
      this.role = role;
      this.rol = rol;
    },
    

    clearUser() {
      this.id = null;
      this.username = null; 
      this.email = null;
      this.name = null; 
      this.rut = null;
      this.role = null;

    }
  },
});
