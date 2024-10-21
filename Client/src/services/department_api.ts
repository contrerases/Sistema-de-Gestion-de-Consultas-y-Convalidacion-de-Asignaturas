import type { DepartmentBase, DepartmentResponse, DepartmentPost } from '@/interfaces/department_model';
import axios from "axios";
import type { AxiosError } from 'axios';



const BASE_URL = "http://localhost:8000/departments/";


export async function getAllDepartments(): Promise<DepartmentResponse[]> {
    try {
        const { data: departments } = await axios.get<DepartmentResponse[]>(BASE_URL);
        return departments;
      } 
      
      catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener Departamentos:', axiosError?.response?.data);
        throw error;
    }    
}




export async function insertDepartment(department: DepartmentPost): Promise<void> {
    try {
        await axios.post(BASE_URL, department);
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al insertar Departamento:', axiosError?.response?.data);
        throw error;
    }
}


export async function updateDepartment(department_id: number, department: DepartmentBase): Promise<void> {
    try {
        await axios.put(`${BASE_URL}${department_id}`, department);
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al actualizar Departamento:', axiosError?.response?.data);
        throw error;
    }
}