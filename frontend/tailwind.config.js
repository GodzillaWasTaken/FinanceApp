// frontend/tailwind.config.js
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: [
          "system-ui",          // usa il font del sistema operativo
          "-apple-system",      // San Francisco (macOS, iOS)
          "BlinkMacSystemFont", // Chrome macOS
          "Segoe UI",           // Windows
          "Roboto",             // Android
          "Helvetica Neue",     // macOS vecchi
          "Helvetica",          // macOS più vecchi
          "Arial",              // fallback Windows
          "sans-serif",         // fallback generico
        ],
      },
    },
  },
  plugins: [],
}