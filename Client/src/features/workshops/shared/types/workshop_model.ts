
export interface WorkshopBase {
  id: number;
  name: string;
  description: string;
  capacity: number;
  instructor: string;
  start_date: string;
  end_date: string;
  state: string;
}

export interface WorkshopInsert extends Omit<WorkshopBase, 'id'> {

}

export interface WorkshopUpdate extends Partial<WorkshopBase> {
  id: number;
}

export interface WorkshopResponse extends WorkshopBase {
  // Propiedades adicionales de respuesta
  enrolled_students?: number;
  available_spots?: number;
}
