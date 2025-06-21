export default function formatReadableDate(date: string | null): string {
    const settings: Intl.DateTimeFormatOptions = {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    };
    return date ? new Date(date).toLocaleDateString('es-ES', settings) : '-';
  }