import { useState, useRef } from "react";
import { Plus, Trash2, Upload, Loader2 } from "lucide-react";
import { usePlatforms, useCreatePlatform, useDeletePlatform } from "@/hooks/useEntities";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

const AdminPlatforms = () => {
  const { data: platforms = [], isLoading } = usePlatforms();
  const createPlatform = useCreatePlatform();
  const deletePlatform = useDeletePlatform();
  const [name, setName] = useState("");
  const [logoUrl, setLogoUrl] = useState("");
  const [uploading, setUploading] = useState(false);
  const fileRef = useRef<HTMLInputElement>(null);

  const handleLogoUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setUploading(true);
    try {
      const ext = file.name.split(".").pop() || "png";
      const fileName = `platform-${Date.now()}.${ext}`;
      const { error } = await supabase.storage.from("product-images").upload(fileName, file, { contentType: file.type });
      if (error) throw error;
      const { data } = supabase.storage.from("product-images").getPublicUrl(fileName);
      setLogoUrl(data.publicUrl);
      toast.success("Logo enviado!");
    } catch { toast.error("Erro ao enviar logo."); }
    finally { setUploading(false); if (fileRef.current) fileRef.current.value = ""; }
  };

  const handleCreate = async () => {
    if (!name.trim()) return toast.error("Informe o nome da plataforma.");
    try {
      await createPlatform.mutateAsync({ name: name.trim(), logo_url: logoUrl || undefined });
      setName(""); setLogoUrl("");
      toast.success("Plataforma criada!");
    } catch { toast.error("Erro ao criar plataforma."); }
  };

  return (
    <div className="space-y-6">
      <h2 className="font-display font-bold text-xl text-foreground">Plataformas</h2>
      <div className="space-y-3">
        <div className="flex gap-2">
          <input value={name} onChange={(e) => setName(e.target.value)} onKeyDown={(e) => e.key === "Enter" && handleCreate()} placeholder="Nome (ex: Amazon, Shopee)" className="flex-1 h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" />
          <button onClick={handleCreate} disabled={createPlatform.isPending} className="btn-accent flex items-center gap-2 text-sm" aria-label="Adicionar plataforma"><Plus className="w-4 h-4" /> Adicionar</button>
        </div>
        <div className="flex items-center gap-2">
          {logoUrl && <img src={logoUrl} alt="Logo preview" className="w-8 h-8 rounded object-contain bg-secondary" />}
          <input ref={fileRef} type="file" accept="image/*" onChange={handleLogoUpload} className="hidden" />
          <button onClick={() => fileRef.current?.click()} disabled={uploading} className="h-9 px-3 rounded-lg border border-dashed border-border text-sm text-muted-foreground flex items-center gap-2 hover:bg-secondary transition-colors">
            {uploading ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : <Upload className="w-3.5 h-3.5" />} Logo (opcional)
          </button>
        </div>
      </div>
      <div className="bg-card rounded-xl border border-border overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
        <table className="w-full text-sm">
          <thead><tr className="border-b border-border bg-secondary"><th className="text-left p-4 font-semibold text-foreground">Plataforma</th><th className="text-left p-4 font-semibold text-foreground">Logo</th><th className="text-right p-4 font-semibold text-foreground">Ações</th></tr></thead>
          <tbody>
            {isLoading ? <tr><td colSpan={3} className="p-8 text-center text-muted-foreground">Carregando...</td></tr> :
              platforms.length === 0 ? <tr><td colSpan={3} className="p-8 text-center text-muted-foreground">Nenhuma plataforma.</td></tr> :
                platforms.map((p) => (
                  <tr key={p.id} className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors">
                    <td className="p-4 text-foreground">{p.name}</td>
                    <td className="p-4">{p.logo_url ? <img src={p.logo_url} alt={p.name} className="w-6 h-6 rounded object-contain" /> : <span className="text-muted-foreground">—</span>}</td>
                    <td className="p-4 text-right"><button onClick={async () => { if (!confirm("Excluir?")) return; try { await deletePlatform.mutateAsync(p.id); toast.success("Excluída."); } catch { toast.error("Erro."); } }} className="p-2 rounded-lg hover:bg-destructive/10 transition-colors" aria-label="Excluir plataforma"><Trash2 className="w-4 h-4 text-destructive" /></button></td>
                  </tr>
                ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default AdminPlatforms;
