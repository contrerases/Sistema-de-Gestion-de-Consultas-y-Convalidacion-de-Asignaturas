import axios from "axios";
import type { AxiosError} from 'axios';
import type{ ConvalidationResponse, ConvalidationBase } from "../models/convalidation_model";



const URL = "http://localhost:8000/convalidations/";


export async function getAllConvalidation(): Promise<ConvalidationResponse[]> {
    try {
        const { data: convalidations } = await axios.get<ConvalidationResponse[]>(URL);
        return convalidations;
      } 
    
      catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener convalidaciones:', axiosError?.response?.data);
        throw error;
    }    
}



// Definir explícitamente las claves del objeto ConvalidationBase


// export async function insertConvalidation(convalidation: ConvalidationBase): Promise<void> {
//     try {

//         type ConvalidationKeys = keyof ConvalidationBase;
//         let convalidationFormData = new FormData();
        
//         // Convertir el objeto convalidation en FormData
//         for (const key of Object.keys(convalidation) as ConvalidationKeys[]) {
//             const value = convalidation[key];
//             if (value !== null && value !== undefined) {
//                 if (key === 'file_data' && value instanceof Uint8Array) {
//                     // Convertir Uint8Array a Blob y agregarlo al FormData
//                     const blob = new Blob([value], { type: 'application/octet-stream' });
//                     convalidationFormData.append(key, blob, convalidation.file_name ?? 'file');
//                 } else {
//                     // Convertir el valor a cadena y agregarlo al FormData
//                     convalidationFormData.append(key, String(value));
//                 }
//             }
//         }

//         await axios.post<void>(URL, convalidationFormData);
        
//         console.log('Convalidación insertada correctamente');
//     } catch (error) {
//         // Manejar errores
//         const axiosError = error as AxiosError;
//         console.error('Error al insertar convalidación:', axiosError?.response?.data);
//         throw error;
//     }
// }
