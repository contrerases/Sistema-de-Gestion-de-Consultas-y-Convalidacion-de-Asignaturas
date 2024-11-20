import { defineStore } from 'pinia';

interface AuthState {
  id : number;
  username: string;
  email: string;
  name: string;
  rut: string;
  role: 'admin' | 'student';
}

export const useAuthStore = defineStore('user', {
  
  state: (): AuthState => ({
    id: 1,
    username: 'cecontre',  
    email: 'camilo.contreras@sansano.usm.cl', 
    name: 'Camilo Contreras',
    rut: '98765432-1',
    role: 'admin', 
  }),


  getters: {
    isAdmin: (state): boolean => state.role === 'admin',
    isStudent: (state): boolean => state.role === 'student',
  },

  // Actions para modificar el estado
  actions: {
    setUser(username: string, email: string, name: string, role: 'admin' | 'student') {
      this.username = username;
      this.email = email;
      this.name = name;
      this.role = role;
    },

    clearUser() {
      this.username = 'cecontre'; 
      this.email = 'camilo.contreras@sansano.usm.cl';
      this.name = 'Camilo Contreras'; 
      this.role = 'student'; // 
    }
  },
});
