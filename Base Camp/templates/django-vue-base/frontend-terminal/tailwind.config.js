/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        'roadmap-dark': '#0f172a',  // Slate 900
        'roadmap-card': '#1e293b',  // Slate 800
        'roadmap-accent': '#10b981', // Emerald 500 (Season 1 Mastery Green)
      }
    },
  },
  plugins: [],
}