import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import { Sparkles, Save, Loader2, CheckCircle2, AlertCircle, Eye, EyeOff, Zap } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

const AI_MODELS = [
  { value: "google/gemini-2.0-flash-exp:free", label: "Gemini 2.0 Flash (Gratuito)", free: true },
  { value: "meta-llama/llama-4-maverick:free", label: "Llama 4 Maverick (Gratuito)", free: true },
  { value: "deepseek/deepseek-chat-v3-0324:free", label: "DeepSeek Chat v3 (Gratuito)", free: true },
  { value: "google/gemini-2.5-pro-preview-03-25", label: "Gemini 2.5 Pro Preview", free: false },
  { value: "anthropic/claude-sonnet-4", label: "Claude Sonnet 4", free: false },
  { value: "openai/gpt-4o", label: "GPT-4o", free: false },
];

const AdminAISettings = () => {
  const [apiKey, setApiKey] = useState("");
  const [selectedModel, setSelectedModel] = useState("google/gemini-2.0-flash-exp:free");
  const [customModel, setCustomModel] = useState("");
  const [useCustomModel, setUseCustomModel] = useState(false);
  const [showKey, setShowKey] = useState(false);
  const [saving, setSaving] = useState(false);
  const [testing, setTesting] = useState(false);
  const [testResult, setTestResult] = useState<{ success: boolean; message: string } | null>(null);
  const [loading, setLoading] = useState(true);

  // Load existing config
  useEffect(() => {
    const loadConfig = async () => {
      try {
        const { data } = await (supabase as any)
          .from("admin_settings")
          .select("value")
          .eq("key", "openrouter_config")
          .maybeSingle();
        if (data?.value) {
          setApiKey(data.value.apiKey || "");
          const model = data.value.model || "google/gemini-2.0-flash-exp:free";
          const isPreset = AI_MODELS.some((m) => m.value === model);
          if (isPreset) {
            setSelectedModel(model);
            setUseCustomModel(false);
          } else {
            setCustomModel(model);
            setUseCustomModel(true);
          }
        }
      } catch (e) {
        console.error("Error loading AI config:", e);
      } finally {
        setLoading(false);
      }
    };
    loadConfig();
  }, []);

  const getActiveModel = () => (useCustomModel ? customModel : selectedModel);

  const handleSave = async () => {
    if (!apiKey.trim()) {
      toast.error("Informe a API Key do OpenRouter.");
      return;
    }
    if (useCustomModel && !customModel.trim()) {
      toast.error("Informe o nome do modelo customizado.");
      return;
    }
    setSaving(true);
    try {
      const { error } = await (supabase as any).from("admin_settings").upsert({
        key: "openrouter_config",
        value: { apiKey: apiKey.trim(), model: getActiveModel() },
        updated_at: new Date().toISOString(),
      });
      if (error) throw error;
      toast.success("Configurações de IA salvas com sucesso!");
    } catch (err: any) {
      toast.error(err.message || "Erro ao salvar configurações.");
    } finally {
      setSaving(false);
    }
  };

  const handleTestConnection = async () => {
    if (!apiKey.trim()) {
      toast.error("Informe a API Key primeiro.");
      return;
    }
    setTesting(true);
    setTestResult(null);
    try {
      // Save first so the edge function can read it
      await (supabase as any).from("admin_settings").upsert({
        key: "openrouter_config",
        value: { apiKey: apiKey.trim(), model: getActiveModel() },
        updated_at: new Date().toISOString(),
      });

      const { data, error } = await supabase.functions.invoke("generate-social-copy", {
        body: { testConnection: true },
      });
      if (error) throw error;
      if (data?.error) throw new Error(data.error);
      setTestResult({ success: true, message: `Conexão OK! Modelo: ${data.model}` });
      toast.success("Conexão com OpenRouter testada com sucesso!");
    } catch (err: any) {
      setTestResult({ success: false, message: err.message || "Falha ao conectar" });
      toast.error(err.message || "Falha ao testar conexão com OpenRouter.");
    } finally {
      setTesting(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center p-12">
        <Loader2 className="w-6 h-6 animate-spin text-muted-foreground" />
      </div>
    );
  }

  return (
    <div className="space-y-6 max-w-2xl">
      <div className="flex items-center gap-3">
        <div className="p-2.5 rounded-xl bg-accent/10">
          <Sparkles className="w-6 h-6 text-accent" />
        </div>
        <div>
          <h2 className="font-display font-bold text-xl text-foreground">IA / Gerador de Conteúdo</h2>
          <p className="text-sm text-muted-foreground">Configure a integração com OpenRouter para gerar copy automaticamente.</p>
        </div>
      </div>

      {/* API Key */}
      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        className="bg-card rounded-xl border border-border p-6 space-y-5"
        style={{ boxShadow: "var(--shadow-card)" }}
      >
        <h3 className="font-semibold text-foreground text-sm uppercase tracking-wider flex items-center gap-2">
          <Zap className="w-4 h-4 text-accent" /> Configuração OpenRouter
        </h3>

        <div>
          <label className="text-xs font-semibold text-foreground mb-1.5 block">API Key</label>
          <div className="relative">
            <input
              type={showKey ? "text" : "password"}
              value={apiKey}
              onChange={(e) => setApiKey(e.target.value)}
              placeholder="sk-or-v1-..."
              className="w-full h-10 px-3 pr-10 rounded-lg bg-secondary border border-border text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 transition-colors font-mono"
            />
            <button
              type="button"
              onClick={() => setShowKey(!showKey)}
              className="absolute right-2 top-1/2 -translate-y-1/2 p-1 text-muted-foreground hover:text-foreground transition-colors"
            >
              {showKey ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
            </button>
          </div>
          <p className="text-xs text-muted-foreground mt-1.5">
            Obtenha em{" "}
            <a href="https://openrouter.ai/keys" target="_blank" rel="noopener noreferrer" className="text-accent hover:underline">
              openrouter.ai/keys
            </a>
          </p>
        </div>

        {/* Model Selection */}
        <div>
          <label className="text-xs font-semibold text-foreground mb-1.5 block">Modelo de IA</label>
          <div className="space-y-3">
            <select
              value={useCustomModel ? "__custom__" : selectedModel}
              onChange={(e) => {
                if (e.target.value === "__custom__") {
                  setUseCustomModel(true);
                } else {
                  setUseCustomModel(false);
                  setSelectedModel(e.target.value);
                }
              }}
              className="w-full h-10 px-3 rounded-lg bg-secondary border border-border text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 transition-colors"
            >
              <optgroup label="Modelos Gratuitos">
                {AI_MODELS.filter((m) => m.free).map((m) => (
                  <option key={m.value} value={m.value}>
                    {m.label}
                  </option>
                ))}
              </optgroup>
              <optgroup label="Modelos Premium">
                {AI_MODELS.filter((m) => !m.free).map((m) => (
                  <option key={m.value} value={m.value}>
                    {m.label}
                  </option>
                ))}
              </optgroup>
              <optgroup label="Customizado">
                <option value="__custom__">Digitar modelo manualmente...</option>
              </optgroup>
            </select>

            {useCustomModel && (
              <input
                type="text"
                value={customModel}
                onChange={(e) => setCustomModel(e.target.value)}
                placeholder="ex: mistralai/mistral-large-latest"
                className="w-full h-10 px-3 rounded-lg bg-secondary border border-border text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 transition-colors font-mono"
              />
            )}
          </div>
          <p className="text-xs text-muted-foreground mt-1.5">
            Consulte modelos disponíveis em{" "}
            <a href="https://openrouter.ai/models" target="_blank" rel="noopener noreferrer" className="text-accent hover:underline">
              openrouter.ai/models
            </a>
          </p>
        </div>

        {/* Test Result */}
        {testResult && (
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            className={`flex items-center gap-2 p-3 rounded-lg text-sm ${
              testResult.success
                ? "bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 border border-emerald-500/20"
                : "bg-destructive/10 text-destructive border border-destructive/20"
            }`}
          >
            {testResult.success ? <CheckCircle2 className="w-4 h-4 shrink-0" /> : <AlertCircle className="w-4 h-4 shrink-0" />}
            {testResult.message}
          </motion.div>
        )}

        {/* Actions */}
        <div className="flex gap-3 pt-2">
          <button
            onClick={handleTestConnection}
            disabled={testing || !apiKey.trim()}
            className="flex-1 h-10 rounded-lg border border-border bg-secondary text-sm font-medium text-foreground flex items-center justify-center gap-2 hover:bg-secondary/80 disabled:opacity-50 transition-colors"
          >
            {testing ? (
              <><Loader2 className="w-4 h-4 animate-spin" /> Testando...</>
            ) : (
              <><Zap className="w-4 h-4" /> Testar Conexão</>
            )}
          </button>
          <button
            onClick={handleSave}
            disabled={saving || !apiKey.trim()}
            className="flex-1 h-10 rounded-lg bg-accent text-accent-foreground text-sm font-semibold flex items-center justify-center gap-2 hover:bg-accent/90 disabled:opacity-50 transition-colors"
          >
            {saving ? (
              <><Loader2 className="w-4 h-4 animate-spin" /> Salvando...</>
            ) : (
              <><Save className="w-4 h-4" /> Salvar Configurações</>
            )}
          </button>
        </div>
      </motion.div>

      {/* Usage info */}
      <div className="bg-card rounded-xl border border-border p-6 space-y-3" style={{ boxShadow: "var(--shadow-card)" }}>
        <h3 className="font-semibold text-foreground text-sm uppercase tracking-wider">Como usar</h3>
        <div className="text-sm text-muted-foreground space-y-2">
          <p>1. Insira sua API Key do OpenRouter acima.</p>
          <p>2. Selecione o modelo de IA desejado (modelos gratuitos são ótimos para começar).</p>
          <p>3. Salve e teste a conexão.</p>
          <p>4. Na listagem de <strong className="text-foreground">Produtos</strong>, clique no ícone ✨ para gerar conteúdo automaticamente para Instagram, WhatsApp e Reels.</p>
        </div>
      </div>
    </div>
  );
};

export default AdminAISettings;
