import { useState } from "react";
import { Copy, Check } from "lucide-react";
import { toast } from "sonner";

interface CopyBlockProps {
  label: string;
  icon: React.ElementType;
  content: string;
  accentClass?: string;
}

const CopyBlock = ({ label, icon: Icon, content, accentClass = "" }: CopyBlockProps) => {
  const [copied, setCopied] = useState(false);

  const handleCopy = () => {
    navigator.clipboard.writeText(content);
    setCopied(true);
    toast.success("Copiado!");
    setTimeout(() => setCopied(false), 2000);
  };

  if (!content) return null;

  return (
    <div className={`bg-secondary rounded-lg p-4 space-y-2 ${accentClass}`}>
      <div className="flex items-center justify-between">
        <span className="text-xs font-semibold text-muted-foreground flex items-center gap-1.5 uppercase tracking-wider">
          <Icon className="w-3.5 h-3.5" /> {label}
        </span>
        <button onClick={handleCopy} className="p-1.5 rounded-md hover:bg-background transition-colors" title="Copiar">
          {copied ? <Check className="w-3.5 h-3.5 text-emerald-500" /> : <Copy className="w-3.5 h-3.5 text-muted-foreground" />}
        </button>
      </div>
      <p className="text-sm text-foreground whitespace-pre-wrap leading-relaxed">{content}</p>
    </div>
  );
};

export default CopyBlock;
