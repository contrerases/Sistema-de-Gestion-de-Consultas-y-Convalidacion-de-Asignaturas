
export default function downloadPdf(binaryPDF: string | null) {
    if (!binaryPDF) return;
    const binaryData = atob(binaryPDF);
    const bytes = new Uint8Array(binaryData.length);
    for (let i = 0; i < binaryData.length; i++) {
      bytes[i] = binaryData.charCodeAt(i);
    }
    const blob = new Blob([bytes], { type: "application/pdf" });
    const pdfUrl = URL.createObjectURL(blob);
    const anchor = document.createElement("a");
    anchor.href = pdfUrl;
    anchor.target = "_blank";
    anchor.setAttribute("Descargar", "file");
    document.body.appendChild(anchor);
    anchor.click();
    document.body.removeChild(anchor);
  }