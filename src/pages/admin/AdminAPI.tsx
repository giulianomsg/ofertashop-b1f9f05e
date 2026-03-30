import { useState, useCallback } from "react";
import {
  Plus,
  Copy,
  Check,
  Pencil,
  Eye,
  EyeOff,
  Code,
  Activity,
  RefreshCw,
  X,
  Webhook,
  Shield,
  Clock,
  AlertCircle,
  CheckCircle2,
  XCircle,
} from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
  DialogDescription,
} from "@/components/ui/dialog";
import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
  SheetDescription,
} from "@/components/ui/sheet";
import { Switch } from "@/components/ui/switch";
import { Badge } from "@/components/ui/badge";
import { Checkbox } from "@/components/ui/checkbox";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";

// ----------------------------------------------------------
// Types
// ----------------------------------------------------------
interface ApiClient {
  id: string;
  client_name: string;
  api_key: string;
  webhook_url: string | null;
  webhook_events: string[];
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

interface WebhookLog {
  id: string;
  api_client_id: string;
  endpoint_url: string;
  payload: Record<string, unknown>;
  status_code: number | null;
  response_body?: string;
  created_at: string;
}

interface NewClientForm {
  client_name: string;
  webhook_url: string;
  webhook_events: string[];
}

interface EditWebhookForm {
  webhook_url: string;
  webhook_events: string[];
}

// Available webhook events
const AVAILABLE_EVENTS = [
  { value: "offer.updated", label: "Oferta Atualizada" },
  { value: "offer.created", label: "Oferta Criada" },
  { value: "offer.deleted", label: "Oferta Removida" },
];

// ----------------------------------------------------------
// Data Hooks
// ----------------------------------------------------------
function useApiClients() {
  return useQuery<ApiClient[]>({
    queryKey: ["api-clients"],
    queryFn: async () => {
      const { data, error } = await supabase
        .from("api_clients")
        .select("*")
        .order("created_at", { ascending: false });

      if (error) throw error;
      return (data ?? []) as ApiClient[];
    },
  });
}

function useWebhookLogs(clientId: string | null) {
  return useQuery<WebhookLog[]>({
    queryKey: ["webhook-logs", clientId],
    enabled: !!clientId,
    queryFn: async () => {
      if (!clientId) return [];
      const { data, error } = await supabase
        .from("webhook_logs")
        .select("*")
        .eq("api_client_id", clientId)
        .order("created_at", { ascending: false })
        .limit(50);

      if (error) throw error;
      return (data ?? []) as WebhookLog[];
    },
  });
}

// ----------------------------------------------------------
// Utility: Generate API Key
// ----------------------------------------------------------
function generateApiKey(): string {
  const prefix = "ofsh";
  const uuid1 = crypto.randomUUID().replace(/-/g, "");
  const uuid2 = crypto.randomUUID().replace(/-/g, "").substring(0, 16);
  return `${prefix}_${uuid1}${uuid2}`;
}

// ----------------------------------------------------------
// Utility: Obfuscate API Key
// ----------------------------------------------------------
function obfuscateKey(key: string): string {
  if (key.length <= 12) return "••••••••••••";
  return `${key.substring(0, 8)}${"•".repeat(24)}${key.substring(key.length - 4)}`;
}

// ----------------------------------------------------------
// Utility: Format date
// ----------------------------------------------------------
function formatDate(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString("pt-BR", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

// ----------------------------------------------------------
// Component
// ----------------------------------------------------------
const AdminAPI = () => {
  const queryClient = useQueryClient();
  const { data: clients = [], isLoading } = useApiClients();

  // Dialog: New Client
  const [isNewClientOpen, setIsNewClientOpen] = useState(false);
  const [newClientForm, setNewClientForm] = useState<NewClientForm>({
    client_name: "",
    webhook_url: "",
    webhook_events: ["offer.updated"],
  });

  // Dialog: Edit Webhook
  const [isEditWebhookOpen, setIsEditWebhookOpen] = useState(false);
  const [editingClient, setEditingClient] = useState<ApiClient | null>(null);
  const [editWebhookForm, setEditWebhookForm] = useState<EditWebhookForm>({
    webhook_url: "",
    webhook_events: [],
  });

  // Sheet: Webhook Logs
  const [isLogsOpen, setIsLogsOpen] = useState(false);
  const [selectedClientForLogs, setSelectedClientForLogs] = useState<ApiClient | null>(null);
  const { data: logs = [], isLoading: isLogsLoading } = useWebhookLogs(
    selectedClientForLogs?.id ?? null,
  );

  // Visibility toggle for API keys
  const [visibleKeys, setVisibleKeys] = useState<Set<string>>(new Set());
  const [copiedKey, setCopiedKey] = useState<string | null>(null);

  // ----------------------------------------------------------
  // Mutations
  // ----------------------------------------------------------
  const createClientMutation = useMutation({
    mutationFn: async (form: NewClientForm) => {
      const apiKey = generateApiKey();
      const { error } = await supabase.from("api_clients").insert({
        client_name: form.client_name.trim(),
        api_key: apiKey,
        webhook_url: form.webhook_url.trim() || null,
        webhook_events: form.webhook_events,
      });
      if (error) throw error;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["api-clients"] });
      toast.success("Cliente API criado com sucesso!");
      setIsNewClientOpen(false);
      setNewClientForm({
        client_name: "",
        webhook_url: "",
        webhook_events: ["offer.updated"],
      });
    },
    onError: () => {
      toast.error("Erro ao criar cliente API.");
    },
  });

  const toggleActiveMutation = useMutation({
    mutationFn: async ({ id, is_active }: { id: string; is_active: boolean }) => {
      const { error } = await supabase
        .from("api_clients")
        .update({ is_active, updated_at: new Date().toISOString() })
        .eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["api-clients"] });
    },
    onError: () => {
      toast.error("Erro ao alterar status.");
    },
  });

  const updateWebhookMutation = useMutation({
    mutationFn: async ({
      id,
      form,
    }: {
      id: string;
      form: EditWebhookForm;
    }) => {
      const { error } = await supabase
        .from("api_clients")
        .update({
          webhook_url: form.webhook_url.trim() || null,
          webhook_events: form.webhook_events,
          updated_at: new Date().toISOString(),
        })
        .eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["api-clients"] });
      toast.success("Webhook atualizado!");
      setIsEditWebhookOpen(false);
      setEditingClient(null);
    },
    onError: () => {
      toast.error("Erro ao atualizar webhook.");
    },
  });

  // ----------------------------------------------------------
  // Handlers
  // ----------------------------------------------------------
  const handleCopyKey = useCallback(async (key: string, clientId: string) => {
    try {
      await navigator.clipboard.writeText(key);
      setCopiedKey(clientId);
      toast.success("API Key copiada!");
      setTimeout(() => setCopiedKey(null), 2000);
    } catch {
      toast.error("Falha ao copiar.");
    }
  }, []);

  const toggleKeyVisibility = useCallback((clientId: string) => {
    setVisibleKeys((prev) => {
      const next = new Set(prev);
      if (next.has(clientId)) {
        next.delete(clientId);
      } else {
        next.add(clientId);
      }
      return next;
    });
  }, []);

  const openEditWebhook = useCallback((client: ApiClient) => {
    setEditingClient(client);
    setEditWebhookForm({
      webhook_url: client.webhook_url ?? "",
      webhook_events: client.webhook_events ?? ["offer.updated"],
    });
    setIsEditWebhookOpen(true);
  }, []);

  const openLogs = useCallback((client: ApiClient) => {
    setSelectedClientForLogs(client);
    setIsLogsOpen(true);
  }, []);

  const handleCreateSubmit = () => {
    if (!newClientForm.client_name.trim()) {
      toast.error("O nome do cliente é obrigatório.");
      return;
    }
    createClientMutation.mutate(newClientForm);
  };

  const handleWebhookEventToggle = (
    event: string,
    form: { webhook_events: string[] },
    setForm: (f: any) => void,
  ) => {
    const events = form.webhook_events.includes(event)
      ? form.webhook_events.filter((e: string) => e !== event)
      : [...form.webhook_events, event];
    setForm({ ...form, webhook_events: events });
  };

  // ----------------------------------------------------------
  // Render
  // ----------------------------------------------------------
  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="font-display font-bold text-xl text-foreground flex items-center gap-2">
            <Code className="w-5 h-5 text-accent" />
            API & Integrações
          </h2>
          <p className="text-sm text-muted-foreground mt-1">
            Gerencie os clientes da API REST e webhooks para integrações externas.
          </p>
        </div>
        <button
          onClick={() => setIsNewClientOpen(true)}
          className="btn-accent flex items-center gap-2 text-sm"
          id="btn-add-api-client"
        >
          <Plus className="w-4 h-4" />
          Novo Cliente
        </button>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="bg-card rounded-xl border border-border p-4" style={{ boxShadow: "var(--shadow-card)" }}>
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-accent/10 flex items-center justify-center">
              <Shield className="w-5 h-5 text-accent" />
            </div>
            <div>
              <p className="text-2xl font-bold text-foreground">{clients.length}</p>
              <p className="text-xs text-muted-foreground">Total de Clientes</p>
            </div>
          </div>
        </div>
        <div className="bg-card rounded-xl border border-border p-4" style={{ boxShadow: "var(--shadow-card)" }}>
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-success/10 flex items-center justify-center">
              <CheckCircle2 className="w-5 h-5 text-success" />
            </div>
            <div>
              <p className="text-2xl font-bold text-foreground">
                {clients.filter((c) => c.is_active).length}
              </p>
              <p className="text-xs text-muted-foreground">Clientes Ativos</p>
            </div>
          </div>
        </div>
        <div className="bg-card rounded-xl border border-border p-4" style={{ boxShadow: "var(--shadow-card)" }}>
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-blue-500/10 flex items-center justify-center">
              <Webhook className="w-5 h-5 text-blue-500" />
            </div>
            <div>
              <p className="text-2xl font-bold text-foreground">
                {clients.filter((c) => c.webhook_url).length}
              </p>
              <p className="text-xs text-muted-foreground">Webhooks Configurados</p>
            </div>
          </div>
        </div>
      </div>

      {/* Clients Table */}
      <div className="bg-card rounded-xl border border-border overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
        <table className="w-full text-sm" id="table-api-clients">
          <thead>
            <tr className="border-b border-border bg-secondary">
              <th className="text-left p-4 font-semibold text-foreground">Cliente</th>
              <th className="text-left p-4 font-semibold text-foreground hidden md:table-cell">API Key</th>
              <th className="text-left p-4 font-semibold text-foreground hidden lg:table-cell">Webhook</th>
              <th className="text-center p-4 font-semibold text-foreground">Status</th>
              <th className="text-left p-4 font-semibold text-foreground hidden md:table-cell">Criado em</th>
              <th className="text-right p-4 font-semibold text-foreground">Ações</th>
            </tr>
          </thead>
          <tbody>
            {isLoading ? (
              <tr>
                <td colSpan={6} className="p-8 text-center text-muted-foreground">
                  <RefreshCw className="w-5 h-5 animate-spin inline mr-2" />
                  Carregando...
                </td>
              </tr>
            ) : clients.length === 0 ? (
              <tr>
                <td colSpan={6} className="p-12 text-center">
                  <div className="flex flex-col items-center gap-3">
                    <Code className="w-10 h-10 text-muted-foreground/30" />
                    <p className="text-muted-foreground">Nenhum cliente API cadastrado.</p>
                    <button
                      onClick={() => setIsNewClientOpen(true)}
                      className="text-accent hover:underline text-sm"
                    >
                      Criar primeiro cliente
                    </button>
                  </div>
                </td>
              </tr>
            ) : (
              clients.map((client) => (
                <tr
                  key={client.id}
                  className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors"
                >
                  {/* Client Name */}
                  <td className="p-4">
                    <div className="flex items-center gap-3">
                      <div className="w-8 h-8 rounded-lg bg-accent/10 flex items-center justify-center shrink-0">
                        <Shield className="w-4 h-4 text-accent" />
                      </div>
                      <div>
                        <p className="font-medium text-foreground">{client.client_name}</p>
                        <p className="text-xs text-muted-foreground md:hidden mt-0.5">
                          {obfuscateKey(client.api_key).substring(0, 20)}…
                        </p>
                      </div>
                    </div>
                  </td>

                  {/* API Key */}
                  <td className="p-4 hidden md:table-cell">
                    <div className="flex items-center gap-2">
                      <code className="text-xs bg-secondary px-2 py-1 rounded font-mono max-w-[220px] truncate">
                        {visibleKeys.has(client.id)
                          ? client.api_key
                          : obfuscateKey(client.api_key)}
                      </code>
                      <button
                        onClick={() => toggleKeyVisibility(client.id)}
                        className="p-1.5 rounded-md hover:bg-secondary transition-colors"
                        aria-label={visibleKeys.has(client.id) ? "Ocultar chave" : "Mostrar chave"}
                        title={visibleKeys.has(client.id) ? "Ocultar" : "Mostrar"}
                      >
                        {visibleKeys.has(client.id) ? (
                          <EyeOff className="w-3.5 h-3.5 text-muted-foreground" />
                        ) : (
                          <Eye className="w-3.5 h-3.5 text-muted-foreground" />
                        )}
                      </button>
                      <button
                        onClick={() => handleCopyKey(client.api_key, client.id)}
                        className="p-1.5 rounded-md hover:bg-secondary transition-colors"
                        aria-label="Copiar API Key"
                        title="Copiar"
                      >
                        {copiedKey === client.id ? (
                          <Check className="w-3.5 h-3.5 text-success" />
                        ) : (
                          <Copy className="w-3.5 h-3.5 text-muted-foreground" />
                        )}
                      </button>
                    </div>
                  </td>

                  {/* Webhook */}
                  <td className="p-4 hidden lg:table-cell">
                    {client.webhook_url ? (
                      <div className="flex items-center gap-2">
                        <Badge variant="secondary" className="text-xs font-mono max-w-[180px] truncate">
                          {client.webhook_url}
                        </Badge>
                      </div>
                    ) : (
                      <span className="text-muted-foreground text-xs italic">Não configurado</span>
                    )}
                  </td>

                  {/* Status */}
                  <td className="p-4 text-center">
                    <Switch
                      checked={client.is_active}
                      onCheckedChange={(checked) =>
                        toggleActiveMutation.mutate({
                          id: client.id,
                          is_active: checked,
                        })
                      }
                      aria-label={`Status do cliente ${client.client_name}`}
                    />
                  </td>

                  {/* Created At */}
                  <td className="p-4 hidden md:table-cell">
                    <span className="text-xs text-muted-foreground">
                      {formatDate(client.created_at)}
                    </span>
                  </td>

                  {/* Actions */}
                  <td className="p-4 text-right">
                    <div className="flex items-center justify-end gap-1">
                      {/* Mobile copy key */}
                      <button
                        onClick={() => handleCopyKey(client.api_key, client.id)}
                        className="p-2 rounded-lg hover:bg-secondary transition-colors md:hidden"
                        aria-label="Copiar API Key"
                        title="Copiar Key"
                      >
                        <Copy className="w-4 h-4 text-muted-foreground" />
                      </button>
                      {/* Edit Webhook */}
                      <button
                        onClick={() => openEditWebhook(client)}
                        className="p-2 rounded-lg hover:bg-secondary transition-colors"
                        aria-label="Editar webhook"
                        title="Editar Webhook"
                      >
                        <Pencil className="w-4 h-4 text-muted-foreground" />
                      </button>
                      {/* View Logs */}
                      <button
                        onClick={() => openLogs(client)}
                        className="p-2 rounded-lg hover:bg-secondary transition-colors"
                        aria-label="Ver logs de webhook"
                        title="Ver Logs"
                      >
                        <Activity className="w-4 h-4 text-muted-foreground" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* ====================================================== */}
      {/* Dialog: New Client                                      */}
      {/* ====================================================== */}
      <Dialog open={isNewClientOpen} onOpenChange={setIsNewClientOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Plus className="w-5 h-5 text-accent" />
              Novo Cliente API
            </DialogTitle>
            <DialogDescription>
              A API Key será gerada automaticamente no momento da criação.
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-4 py-2">
            {/* Client Name */}
            <div className="space-y-1.5">
              <label className="text-sm font-medium text-foreground">
                Nome do Cliente <span className="text-destructive">*</span>
              </label>
              <input
                value={newClientForm.client_name}
                onChange={(e) =>
                  setNewClientForm({ ...newClientForm, client_name: e.target.value })
                }
                placeholder="Ex: Gerashop Produção"
                className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30"
                id="input-client-name"
                autoFocus
              />
            </div>

            {/* API Key Info */}
            <div className="bg-secondary/50 rounded-lg p-3 border border-border">
              <div className="flex items-center gap-2 text-xs text-muted-foreground">
                <Shield className="w-4 h-4 text-accent shrink-0" />
                <span>
                  A API Key será gerada automaticamente (padrão:{" "}
                  <code className="bg-secondary px-1 rounded">ofsh_...</code>).
                </span>
              </div>
            </div>

            {/* Webhook URL */}
            <div className="space-y-1.5">
              <label className="text-sm font-medium text-foreground">
                Webhook URL <span className="text-muted-foreground font-normal">(opcional)</span>
              </label>
              <input
                value={newClientForm.webhook_url}
                onChange={(e) =>
                  setNewClientForm({ ...newClientForm, webhook_url: e.target.value })
                }
                placeholder="https://api.gerashop.com/webhooks/oferta"
                className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30"
                id="input-webhook-url"
              />
            </div>

            {/* Webhook Events */}
            <div className="space-y-2">
              <label className="text-sm font-medium text-foreground">Eventos do Webhook</label>
              <div className="space-y-2">
                {AVAILABLE_EVENTS.map((evt) => (
                  <label
                    key={evt.value}
                    className="flex items-center gap-3 p-2 rounded-lg hover:bg-secondary/50 cursor-pointer transition-colors"
                  >
                    <Checkbox
                      checked={newClientForm.webhook_events.includes(evt.value)}
                      onCheckedChange={() =>
                        handleWebhookEventToggle(evt.value, newClientForm, setNewClientForm)
                      }
                      id={`new-event-${evt.value}`}
                    />
                    <div>
                      <p className="text-sm text-foreground">{evt.label}</p>
                      <p className="text-xs text-muted-foreground font-mono">{evt.value}</p>
                    </div>
                  </label>
                ))}
              </div>
            </div>
          </div>

          <DialogFooter>
            <button
              onClick={() => setIsNewClientOpen(false)}
              className="px-4 py-2 rounded-lg text-sm text-muted-foreground hover:bg-secondary transition-colors"
            >
              Cancelar
            </button>
            <button
              onClick={handleCreateSubmit}
              disabled={createClientMutation.isPending}
              className="btn-accent flex items-center gap-2 text-sm"
              id="btn-submit-new-client"
            >
              {createClientMutation.isPending ? (
                <RefreshCw className="w-4 h-4 animate-spin" />
              ) : (
                <Plus className="w-4 h-4" />
              )}
              Criar Cliente
            </button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* ====================================================== */}
      {/* Dialog: Edit Webhook                                    */}
      {/* ====================================================== */}
      <Dialog open={isEditWebhookOpen} onOpenChange={setIsEditWebhookOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Webhook className="w-5 h-5 text-accent" />
              Configurar Webhook
            </DialogTitle>
            <DialogDescription>
              {editingClient
                ? `Atualize as configurações de webhook para "${editingClient.client_name}".`
                : "Configurar webhook."}
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-4 py-2">
            {/* Webhook URL */}
            <div className="space-y-1.5">
              <label className="text-sm font-medium text-foreground">Webhook URL</label>
              <input
                value={editWebhookForm.webhook_url}
                onChange={(e) =>
                  setEditWebhookForm({ ...editWebhookForm, webhook_url: e.target.value })
                }
                placeholder="https://api.gerashop.com/webhooks/oferta"
                className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30"
                id="edit-webhook-url"
              />
            </div>

            {/* Webhook Events */}
            <div className="space-y-2">
              <label className="text-sm font-medium text-foreground">Eventos</label>
              <div className="space-y-2">
                {AVAILABLE_EVENTS.map((evt) => (
                  <label
                    key={evt.value}
                    className="flex items-center gap-3 p-2 rounded-lg hover:bg-secondary/50 cursor-pointer transition-colors"
                  >
                    <Checkbox
                      checked={editWebhookForm.webhook_events.includes(evt.value)}
                      onCheckedChange={() =>
                        handleWebhookEventToggle(evt.value, editWebhookForm, setEditWebhookForm)
                      }
                      id={`edit-event-${evt.value}`}
                    />
                    <div>
                      <p className="text-sm text-foreground">{evt.label}</p>
                      <p className="text-xs text-muted-foreground font-mono">{evt.value}</p>
                    </div>
                  </label>
                ))}
              </div>
            </div>
          </div>

          <DialogFooter>
            <button
              onClick={() => {
                setIsEditWebhookOpen(false);
                setEditingClient(null);
              }}
              className="px-4 py-2 rounded-lg text-sm text-muted-foreground hover:bg-secondary transition-colors"
            >
              Cancelar
            </button>
            <button
              onClick={() => {
                if (editingClient) {
                  updateWebhookMutation.mutate({
                    id: editingClient.id,
                    form: editWebhookForm,
                  });
                }
              }}
              disabled={updateWebhookMutation.isPending}
              className="btn-accent flex items-center gap-2 text-sm"
              id="btn-submit-edit-webhook"
            >
              {updateWebhookMutation.isPending ? (
                <RefreshCw className="w-4 h-4 animate-spin" />
              ) : (
                <Check className="w-4 h-4" />
              )}
              Salvar
            </button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* ====================================================== */}
      {/* Sheet: Webhook Logs                                     */}
      {/* ====================================================== */}
      <Sheet open={isLogsOpen} onOpenChange={setIsLogsOpen}>
        <SheetContent className="sm:max-w-lg w-full overflow-y-auto">
          <SheetHeader>
            <SheetTitle className="flex items-center gap-2">
              <Activity className="w-5 h-5 text-accent" />
              Logs de Webhook
            </SheetTitle>
            <SheetDescription>
              {selectedClientForLogs
                ? `Últimas entregas para "${selectedClientForLogs.client_name}".`
                : "Logs de entrega de webhook."}
            </SheetDescription>
          </SheetHeader>

          <div className="mt-6 space-y-3">
            {isLogsLoading ? (
              <div className="flex items-center justify-center p-8 text-muted-foreground">
                <RefreshCw className="w-5 h-5 animate-spin mr-2" />
                Carregando logs...
              </div>
            ) : logs.length === 0 ? (
              <div className="flex flex-col items-center gap-3 p-8 text-center">
                <Activity className="w-10 h-10 text-muted-foreground/30" />
                <p className="text-muted-foreground text-sm">Nenhum log de webhook encontrado.</p>
              </div>
            ) : (
              logs.map((log) => {
                const isSuccess = log.status_code && log.status_code >= 200 && log.status_code < 300;
                const isError = log.status_code === 0 || (log.status_code && log.status_code >= 400);

                return (
                  <div
                    key={log.id}
                    className="bg-secondary/50 rounded-lg border border-border p-3 space-y-2"
                  >
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-2">
                        {isSuccess ? (
                          <CheckCircle2 className="w-4 h-4 text-success shrink-0" />
                        ) : isError ? (
                          <XCircle className="w-4 h-4 text-destructive shrink-0" />
                        ) : (
                          <AlertCircle className="w-4 h-4 text-yellow-500 shrink-0" />
                        )}
                        <Badge
                          variant={isSuccess ? "default" : "destructive"}
                          className="text-xs"
                        >
                          {log.status_code === 0 ? "ERRO" : `HTTP ${log.status_code}`}
                        </Badge>
                      </div>
                      <div className="flex items-center gap-1 text-xs text-muted-foreground">
                        <Clock className="w-3 h-3" />
                        {formatDate(log.created_at)}
                      </div>
                    </div>

                    <div className="text-xs text-muted-foreground font-mono truncate">
                      {log.endpoint_url}
                    </div>

                    {log.response_body && (
                      <details className="text-xs">
                        <summary className="text-muted-foreground cursor-pointer hover:text-foreground transition-colors">
                          Ver resposta
                        </summary>
                        <pre className="mt-1 p-2 bg-secondary rounded text-xs overflow-x-auto max-h-32 text-foreground/80">
                          {log.response_body}
                        </pre>
                      </details>
                    )}

                    <details className="text-xs">
                      <summary className="text-muted-foreground cursor-pointer hover:text-foreground transition-colors">
                        Ver payload enviado
                      </summary>
                      <pre className="mt-1 p-2 bg-secondary rounded text-xs overflow-x-auto max-h-32 text-foreground/80">
                        {JSON.stringify(log.payload, null, 2)}
                      </pre>
                    </details>
                  </div>
                );
              })
            )}
          </div>
        </SheetContent>
      </Sheet>
    </div>
  );
};

export default AdminAPI;
