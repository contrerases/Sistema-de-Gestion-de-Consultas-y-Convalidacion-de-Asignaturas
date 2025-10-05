<script setup lang="ts">
import { ref, computed } from 'vue';

/**
 * Props del componente FileUpload
 */
export interface FileUploadProps {
  accept?: string;
  multiple?: boolean;
  maxSize?: number; // en MB
  disabled?: boolean;
}

/**
 * Eventos emitidos por el componente FileUpload
 */
export interface FileUploadEmits {
  'update:files': [files: File[]];
  change: [files: File[]];
  error: [message: string];
}

const props = withDefaults(defineProps<FileUploadProps>(), {
  accept: '*',
  multiple: false,
  maxSize: 10,
  disabled: false,
});

const emit = defineEmits<FileUploadEmits>();

const isDragging = ref(false);
const files = ref<File[]>([]);
const fileInputRef = ref<HTMLInputElement | null>(null);

const hasFiles = computed(() => files.value.length > 0);

const formatFileSize = (bytes: number): string => {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
};

const validateFile = (file: File): boolean => {
  const maxSizeBytes = props.maxSize * 1024 * 1024;
  if (file.size > maxSizeBytes) {
    emit('error', `El archivo ${file.name} excede el tamaño máximo de ${props.maxSize}MB`);
    return false;
  }
  return true;
};

const handleFiles = (newFiles: FileList | null): void => {
  if (!newFiles || props.disabled) return;

  const validFiles: File[] = [];
  Array.from(newFiles).forEach((file) => {
    if (validateFile(file)) {
      validFiles.push(file);
    }
  });

  if (props.multiple) {
    files.value = [...files.value, ...validFiles];
  } else {
    files.value = validFiles.slice(0, 1);
  }

  emit('update:files', files.value);
  emit('change', files.value);
};

const handleDragEnter = (event: DragEvent): void => {
  event.preventDefault();
  if (!props.disabled) {
    isDragging.value = true;
  }
};

const handleDragLeave = (event: DragEvent): void => {
  event.preventDefault();
  isDragging.value = false;
};

const handleDragOver = (event: DragEvent): void => {
  event.preventDefault();
};

const handleDrop = (event: DragEvent): void => {
  event.preventDefault();
  isDragging.value = false;
  if (!props.disabled && event.dataTransfer) {
    handleFiles(event.dataTransfer.files);
  }
};

const handleFileInputChange = (event: Event): void => {
  const target = event.target as HTMLInputElement;
  handleFiles(target.files);
};

const removeFile = (index: number): void => {
  files.value.splice(index, 1);
  emit('update:files', files.value);
  if (fileInputRef.value) {
    fileInputRef.value.value = '';
  }
};

const openFileDialog = (): void => {
  if (!props.disabled && fileInputRef.value) {
    fileInputRef.value.click();
  }
};

const clearFiles = (): void => {
  files.value = [];
  if (fileInputRef.value) {
    fileInputRef.value.value = '';
  }
  emit('update:files', files.value);
};
</script>

<template>
  <div class="file-upload-wrapper">
    <div
      :class="[
        'file-upload-dropzone',
        {
          'file-upload-dragging': isDragging,
          'file-upload-disabled': disabled,
          'file-upload-has-files': hasFiles,
        },
      ]"
      @dragenter="handleDragEnter"
      @dragleave="handleDragLeave"
      @dragover="handleDragOver"
      @drop="handleDrop"
      @click="openFileDialog"
    >
      <input
        ref="fileInputRef"
        type="file"
        class="file-upload-input"
        :accept="accept"
        :multiple="multiple"
        :disabled="disabled"
        @change="handleFileInputChange"
      />

      <div class="file-upload-content">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="file-upload-icon"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"
          />
        </svg>

        <div class="file-upload-text">
          <p class="file-upload-title">
            <span v-if="!hasFiles">Arrastra archivos aquí o</span>
            <span v-else>Agregar más archivos</span>
            <span class="file-upload-browse">haz clic para buscar</span>
          </p>
          <p class="file-upload-hint">
            {{ accept !== '*' ? `Formatos: ${accept}` : 'Cualquier formato' }} · Máximo {{ maxSize }}MB
          </p>
        </div>
      </div>
    </div>

    <div v-if="hasFiles" class="file-upload-list">
      <div v-for="(file, index) in files" :key="index" class="file-upload-item">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="file-item-icon"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
          />
        </svg>

        <div class="file-item-info">
          <p class="file-item-name">{{ file.name }}</p>
          <p class="file-item-size">{{ formatFileSize(file.size) }}</p>
        </div>

        <button type="button" class="file-item-remove" @click.stop="removeFile(index)" aria-label="Eliminar archivo">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>

      <button v-if="hasFiles" type="button" class="file-upload-clear" @click="clearFiles">
        Limpiar todos
      </button>
    </div>
  </div>
</template>

<style scoped>
.file-upload-wrapper {
  @apply w-full space-y-4;
}

.file-upload-dropzone {
  @apply relative border-2 border-dashed border-muted-foreground rounded-lg p-8;
  @apply transition-all duration-200 cursor-pointer;
  @apply hover:border-primary hover:bg-muted;
}

.file-upload-dragging {
  @apply border-primary bg-primary bg-opacity-5;
}

.file-upload-disabled {
  @apply opacity-50 cursor-not-allowed pointer-events-none;
}

.file-upload-has-files {
  @apply border-primary;
}

.file-upload-input {
  @apply hidden;
}

.file-upload-content {
  @apply flex flex-col items-center justify-center text-center;
}

.file-upload-icon {
  @apply w-12 h-12 text-muted-foreground mb-4;
}

.file-upload-text {
  @apply space-y-2;
}

.file-upload-title {
  @apply text-sm font-medium text-foreground;
}

.file-upload-browse {
  @apply text-primary hover:underline ml-1;
}

.file-upload-hint {
  @apply text-xs text-muted-foreground;
}

.file-upload-list {
  @apply space-y-2;
}

.file-upload-item {
  @apply flex items-center gap-3 p-3 bg-card border border-border rounded-lg;
}

.file-item-icon {
  @apply w-8 h-8 text-primary flex-shrink-0;
}

.file-item-info {
  @apply flex-1 min-w-0;
}

.file-item-name {
  @apply text-sm font-medium text-foreground truncate;
}

.file-item-size {
  @apply text-xs text-muted-foreground;
}

.file-item-remove {
  @apply p-1 rounded hover:bg-destructive hover:text-destructive-foreground transition-colors;
}

.file-upload-clear {
  @apply w-full px-4 py-2 text-sm font-medium text-destructive border border-destructive rounded-lg;
  @apply hover:bg-destructive hover:text-destructive-foreground transition-colors;
}
</style>
