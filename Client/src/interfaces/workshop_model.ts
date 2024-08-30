// Interfaz base para Workshop
export interface WorkshopBase {
    id: number;
    name: string;
    semester: string; 
    year: number;
    professor : string;
    initial_date: string; 
    file_data: File | null; 
    available: boolean;
  }
  

  export interface WorkshopPost {
    name: string;
    semester: string; 
    year: number;
    professor : string;
    initial_date: string;
    file_data: File | null;
  }
  
 
  export interface WorkshopResponse {
    id: number;
    name: string;
    semester: string;
    year: number;
    professor: string;
    initial_date: string;
    file_data: File | null;
    available: boolean;
  }
  