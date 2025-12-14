/**
 * composable with funcion used to access screen size and type of device to handle responsive behavior
 * when simple css properties are not enough, for example while using v-if conditionals in vue templates
 * 
 * Returns:
 * - isMobile: boolean ref indicating if the device is mobile (width < breakpoint)
 * - isDesktop: boolean ref indicating if the device is desktop (width >= breakpoint)
 * - deviceType: computed ref returning 'mobile' or 'desktop' based on the current width
 * - width: ref containing the current window width
 * 
 * Usage:
 * import { useDeviceDetection } from '@/composables/useScreenDetection';
 * const { isMobile, isDesktop, deviceType, width } = useDeviceDetection();
 * 
 * Note: The breakpoint is set to 768 pixels, corresponding to the 'md' Tailwind CSS breakpoint.
 */

import { ref, onMounted, onUnmounted, computed } from 'vue';

const breakpoint = 768;

export function useDeviceDetection() {
  const width = ref(window.innerWidth);

  const updateWidth = () => {
    width.value = window.innerWidth;
  };

  onMounted(() => {
    window.addEventListener('resize', updateWidth);
  });

  onUnmounted(() => {
    window.removeEventListener('resize', updateWidth);
  });

  const isMobile = computed(() => width.value < breakpoint);
  const isDesktop = computed(() => width.value >= breakpoint);
  
  const deviceType = computed(() => isMobile.value ? 'mobile' : 'desktop');

  return { 
    isMobile, 
    isDesktop,
    deviceType, 
    width 
  };
}