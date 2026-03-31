interface StoryMockupProps {
  textoCurto: string;
  enquete: {
    pergunta: string;
    opcao1: string;
    opcao2: string;
  };
}

const StoryMockup = ({ textoCurto, enquete }: StoryMockupProps) => {
  return (
    <div className="flex justify-center">
      <div
        className="relative bg-gradient-to-br from-accent/20 via-secondary to-accent/10 rounded-2xl overflow-hidden border border-border"
        style={{ width: 270, height: 480 }}
      >
        {/* Story content */}
        <div className="absolute inset-0 flex flex-col items-center justify-center p-6 gap-6">
          {/* Text */}
          {textoCurto && (
            <div className="bg-background/80 backdrop-blur-sm rounded-xl p-4 w-full text-center">
              <p className="text-sm font-semibold text-foreground leading-relaxed">{textoCurto}</p>
            </div>
          )}

          {/* Poll sticker */}
          {enquete?.pergunta && (
            <div className="bg-card rounded-xl border border-border p-4 w-full space-y-3 shadow-lg">
              <p className="text-xs font-bold text-foreground text-center uppercase tracking-wide">
                📊 Enquete
              </p>
              <p className="text-sm font-medium text-foreground text-center">{enquete.pergunta}</p>
              <div className="space-y-2">
                <button className="w-full py-2.5 rounded-lg bg-accent/10 text-accent text-sm font-medium border border-accent/20 hover:bg-accent/20 transition-colors">
                  {enquete.opcao1}
                </button>
                <button className="w-full py-2.5 rounded-lg bg-secondary text-foreground text-sm font-medium border border-border hover:bg-secondary/80 transition-colors">
                  {enquete.opcao2}
                </button>
              </div>
            </div>
          )}
        </div>

        {/* Story UI elements */}
        <div className="absolute top-3 left-3 right-3 flex items-center gap-2">
          <div className="flex-1 h-0.5 bg-foreground/20 rounded-full">
            <div className="h-full w-1/2 bg-foreground/60 rounded-full" />
          </div>
        </div>
      </div>
    </div>
  );
};

export default StoryMockup;
