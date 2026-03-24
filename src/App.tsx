import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { AuthProvider } from "@/hooks/useAuth";
import { HelmetProvider } from "react-helmet-async";
import { useQueryDebug } from "@/hooks/useQueryDebug";
import Index from "./pages/Index";
import ProductDetail from "./pages/ProductDetail";
import { NotificationProvider } from "@/hooks/useNotifications";
import AdminLayout from "./pages/admin/AdminLayout";
import AdminDashboard from "./pages/admin/AdminDashboard";
import AdminProducts from "./pages/admin/AdminProducts";
import AdminBanners from "./pages/admin/AdminBanners";
import AdminCollaborators from "./pages/admin/AdminCollaborators";
import AdminReports from "./pages/admin/AdminReports";
import AdminStats from "./pages/admin/AdminStats";
import AdminUsers from "./pages/admin/AdminUsers";
import AdminReviews from "./pages/admin/AdminReviews";
import Login from "./pages/Login";
import AdminBrands from "./pages/admin/AdminBrands";
import AdminModels from "./pages/admin/AdminModels";
import AdminPlatforms from "./pages/admin/AdminPlatforms";
import AdminCategories from "./pages/admin/AdminCategories";
import AdminSpecialPages from "./pages/admin/AdminSpecialPages";
import AdminWhatsApp from "./pages/admin/AdminWhatsApp";
import AdminNewsletters from "./pages/admin/AdminNewsletters";
import AdminInstitutionalPages from "./pages/admin/AdminInstitutionalPages";
import AdminCoupons from "./pages/admin/AdminCoupons";
import AdminShopee from "./pages/admin/AdminShopee";
import AdminMercadoLivre from "./pages/admin/AdminMercadoLivre";
import SpecialPage from "./pages/SpecialPage";
import InstitutionalPage from "./pages/InstitutionalPage";
import NotFound from "./pages/NotFound";
import UserProfile from "./pages/UserProfile";
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // Considera os dados frescos por 5 minutos
    },
  },
});

const AppContent = () => {
  useQueryDebug();     // Debug para monitorar queries (remover em produção)

  return (
    <NotificationProvider>
      <TooltipProvider>
        <Toaster />
        <Sonner />
        <BrowserRouter>
          <Routes>
            <Route path="/" element={<Index />} />
            <Route path="/produto/:id" element={<ProductDetail />} />
            <Route path="/especial/:slug" element={<SpecialPage />} />
            <Route path="/p/:slug" element={<InstitutionalPage />} />
            <Route path="/perfil" element={<UserProfile />} />
            <Route path="/login" element={<Login />} />
            <Route path="/admin" element={<AdminLayout />}>
              <Route index element={<AdminDashboard />} />
              <Route path="banners" element={<AdminBanners />} />
              <Route path="produtos" element={<AdminProducts />} />
              <Route path="usuarios" element={<AdminUsers />} />
              <Route path="colaboradores" element={<AdminCollaborators />} />
              <Route path="avaliacoes" element={<AdminReviews />} />
              <Route path="denuncias" element={<AdminReports />} />
              <Route path="estatisticas" element={<AdminStats />} />
              <Route path="marcas" element={<AdminBrands />} />
              <Route path="modelos" element={<AdminModels />} />
              <Route path="plataformas" element={<AdminPlatforms />} />
              <Route path="categorias" element={<AdminCategories />} />
              <Route path="paginas-especiais" element={<AdminSpecialPages />} />
              <Route path="paginas-institucionais" element={<AdminInstitutionalPages />} />
              <Route path="cupons" element={<AdminCoupons />} />
              <Route path="shopee" element={<AdminShopee />} />
              <Route path="mercadolivre" element={<AdminMercadoLivre />} />
              <Route path="whatsapp" element={<AdminWhatsApp />} />
              <Route path="newsletters" element={<AdminNewsletters />} />
            </Route>
            <Route path="*" element={<NotFound />} />
          </Routes>
        </BrowserRouter>
      </TooltipProvider>
    </NotificationProvider>
  );
};

const App = () => (
  <HelmetProvider>
    <QueryClientProvider client={queryClient}>
      <AuthProvider>
        <AppContent />
      </AuthProvider>
    </QueryClientProvider>
  </HelmetProvider>
);

export default App;
