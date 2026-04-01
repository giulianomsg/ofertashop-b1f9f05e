import { useState, useEffect } from "react";
import { Plus, Trash2, Pencil, Check, X, GripVertical, Image as ImageIcon } from "lucide-react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import { DndContext, closestCenter, KeyboardSensor, PointerSensor, useSensor, useSensors } from "@dnd-kit/core";
import { SortableContext, verticalListSortingStrategy, sortableKeyboardCoordinates } from "@dnd-kit/sortable";
import { useSortable } from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";

// Sortable Item Component
const SortableLink = ({ link, onEdit, onDelete, toggleActive }: any) => {
  const { attributes, listeners, setNodeRef, transform, transition, isDragging } = useSortable({ id: link.id });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    zIndex: isDragging ? 2 : 1,
    boxShadow: isDragging ? "var(--shadow-lg)" : "none",
  };

  return (
    <div ref={setNodeRef} style={style} className={`flex items-center gap-3 p-4 bg-card rounded-xl border border-border ${isDragging ? 'opacity-70 bg-secondary' : ''}`}>
      <div {...attributes} {...listeners} className="cursor-grab hover:bg-secondary p-1 rounded">
        <GripVertical className="w-5 h-5 text-muted-foreground" />
      </div>
      <div className="flex-1 min-w-0">
        <h4 className="font-semibold text-sm truncate text-foreground">{link.title}</h4>
        <p className="text-xs text-muted-foreground truncate">{link.url}</p>
      </div>
      <div className="flex items-center gap-2">
        <button
          onClick={() => toggleActive(link)}
          className={`px-3 py-1 rounded-full text-xs font-medium transition-colors ${link.is_active ? 'bg-success/10 text-success' : 'bg-secondary text-muted-foreground'}`}
        >
          {link.is_active ? 'Ativo' : 'Inativo'}
        </button>
        <button onClick={() => onEdit(link)} className="p-2 rounded-lg hover:bg-secondary transition-colors" aria-label="Editar">
          <Pencil className="w-4 h-4 text-muted-foreground" />
        </button>
        <button onClick={() => onDelete(link.id)} className="p-2 rounded-lg hover:bg-destructive/10 transition-colors" aria-label="Excluir">
          <Trash2 className="w-4 h-4 text-destructive" />
        </button>
      </div>
    </div>
  );
};

