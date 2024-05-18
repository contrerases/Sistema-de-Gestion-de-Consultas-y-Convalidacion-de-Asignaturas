export interface WorkshopBase {
    id: number;
    name: string;
}

export interface WorkshopResponse extends WorkshopBase {
}

export interface WorkshopPost {
    name: string;
}