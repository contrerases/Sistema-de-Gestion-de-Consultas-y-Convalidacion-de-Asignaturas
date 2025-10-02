<script setup>
import { ref } from 'vue';
import ToogleTheme from '@/shared/components/ui/ToogleTheme.vue';
import Button from '@/shared/components/ui/Button.vue';

const clickCount = ref(0);

const handleClick = () => {
    clickCount.value++;
};
</script>

<template>
    <div class="min-h-screen bg-background text-foreground p-8">
        <div class="max-w-4xl mx-auto space-y-8">
            <!-- Header -->
            <div class="flex justify-between items-center mb-8">
                <h1 class="text-3xl font-bold">Variantes de Button</h1>
                <ToogleTheme />
            </div>

            <!-- Contador de clicks -->
            <div class="p-4 bg-card rounded-lg border border-border">
                <p class="text-sm text-muted-foreground">Clicks totales: <span class="font-bold text-foreground">{{
                        clickCount }}</span></p>
            </div>

            <!-- Variante: Default -->
            <div class="space-y-2">
                <h2 class="text-xl font-semibold">Default</h2>
                <div class="flex gap-3 flex-wrap">
                    <Button variant="default" @click="handleClick">Click me</Button>
                    <Button variant="default" :disabled="true">Disabled</Button>
                    <Button variant="default" @click="handleClick">
                        <template #left>
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M12 4v16m8-8H4" />
                            </svg>
                        </template>
                        Con ícono izquierdo
                    </Button>
                    <Button variant="default" @click="handleClick">
                        Con ícono derecho
                        <template #right>
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M9 5l7 7-7 7" />
                            </svg>
                        </template>
                    </Button>
                    

                </div>
            </div>

            <!-- Variante: Destructive -->
            <div class="space-y-2">
                <h2 class="text-xl font-semibold">Destructive</h2>
                <div class="flex gap-3 flex-wrap">
                    <Button variant="destructive" @click="handleClick">Delete</Button>
                    <Button variant="destructive" :disabled="true">Disabled</Button>
                    <Button variant="destructive" @click="handleClick">
                        <template #left>
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                            </svg>
                        </template>
                        Eliminar
                    </Button>
                </div>
            </div>

            <!-- Variante: Outlined -->
            <div class="space-y-2">
                <h2 class="text-xl font-semibold">Outlined</h2>
                <div class="flex gap-3 flex-wrap">
                    <Button variant="outlined" @click="handleClick">Outlined</Button>
                    <Button variant="outlined" :disabled="true">Disabled</Button>
                    <Button variant="outlined" @click="handleClick">
                        <template #left>
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
                            </svg>
                        </template>
                        Compartir
                    </Button>
                </div>
            </div>

            <!-- Variante: Ghost -->
            <div class="space-y-2">
                <h2 class="text-xl font-semibold">Ghost</h2>
                <div class="flex gap-3 flex-wrap">
                    <Button variant="ghost" @click="handleClick">Ghost</Button>
                    <Button variant="ghost" :disabled="true">Disabled</Button>
                    <Button variant="ghost" @click="handleClick">
                        <template #left>
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                            </svg>
                        </template>
                        Configuración
                    </Button>
                </div>
            </div>
        </div>
    </div>
</template>