const AdminLinks = () => {
  const queryClient = useQueryClient();
  const [editingId, setEditingId] = useState<string | null>(null);
  
  // Form State
  const [title, setTitle] = useState("");
  const [url, setUrl] = useState("");
  const [logoUrl, setLogoUrl] = useState("");
  
  // Fetch Logo
  const { data: siteLogo } = useQuery({
    queryKey: ['siteSettings', 'site_logo'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('admin_settings')
        .select('value')
        .eq('key', 'site_logo')
        .maybeSingle();
      if (error) throw error;
      return data?.value ? String(data.value).replace(/['"]/g, '') : '';
    }
  });

  useEffect(() => {
    if (siteLogo !== undefined) {
      setLogoUrl(siteLogo);
    }
  }, [siteLogo]);

  // Update Logo
  const updateLogoMutation = useMutation({
    mutationFn: async (newLogoUrl: string) => {
      const { error } = await supabase
        .from('admin_settings')
        .upsert({ key: 'site_logo', value: `"${newLogoUrl}"` }, { onConflict: 'key' });
      if (error) throw error;
    },
    onSuccess: () => {
      toast.success("Logo atualizada!");
      queryClient.invalidateQueries({ queryKey: ['siteSettings', 'site_logo'] });
    },
    onError: () => toast.error("Erro ao atualizar logo")
  });

  // Fetch Links
  const { data: links = [], isLoading } = useQuery({
    queryKey: ['adminLinks'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('links')
        .select('*')
        .order('sort_order', { ascending: true });
      if (error) throw error;
      return data || [];
    }
  });

  // Create Link
  const createLinkMutation = useMutation({
    mutationFn: async ({ title, url, sort_order }: { title: string, url: string, sort_order: number }) => {
      const { error } = await supabase
        .from('links')
        .insert([{ title, url, sort_order }]);
      if (error) throw error;
    },
    onSuccess: () => {
      toast.success("Link adicionado!");
      setTitle("");
      setUrl("");
      queryClient.invalidateQueries({ queryKey: ['adminLinks'] });
    },
    onError: () => toast.error("Erro ao adicionar link")
  });

  // Update Link
  const updateLinkMutation = useMutation({
    mutationFn: async ({ id, ...updates }: any) => {
      const { error } = await supabase
        .from('links')
        .update(updates)
        .eq('id', id);
      if (error) throw error;
    },
    onSuccess: () => {
      toast.success("Link atualizado!");
      setEditingId(null);
      setTitle("");
      setUrl("");
      queryClient.invalidateQueries({ queryKey: ['adminLinks'] });
    },
    onError: () => toast.error("Erro ao atualizar link")
  });

  // Delete Link
  const deleteLinkMutation = useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from('links').delete().eq('id', id);
      if (error) throw error;
    },
    onSuccess: () => {
      toast.success("Link excluído!");
      queryClient.invalidateQueries({ queryKey: ['adminLinks'] });
    },
    onError: () => toast.error("Erro ao excluir link")
  });

  // Reorder Links
  const reorderLinksMutation = useMutation({
    mutationFn: async (newOrder: {id: string, sort_order: number}[]) => {
      // Supabase has no bulk update by default, so we do it one by one or create a rpc
      for (const item of newOrder) {
        await supabase.from('links').update({ sort_order: item.sort_order }).eq('id', item.id);
      }
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['adminLinks'] });
    }
  });

  const handleCreateOrUpdate = () => {
    if (!title.trim() || !url.trim()) return toast.warning("Preencha título e URL.");
    
    // Ensure URL has http/https
    let finalUrl = url.trim();
    if (!finalUrl.startsWith('http://') && !finalUrl.startsWith('https://')) {
      finalUrl = 'https://' + finalUrl;
    }

    if (editingId) {
      updateLinkMutation.mutate({ id: editingId, title: title.trim(), url: finalUrl });
    } else {
      createLinkMutation.mutate({ title: title.trim(), url: finalUrl, sort_order: links.length });
    }
  };

  const handleEdit = (link: any) => {
    setEditingId(link.id);
    setTitle(link.title);
    setUrl(link.url);
  };

  const cancelEdit = () => {
    setEditingId(null);
    setTitle("");
    setUrl("");
  };

  const handleDelete = (id: string) => {
    if (confirm("Deseja realmente excluir este link?")) {
      deleteLinkMutation.mutate(id);
    }
  };

  const toggleActive = (link: any) => {
    updateLinkMutation.mutate({ id: link.id, is_active: !link.is_active });
  };

  // Drag and drop setup
  const sensors = useSensors(
    useSensor(PointerSensor, { activationConstraint: { distance: 5 } }),
    useSensor(KeyboardSensor, { coordinateGetter: sortableKeyboardCoordinates })
  );

  const handleDragEnd = (event: any) => {
    const { active, over } = event;
    if (!over || active.id === over.id) return;
    
    const oldIndex = links.findIndex(l => l.id === active.id);
    const newIndex = links.findIndex(l => l.id === over.id);
    
    const newArray = [...links];
    const [movedElement] = newArray.splice(oldIndex, 1);
    newArray.splice(newIndex, 0, movedElement);
    
    // Optimistic update
    queryClient.setQueryData(['adminLinks'], newArray);
    
    // Persist to db
    const updates = newArray.map((item, index) => ({ id: item.id, sort_order: index }));
    reorderLinksMutation.mutate(updates);
  };

  const handleLogoUpdate = () => {
    updateLogoMutation.mutate(logoUrl);
  };

  return (
    <div className="space-y-8 max-w-4xl mx-auto pb-12">
      <div className="flex items-center justify-between">
         <h2 className="font-display font-bold text-2xl text-foreground">Árvore de Links (Linktree)</h2>
         <a href="/links" target="_blank" className="text-sm font-medium text-accent hover:underline flex items-center gap-1">
             Ver Página
         </a>
      </div>

      {/* Identidade Visual */}
      <div className="bg-card rounded-xl border border-border p-6 shadow-sm space-y-4">
        <h3 className="font-semibold text-lg flex items-center gap-2">
            <ImageIcon className="w-5 h-5 text-accent" />
            Identidade da Página
        </h3>
        <div className="flex gap-4 items-end">
            <div className="flex-1 space-y-2">
                <label className="text-sm font-medium">URL da Logo do Site</label>
                <input 
                    value={logoUrl} 
                    onChange={(e) => setLogoUrl(e.target.value)} 
                    placeholder="https://exemplo.com/logo.png" 
                    className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:ring-2 focus:ring-accent/30" 
                />
            </div>
            <button 
                onClick={handleLogoUpdate} 
                disabled={updateLogoMutation.isPending} 
                className="btn-accent h-10 px-6 font-medium text-sm whitespace-nowrap"
            >
                {updateLogoMutation.isPending ? "Salvando..." : "Salvar Logo"}
            </button>
        </div>
        {logoUrl && (
            <div className="mt-4 p-4 border border-border rounded-lg bg-secondary/30 flex items-center justify-center">
                <img src={logoUrl} alt="Logo Preview" className="max-h-24 object-contain" />
            </div>
        )}
      </div>

      {/* Adicionar / Editar Link */}
      <div className="bg-card rounded-xl border border-border p-6 shadow-sm space-y-4">
        <h3 className="font-semibold text-lg">{editingId ? "Editar Link" : "Novo Link"}</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="space-y-2">
                <label className="text-sm font-medium">Título</label>
                <input 
                    value={title} 
                    onChange={(e) => setTitle(e.target.value)} 
                    placeholder="Ex: Ofertas do Dia" 
                    className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:ring-2 focus:ring-accent/30" 
                />
            </div>
            <div className="space-y-2">
                <label className="text-sm font-medium">URL</label>
                <input 
                    value={url} 
                    onChange={(e) => setUrl(e.target.value)} 
                    placeholder="https://..." 
                    className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:ring-2 focus:ring-accent/30" 
                    onKeyDown={(e) => e.key === "Enter" && handleCreateOrUpdate()}
                />
            </div>
        </div>
        <div className="flex gap-2 justify-end pt-2">
            {editingId && (
                <button onClick={cancelEdit} className="h-10 px-6 rounded-lg font-medium text-sm bg-secondary text-foreground hover:bg-secondary/80 transition-colors">
                    Cancelar
                </button>
            )}
            <button 
                onClick={handleCreateOrUpdate} 
                className="btn-accent h-10 px-6 font-medium text-sm flex items-center gap-2"
                disabled={createLinkMutation.isPending || updateLinkMutation.isPending}
            >
                {editingId ? <Check className="w-4 h-4" /> : <Plus className="w-4 h-4" />}
                {editingId ? "Salvar Alterações" : "Adicionar Link"}
            </button>
        </div>
      </div>

      {/* Lista de Links Ordenável */}
      <div className="space-y-3">
        <h3 className="font-semibold text-lg">Links Adicionados ({links.length})</h3>
        {isLoading ? (
            <div className="p-8 text-center text-muted-foreground animate-pulse bg-card rounded-xl border border-border">Carregando links...</div>
        ) : links.length === 0 ? (
            <div className="p-8 text-center text-muted-foreground bg-card rounded-xl border border-border">Nenhum link adicionado ainda.</div>
        ) : (
            <DndContext sensors={sensors} collisionDetection={closestCenter} onDragEnd={handleDragEnd}>
                <SortableContext items={links.map(l => l.id)} strategy={verticalListSortingStrategy}>
                    <div className="space-y-3">
                        {links.map((link) => (
                            <SortableLink 
                                key={link.id} 
                                link={link} 
                                onEdit={handleEdit} 
                                onDelete={handleDelete}
                                toggleActive={toggleActive}
                            />
                        ))}
                    </div>
                </SortableContext>
            </DndContext>
        )}
      </div>
    </div>
  );
};

export default AdminLinks;
