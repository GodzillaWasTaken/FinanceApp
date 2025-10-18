<script setup>
import { Switch } from '@headlessui/vue';

defineProps({
    defaultMenuOpen: {
        type: Boolean,
        required: true
    }
});

const emit = defineEmits(['update:defaultMenuOpen']); 

function toggleMenu(newValue) {
    emit('update:defaultMenuOpen', newValue);
}
</script>

<template>
        <section class="flex-1 bg-background h-full px-6 md:px-50 2xl:px-150 pt-10 pb-6">
            <div class = "flex flex-col bg-white rounded-[10px] shadow-lg ">
                <div>
                    <div class="text-text m-6 text-xl font-bold">Menu</div>
                    <div class="flex text-text m-6 gap-6 items-center">
                        <div>Menu fisso (su desktop)</div>
                         <Switch
                            :modelValue="defaultMenuOpen"
                            @update:modelValue="toggleMenu"
                            :class="[
                                defaultMenuOpen ? 'bg-primary-light' : 'bg-gray-300',
                                'relative inline-flex h-6 w-11 items-center rounded-full transition-colors cursor-pointer'
                            ]"
                            >
                            <span
                                :class="[
                                defaultMenuOpen ? 'translate-x-6' : 'translate-x-1',
                                'inline-block h-4 w-4 transform rounded-full bg-white transition-transform duration-300'
                                ]"
                            />
                        </Switch>
                    </div>
                </div>
            </div>
        </section>
</template>