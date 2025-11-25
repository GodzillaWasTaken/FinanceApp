<script setup>

/**
 * Base button component that can render as different HTML elements or components.
 * It uses the `as` prop to determine the tag or component to render.
 * It also forwards all additional attributes to the rendered component.
 * Example usage:
 * <BaseButton as="a" href="/home">Link Button</BaseButton>, or Routerlink 
 * <BaseButton as="button" @click="handleClick">Click Me</BaseButton>
 */

import { ref } from 'vue'
const props = defineProps({
  as: {
    type: [String, Object],
    default: 'button'
  }
});
const emit = defineEmits(['click']);
const buttonRef = ref(null);

defineExpose({
  focus: () => buttonRef.value?.focus()
});
</script>

<template>
  <!-- recive from prop the tag it has to become -->
   <!-- v-bind used to pass props to the components that comes from base button,
    they can now recive all the props that are not decleared, as in add button to="/page" prop or the funciont it has to call on the click-->
  <component
    :is="as"
    ref="buttonRef"
    v-bind="$attrs"
    class="base-button"
    @click="emit('click')"
  >
    <slot />
  </component>
</template>

<style scoped>
.base-button {
  border-radius: 10px;
  cursor: pointer;
  font-size: small;
}
</style>
