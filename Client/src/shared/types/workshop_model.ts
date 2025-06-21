// Interfaz base para Workshop
export interface WorkshopBase {
    id: number;
    name: string;
    semester: string;
    year: number;
    professor : string;
    initial_date: string; 
    inscription_deadline: string;
    file_data: File | null; 
    available: boolean;
    state: string;
  }
  

  export interface WorkshopPost {
    name: string;
    semester: number;
    year: number;
    professor : string;
    initial_date: string;
    inscription_deadline: string;
    file_data: File | null;
  }
  
 
  export interface WorkshopResponse {
    id: number;
    name: string;
    semester: string;
    year: number;
    professor: string;
    initial_date: string;
    inscription_deadline: string;
    file_data: File | null;
    available: boolean;
    state: string;
  }
  
  