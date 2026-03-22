import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";
import path from "path";
import { componentTagger } from "lovable-tagger";

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => ({
  server: {
    host: "::",
    port: 8080,
    hmr: {
      overlay: false,
      // Desabilitar recarregamento completo em certos eventos
      // Apenas atualiza módulos específicos (Hot Module Replacement)
    },
  },
  plugins: [react(), mode === "development" && componentTagger()].filter(Boolean),
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  // Em desenvolvimento, desabilitar algumas features que podem causar recarregamento
  ...(mode === "development" && {
    // Configurações específicas para dev
    clearScreen: false,
  }),
}));
