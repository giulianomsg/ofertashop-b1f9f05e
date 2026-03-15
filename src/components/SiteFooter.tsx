import { ShoppingBag, Shield, Lock, CreditCard } from "lucide-react";
import { Link } from "react-router-dom";
import { QRCodeSVG } from "qrcode.react";
import { useActiveSpecialPages, useActiveWhatsAppGroup } from "@/hooks/useEntities";

const SiteFooter = () => {
  const { data: specialPages = [] } = useActiveSpecialPages();
  const { data: whatsappGroup } = useActiveWhatsAppGroup();

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
            {whatsappGroup ? (
              <>
                <h4 className="font-display font-semibold mb-3 text-sm">Grupo WhatsApp</h4>
                <p className="text-xs text-primary-foreground/60 mb-3">Escaneie o QR Code para entrar no nosso grupo de ofertas!</p>
                <a href={whatsappGroup.link} target="_blank" rel="noopener noreferrer" className="inline-block bg-primary-foreground/10 p-2 rounded-xl hover:bg-primary-foreground/20 transition-colors" aria-label="Entrar no grupo do WhatsApp">
                  <QRCodeSVG value={whatsappGroup.link} size={96} bgColor="transparent" fgColor="currentColor" className="text-primary-foreground" />
                </a>
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
