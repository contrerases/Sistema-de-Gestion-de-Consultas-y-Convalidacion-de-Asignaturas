import axios from "axios";
import type { AxiosError} from 'axios';

import type { RequestResponse, RequestInsert, RequestUpdate } from "@/interfaces/request_model";

const apiUrl = import.meta.env.VITE_API_URL;

const BASE_URL = "http://localhost:8000/requests/";


export async function getAllRequests(): Promise<RequestResponse[]> {
    try {
        const { data: requests } = await axios.get<RequestResponse[]>(BASE_URL);
        return requests;
      } 
    
      catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener solicitudes:', axiosError?.response?.data);
        throw error;
    }    
}

export async function getRequestByID(id: number): Promise<RequestResponse> {
    try {
        const { data: request } = await axios.get<RequestResponse>(`${BASE_URL}${id}`);
        return request;
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener solicitud por ID:', axiosError?.response?.data);
        throw error;
    }
}

// getrequeststudentrol

export async function getRequestByStudentRol(student_rol: string): Promise<RequestResponse> {
    try {
        const { data: request } = await axios.get<RequestResponse>(`${BASE_URL}student/rut/${student_rol}`);
        return request;
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener solicitud por Rol:', axiosError?.response?.data);
        throw error;
    }
}

// byrol

export async function getRequestsByRol(rol: string): Promise<RequestResponse[]> {
    try {
        const { data: requests } = await axios.get<RequestResponse[]>(`${BASE_URL}student/rol/${rol}`);
        return requests;
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener solicitud por Rol:', axiosError?.response?.data);
        throw error;
    }
}

// by rangue of date creation

export async function getRequestsByDateRange(date1: string, date2: string): Promise<RequestResponse[]> {
    try {
        const { data: requests } = await axios.get<RequestResponse[]>(`${BASE_URL}creation_date/${date1}/${date2}`);
        return requests;
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener solicitud por rango de fecha:', axiosError?.response?.data);
        throw error;
    }
}

// by state

export async function getRequestsByState(state: string): Promise<RequestResponse[]> {
    try {
        const { data: requests } = await axios.get<RequestResponse[]>(`${BASE_URL}state/${state}`);
        return requests;
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener solicitud por estado:', axiosError?.response?.data);
        throw error;
    }
}

// insert

export async function insertRequest(request: RequestInsert): Promise<void> {
    const formData = new FormData();
    Object.entries(request).forEach(([key, value]) => {
        if (value !== null && value !== undefined) {
            formData.append(key, value);
        }
    });

    try {
        await axios.post(BASE_URL, formData, {
            headers: {
                'Content-Type': 'multipart/form-data',
            },
        });
  
    
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al insertar convalidación:', axiosError?.response?.data);
        throw error;
    }
  
  
}

//update

export async function updateRequest(request: RequestUpdate): Promise<void> {
    try {
        console.log(request)
        await axios.put(BASE_URL, request);
      }
      catch (error) {
          const axiosError = error as AxiosError;
          console.error('Error al actualizar convalidación:', axiosError?.response?.data);
          throw error;
      }
}