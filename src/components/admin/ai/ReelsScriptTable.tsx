interface ReelsScene {
  cena: number;
  duracao: string;
  acao_visual: string;
  texto_sobreposto: string;
  audio: string;
}

interface ReelsScriptTableProps {
  scenes: ReelsScene[];
  audioSugerido?: string;
}

const ReelsScriptTable = ({ scenes, audioSugerido }: ReelsScriptTableProps) => {
  if (!scenes || scenes.length === 0) {
    return <p className="text-sm text-muted-foreground italic">Nenhuma cena gerada.</p>;
  }

  return (
    <div className="space-y-3">
      {audioSugerido && (
        <div className="flex items-center gap-2 text-sm">
          <span className="text-muted-foreground">🎵 Áudio sugerido:</span>
          <span className="font-medium text-foreground">{audioSugerido}</span>
        </div>
      )}
      <div className="overflow-x-auto rounded-lg border border-border">
        <table className="w-full text-sm">
          <thead>
            <tr className="bg-secondary border-b border-border">
              <th className="text-left p-3 font-semibold text-foreground w-16">Cena</th>
              <th className="text-left p-3 font-semibold text-foreground w-20">Duração</th>
              <th className="text-left p-3 font-semibold text-foreground">Ação Visual</th>
              <th className="text-left p-3 font-semibold text-foreground">Texto</th>
              <th className="text-left p-3 font-semibold text-foreground">Áudio</th>
            </tr>
          </thead>
          <tbody>
            {scenes.map((scene, i) => (
              <tr key={i} className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors">
                <td className="p-3 text-center font-bold text-accent">{scene.cena || i + 1}</td>
                <td className="p-3 text-muted-foreground font-mono text-xs">{scene.duracao}</td>
                <td className="p-3 text-foreground">{scene.acao_visual}</td>
                <td className="p-3 text-foreground italic">{scene.texto_sobreposto}</td>
                <td className="p-3 text-muted-foreground">{scene.audio}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default ReelsScriptTable;
