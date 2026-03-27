import { useState, useEffect, useRef } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Sparkles, Save, Loader2, CheckCircle2, AlertCircle, Eye, EyeOff, Zap, ChevronDown, Trash2, Plus } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

const DEFAULT_MODELS = [
  { value: "google/gemini-2.0-flash-exp:free", label: "Gemini 2.0 Flash (Gratuito)", free: true },
  { value: "meta-llama/llama-4-maverick:free", label: "Llama 4 Maverick (Gratuito)", free: true },
  { value: "deepseek/deepseek-chat-v3-0324:free", label: "DeepSeek Chat v3 (Gratuito)", free: true },
  { value: "google/gemini-2.5-pro-preview-03-25", label: "Gemini 2.5 Pro Preview", free: false },
  { value: "anthropic/claude-sonnet-4", label: "Claude Sonnet 4", free: false },
  { value: "openai/gpt-4o", label: "GPT-4o", free: false },
];

interface CustomModel {
  value: string;
  label: string;
}

const AdminAISettings = () => {
  const [apiKey, setApiKey] = useState("");
  const [selectedModel, setSelectedModel] = useState("google/gemini-2.0-flash-exp:free");
  const [customModelInput, setCustomModelInput] = useState("");
  const [useCustomModel, setUseCustomModel] = useState(false);
  const [showKey, setShowKey] = useState(false);
  const [saving, setSaving] = useState(false);
  const [testing, setTesting] = useState(false);
  const [testResult, setTestResult] = useState<{ success: boolean; message: string } | null>(null);
  const [loading, setLoading] = useState(true);
  const [customModels, setCustomModels] = useState<CustomModel[]>([]);
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  // Close dropdown on click outside
  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target as Node)) {
        setDropdownOpen(false);
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  // Close dropdown on Escape
  useEffect(() => {
    const handleEsc = (e: KeyboardEvent) => {
      if (e.key === "Escape") setDropdownOpen(false);
    };
    document.addEventListener("keydown", handleEsc);
    return () => document.removeEventListener("keydown", handleEsc);
  }, []);

  // Load existing config + custom models
  useEffect(() => {
    const loadConfig = async () => {
      try {
        const [configRes, modelsRes] = await Promise.all([
          (supabase as any).from("admin_settings").select("value").eq("key", "openrouter_config").maybeSingle(),
          (supabase as any).from("admin_settings").select("value").eq("key", "openrouter_custom_models").maybeSingle(),
        ]);

        if (configRes.data?.value) {
          setApiKey(configRes.data.value.apiKey || "");
          const model = configRes.data.value.model || "google/gemini-2.0-flash-exp:free";
          const isPreset = DEFAULT_MODELS.some((m) => m.value === model);
          // Will check custom models after loading them
          if (isPreset) {
            setSelectedModel(model);
            setUseCustomModel(false);
          } else {
            // Could be a saved custom model or a manually entered one
            setSelectedModel(model);
            setUseCustomModel(false); // Will resolve below
          }
        }

        if (modelsRes.data?.value && Array.isArray(modelsRes.data.value)) {
          setCustomModels(modelsRes.data.value);
          // Now check if the current model is a custom saved model
          if (configRes.data?.value?.model) {
            const model = configRes.data.value.model;
            const isPreset = DEFAULT_MODELS.some((m) => m.value === model);
            const isCustomSaved = modelsRes.data.value.some((m: CustomModel) => m.value === model);
            if (!isPreset && !isCustomSaved) {
              // Unknown model — set it in the input
              setCustomModelInput(model);
              setUseCustomModel(true);
            }
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

  const getActiveModel = () => (useCustomModel ? customModelInput : selectedModel);

  const getDisplayLabel = () => {
    if (useCustomModel) return customModelInput || "Digitar modelo manualmente...";
    const preset = DEFAULT_MODELS.find((m) => m.value === selectedModel);
    if (preset) return preset.label;
    const custom = customModels.find((m) => m.value === selectedModel);
    if (custom) return custom.label;
    return selectedModel;
  };

  // Save custom models to admin_settings
  const saveCustomModels = async (models: CustomModel[]) => {
    try {
      await (supabase as any).from("admin_settings").upsert({
        key: "openrouter_custom_models",
        value: models,
        updated_at: new Date().toISOString(),
      });
    } catch (err) {
      console.error("Error saving custom models:", err);
    }
  };

  const handleAddCustomModel = async () => {
    const modelValue = customModelInput.trim();
    if (!modelValue) {
      toast.error("Informe o nome do modelo.");
      return;
    }
    // Check if already exists
    if (DEFAULT_MODELS.some((m) => m.value === modelValue) || customModels.some((m) => m.value === modelValue)) {
      toast.info("Este modelo já está na lista.");
      setSelectedModel(modelValue);
      setUseCustomModel(false);
      setCustomModelInput("");
      return;
    }
    // Create label from model value (e.g. "nvidia/nemotron-3-super-120b-a12b:free" → "nemotron-3-super-120b-a12b:free")
    const labelParts = modelValue.split("/");
    const label = labelParts.length > 1 ? labelParts.slice(1).join("/") : modelValue;
    const newModel: CustomModel = { value: modelValue, label };
    const updated = [...customModels, newModel];
    setCustomModels(updated);
    await saveCustomModels(updated);
    setSelectedModel(modelValue);
    setUseCustomModel(false);
    setCustomModelInput("");
    toast.success("Modelo adicionado à lista!");
  };

  const handleDeleteCustomModel = async (modelValue: string, e: React.MouseEvent) => {
    e.stopPropagation();
    const updated = customModels.filter((m) => m.value !== modelValue);
    setCustomModels(updated);
    await saveCustomModels(updated);
    // If the deleted model was the selected one, reset to default
    if (selectedModel === modelValue && !useCustomModel) {
      setSelectedModel("google/gemini-2.0-flash-exp:free");
    }
    toast.success("Modelo removido da lista.");
  };

  const handleSelectModel = (value: string) => {
    if (value === "__custom__") {
      setUseCustomModel(true);
      setDropdownOpen(false);
    } else {
      setSelectedModel(value);
      setUseCustomModel(false);
      setDropdownOpen(false);
    }
  };

  const handleSave = async () => {
    if (!apiKey.trim()) {
      toast.error("Informe a API Key do OpenRouter.");
      return;
    }
    if (useCustomModel && !customModelInput.trim()) {
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

  const freeModels = DEFAULT_MODELS.filter((m) => m.free);
  const premiumModels = DEFAULT_MODELS.filter((m) => !m.free);

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

        {/* Model Selection — Custom Dropdown */}
        <div>
          <label className="text-xs font-semibold text-foreground mb-1.5 block">Modelo de IA</label>
          <div className="space-y-3">
            <div className="relative" ref={dropdownRef}>
              {/* Trigger button */}
              <button
                type="button"
                onClick={() => setDropdownOpen(!dropdownOpen)}
                className="w-full h-10 px-3 rounded-lg bg-secondary border border-border text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 transition-colors flex items-center justify-between"
              >
                <span className="truncate text-left">
                  {useCustomModel ? "✏️ Digitar modelo manualmente..." : getDisplayLabel()}
                </span>
                <ChevronDown className={`w-4 h-4 text-muted-foreground shrink-0 transition-transform ${dropdownOpen ? "rotate-180" : ""}`} />
              </button>

              {/* Dropdown menu */}
              <AnimatePresence>
                {dropdownOpen && (
                  <motion.div
                    initial={{ opacity: 0, y: -4 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -4 }}
                    transition={{ duration: 0.15 }}
                    className="absolute z-50 mt-1 w-full rounded-lg bg-card border border-border shadow-lg overflow-hidden"
                    style={{ maxHeight: "320px", overflowY: "auto" }}
                  >
                    {/* Free models */}
                    <div className="px-3 py-2 text-[10px] font-bold text-muted-foreground uppercase tracking-widest bg-secondary/50">
                      Modelos Gratuitos
                    </div>
                    {freeModels.map((m) => (
                      <button
                        key={m.value}
                        type="button"
                        onClick={() => handleSelectModel(m.value)}
                        className={`w-full flex items-center gap-2 px-3 py-2.5 text-sm text-left transition-colors hover:bg-accent/10 ${
                          !useCustomModel && selectedModel === m.value ? "bg-accent/10 text-accent font-medium" : "text-foreground"
                        }`}
                      >
                        <span className="flex-1 truncate">{m.label}</span>
                        {!useCustomModel && selectedModel === m.value && (
                          <CheckCircle2 className="w-3.5 h-3.5 text-accent shrink-0" />
                        )}
                      </button>
                    ))}

                    {/* Premium models */}
                    <div className="px-3 py-2 text-[10px] font-bold text-muted-foreground uppercase tracking-widest bg-secondary/50 border-t border-border">
                      Modelos Premium
                    </div>
                    {premiumModels.map((m) => (
                      <button
                        key={m.value}
                        type="button"
                        onClick={() => handleSelectModel(m.value)}
                        className={`w-full flex items-center gap-2 px-3 py-2.5 text-sm text-left transition-colors hover:bg-accent/10 ${
                          !useCustomModel && selectedModel === m.value ? "bg-accent/10 text-accent font-medium" : "text-foreground"
                        }`}
                      >
                        <span className="flex-1 truncate">{m.label}</span>
                        {!useCustomModel && selectedModel === m.value && (
                          <CheckCircle2 className="w-3.5 h-3.5 text-accent shrink-0" />
                        )}
                      </button>
                    ))}

                    {/* Custom saved models */}
                    {customModels.length > 0 && (
                      <>
                        <div className="px-3 py-2 text-[10px] font-bold text-muted-foreground uppercase tracking-widest bg-secondary/50 border-t border-border">
                          Meus Modelos
                        </div>
                        {customModels.map((m) => (
                          <div
                            key={m.value}
                            className={`w-full flex items-center gap-2 px-3 py-2.5 text-sm transition-colors hover:bg-accent/10 group ${
                              !useCustomModel && selectedModel === m.value ? "bg-accent/10 text-accent font-medium" : "text-foreground"
                            }`}
                          >
                            <button
                              type="button"
                              onClick={() => handleSelectModel(m.value)}
                              className="flex-1 text-left truncate"
                            >
                              {m.label}
                            </button>
                            {!useCustomModel && selectedModel === m.value && (
                              <CheckCircle2 className="w-3.5 h-3.5 text-accent shrink-0" />
                            )}
                            <button
                              type="button"
                              onClick={(e) => handleDeleteCustomModel(m.value, e)}
                              className="p-1 rounded text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors opacity-0 group-hover:opacity-100"
                              title="Remover modelo"
                            >
                              <Trash2 className="w-3.5 h-3.5" />
                            </button>
                          </div>
                        ))}
                      </>
                    )}

                    {/* Custom manual option */}
                    <div className="border-t border-border">
                      <button
                        type="button"
                        onClick={() => handleSelectModel("__custom__")}
                        className={`w-full flex items-center gap-2 px-3 py-2.5 text-sm text-left transition-colors hover:bg-accent/10 ${
                          useCustomModel ? "bg-accent/10 text-accent font-medium" : "text-muted-foreground"
                        }`}
                      >
                        <Plus className="w-3.5 h-3.5" />
                        <span>Digitar modelo manualmente...</span>
                      </button>
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>
            </div>

            {/* Custom model input + Add button */}
            {useCustomModel && (
              <motion.div
                initial={{ opacity: 0, height: 0 }}
                animate={{ opacity: 1, height: "auto" }}
                exit={{ opacity: 0, height: 0 }}
                className="flex gap-2"
              >
                <input
                  type="text"
                  value={customModelInput}
                  onChange={(e) => setCustomModelInput(e.target.value)}
                  onKeyDown={(e) => {
                    if (e.key === "Enter") {
                      e.preventDefault();
                      handleAddCustomModel();
                    }
                  }}
                  placeholder="ex: nvidia/nemotron-3-super-120b-a12b:free"
                  className="flex-1 h-10 px-3 rounded-lg bg-secondary border border-border text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 transition-colors font-mono"
                />
                <button
                  type="button"
                  onClick={handleAddCustomModel}
                  className="h-10 px-4 rounded-lg bg-accent/10 border border-accent/20 text-accent text-sm font-medium flex items-center gap-1.5 hover:bg-accent/20 transition-colors shrink-0"
                >
                  <Plus className="w-4 h-4" /> Adicionar
                </button>
              </motion.div>
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
          <p>2. Selecione o modelo de IA desejado ou adicione um modelo customizado à lista.</p>
          <p>3. Salve e teste a conexão.</p>
          <p>4. Na listagem de <strong className="text-foreground">Produtos</strong>, clique no ícone ✨ para gerar conteúdo automaticamente para Instagram, WhatsApp e Reels.</p>
        </div>
      </div>
    </div>
  );
};

export default AdminAISettings;
