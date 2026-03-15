import { ShoppingBag, Shield, Lock, CreditCard, ChevronLeft, ChevronRight } from "lucide-react";
import { Link } from "react-router-dom";
import { QRCodeSVG } from "qrcode.react";
import { useState } from "react";
import { useActiveSpecialPages, useActiveWhatsAppGroups } from "@/hooks/useEntities";

const SiteFooter = () => {
  const { data: specialPages = [] } = useActiveSpecialPages();
  const { data: whatsappGroups = [] } = useActiveWhatsAppGroups();
  const [activeGroupIndex, setActiveGroupIndex] = useState(0);

  return (
    <footer className="bg-primary text-primary-foreground mt-16">
      <div className="container mx-auto px-4 lg:px-8 py-12">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-8 mb-10">
          <div>
            <div className="flex items-center gap-2 mb-4">
              <div className="w-7 h-7 rounded-lg bg-accent flex items-center justify-center">
                <ShoppingBag className="w-3.5 h-3.5 text-accent-foreground" />
              </div>
              <span className="font-display font-bold text-lg">OfertaShop</span>
            </div>
            <p className="text-sm text-primary-foreground/60">As melhores ofertas da internet, verificadas e atualizadas diariamente.</p>
          </div>
          <div>
            <h4 className="font-display font-semibold mb-3 text-sm">Navegação</h4>
            <div className="space-y-2 text-sm text-primary-foreground/60">
              <Link to="/" className="block hover:text-primary-foreground transition-colors">Início</Link>
              <Link to="/" className="block hover:text-primary-foreground transition-colors">Categorias</Link>
              <Link to="/" className="block hover:text-primary-foreground transition-colors">Mais Clicados</Link>
            </div>
          </div>
          <div>
            <h4 className="font-display font-semibold mb-3 text-sm">
              {specialPages.length > 0 ? "Páginas Especiais" : "Suporte"}
            </h4>
            <div className="space-y-2 text-sm text-primary-foreground/60">
              {specialPages.length > 0 ? (
                specialPages.map((page) => (
                  <Link key={page.id} to={`/especial/${page.slug}`} className="block hover:text-primary-foreground transition-colors">
                    {page.title}
                  </Link>
                ))
              ) : (
                <>
                  <Link to="/" className="block hover:text-primary-foreground transition-colors">Central de Ajuda</Link>
                  <Link to="/" className="block hover:text-primary-foreground transition-colors">Termos de Uso</Link>
                  <Link to="/" className="block hover:text-primary-foreground transition-colors">Política de Privacidade</Link>
                </>
              )}
            </div>
          </div>
          <div>
            {whatsappGroups.length > 0 ? (
              <>
                <h4 className="font-display font-semibold mb-3 text-sm">Grupos de WhatsApp</h4>
                <p className="text-xs text-primary-foreground/60 mb-3">
                  Escaneie o QR Code para entrar no {whatsappGroups[activeGroupIndex]?.name}!
                </p>
                
                {whatsappGroups.length > 1 && (
                  <div className="flex items-center gap-2 mb-3">
                    <button
                      onClick={() => setActiveGroupIndex(prev => prev === 0 ? whatsappGroups.length - 1 : prev - 1)}
                      className="p-1 rounded-full bg-primary-foreground/10 hover:bg-primary-foreground/20 transition-colors disabled:opacity-50"
                      aria-label="Grupo anterior"
                    >
                      <ChevronLeft className="w-4 h-4" />
                    </button>
                    <span className="text-sm font-medium flex-1 text-center truncate px-2">
                      {whatsappGroups[activeGroupIndex]?.name}
                    </span>
                    <button
                      onClick={() => setActiveGroupIndex(prev => prev === whatsappGroups.length - 1 ? 0 : prev + 1)}
                      className="p-1 rounded-full bg-primary-foreground/10 hover:bg-primary-foreground/20 transition-colors disabled:opacity-50"
                      aria-label="Próximo grupo"
                    >
                      <ChevronRight className="w-4 h-4" />
                    </button>
                  </div>
                )}

                <div className="flex justify-center md:justify-start">
                  <a href={whatsappGroups[activeGroupIndex]?.link} target="_blank" rel="noopener noreferrer" className="inline-block bg-primary-foreground/10 p-2 rounded-xl hover:bg-primary-foreground/20 transition-colors" aria-label={`Entrar no grupo ${whatsappGroups[activeGroupIndex]?.name}`}>
                    <QRCodeSVG value={whatsappGroups[activeGroupIndex]?.link || ""} size={96} bgColor="transparent" fgColor="currentColor" className="text-primary-foreground" />
                  </a>
                </div>
              </>
            ) : (
              <>
                <h4 className="font-display font-semibold mb-3 text-sm">Segurança</h4>
                <div className="flex flex-wrap gap-3 mt-2">
                  {[Shield, Lock, CreditCard].map((Icon, i) => (
                    <div key={i} className="w-10 h-10 rounded-lg bg-primary-foreground/10 flex items-center justify-center">
                      <Icon className="w-4 h-4 text-primary-foreground/60" />
                    </div>
                  ))}
                </div>
              </>
            )}
          </div>
        </div>
        <div className="border-t border-primary-foreground/10 pt-6 text-center text-xs text-primary-foreground/40">
          © 2026 OfertaShop. Todos os direitos reservados.
        </div>
      </div>
    </footer>
  );
};

export default SiteFooter;
