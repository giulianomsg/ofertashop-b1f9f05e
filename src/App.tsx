import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { AuthProvider } from "@/hooks/useAuth";
import { HelmetProvider } from "react-helmet-async";
import { useQueryDebug } from "@/hooks/useQueryDebug";
import Index from "./pages/Index";
import Coupons from "./pages/Coupons";
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
import AdminAmazon from "./pages/admin/AdminAmazon";
import AdminNatura from "./pages/admin/AdminNatura";
import AdminAISettings from "./pages/admin/AdminAISettings";
import AdminAPI from "./pages/admin/AdminAPI";
import SpecialPage from "./pages/SpecialPage";
import InstitutionalPage from "./pages/InstitutionalPage";
import NotFound from "./pages/NotFound";
import UserProfile from "./pages/UserProfile";

// AI Pro pages
import AdminAILayout from "./pages/admin/ai/AdminAILayout";
import AdminAIDashboard from "./pages/admin/ai/AdminAIDashboard";
import AdminAIGenerator from "./pages/admin/ai/AdminAIGenerator";
import AdminAIPersonas from "./pages/admin/ai/AdminAIPersonas";
import AdminAICampaigns from "./pages/admin/ai/AdminAICampaigns";
import AdminAIAutomations from "./pages/admin/ai/AdminAIAutomations";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5,
    },
  },
});

const AppContent = () => {
  useQueryDebug();

  return (
    <NotificationProvider>
      <TooltipProvider>
        <Toaster />
        <Sonner />
        <BrowserRouter>
          <Routes>
            <Route path="/" element={<Index />} />
            <Route path="/cupons" element={<Coupons />} />
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
              <Route path="amazon" element={<AdminAmazon />} />
              <Route path="natura" element={<AdminNatura />} />
              <Route path="whatsapp" element={<AdminWhatsApp />} />
              <Route path="newsletters" element={<AdminNewsletters />} />
              <Route path="ia" element={<AdminAISettings />} />
              <Route path="api" element={<AdminAPI />} />
              {/* AI Pro Module */}
              <Route path="ai" element={<AdminAILayout />}>
                <Route index element={<Navigate to="dashboard" replace />} />
                <Route path="dashboard" element={<AdminAIDashboard />} />
                <Route path="generator" element={<AdminAIGenerator />} />
                <Route path="personas" element={<AdminAIPersonas />} />
                <Route path="campaigns" element={<AdminAICampaigns />} />
                <Route path="automations" element={<AdminAIAutomations />} />
                <Route path="settings" element={<AdminAISettings />} />
              </Route>
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
