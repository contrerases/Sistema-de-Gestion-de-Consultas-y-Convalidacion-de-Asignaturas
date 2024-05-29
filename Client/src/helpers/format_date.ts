export default function formatReadableDate(date: string | null): string {
    const settings: Intl.DateTimeFormatOptions = {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    };
    return date ? new Date(date).toLocaleDateString('es-ES', settings) : '-';
  }