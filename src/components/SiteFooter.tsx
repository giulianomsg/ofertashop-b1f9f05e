import React, { useState, useEffect } from "react";
import { Link, useLocation } from "react-router-dom";
import { ShoppingBag, Shield, Lock, CreditCard, ExternalLink, Users, Phone, Target, Zap, LayoutDashboard, ChevronRight, ChevronLeft } from "lucide-react";
import { QRCodeSVG } from "qrcode.react";
import { useActiveSpecialPages, useWhatsAppGroups, useActiveInstitutionalPages } from "@/hooks/useEntities";

const SiteFooter = () => {
  const location = useLocation();
  const isAdminPath = location.pathname.startsWith('/admin');

  const { data: specialPages = [] } = useActiveSpecialPages();
  const { data: whatsappGroups = [] } = useWhatsAppGroups();
  const { data: institutionalPages = [] } = useActiveInstitutionalPages();
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
            <h3 className="font-display font-semibold text-primary-foreground mb-4">Navegação</h3>
            <ul className="space-y-3">
              <li>
                <Link to="/" className="text-primary-foreground/70 hover:text-primary-foreground transition-colors text-sm hover:translate-x-1 inline-block duration-200">
                  Início
                </Link>
              </li>
              {institutionalPages.map((page: any) => (
                <li key={page.id}>
                  <Link to={`/p/${page.slug}`} className="text-primary-foreground/70 hover:text-primary-foreground transition-colors text-sm hover:translate-x-1 inline-block duration-200">
                    {page.title}
                  </Link>
                </li>
              ))}
            </ul>
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
                  <div className="flex flex-wrap gap-2 mb-4">
                    {whatsappGroups.map((group, index) => (
                      <button
                        key={group.id}
                        onClick={() => setActiveGroupIndex(index)}
                        className={`px-3 py-1.5 rounded-lg text-xs font-semibold transition-colors ${
                          activeGroupIndex === index
                            ? "bg-accent text-accent-foreground"
                            : "bg-primary-foreground/10 hover:bg-primary-foreground/20 text-primary-foreground/80"
                        }`}
                        aria-label={`Selecionar grupo ${group.name}`}
                      >
                        {group.name}
                      </button>
                    ))}
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
