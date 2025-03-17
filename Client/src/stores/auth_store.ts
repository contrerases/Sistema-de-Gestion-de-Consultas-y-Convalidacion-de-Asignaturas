import { defineStore } from 'pinia';

interface AuthState {
  id : number | null;
  username: string | null;
  email: string | null;
  name: string | null;
  rut: string | null;
  role: 'admin' | 'student' | null;
}

export const useAuthStore = defineStore('user', {
  
  state: (): AuthState => ({
    id: null,
    username: null,
    email: null,
    name: null,
    rut: null,
    role: null,
  }),


  getters: {
    isAdmin: (state): boolean => state.role === 'admin',
    isStudent: (state): boolean => state.role === 'student',
    isAuthenticated: (state): boolean => state.id !== null,
    
  },

  // Actions para modificar el estado
  actions: {
    setUser(id: number, username: string, email: string, name: string, rut: string, role: 'admin' | 'student') {
      this.id = id;
      this.username = username;
      this.email = email;
      this.name = name;
      this.rut = rut;
      this.role = role;
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
