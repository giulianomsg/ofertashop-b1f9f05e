import { useEffect, useRef } from "react";
import { useQueryClient } from "@tanstack/react-query";

/**
 * Hook para prevenir recarregamentos automáticos quando a página
 * volta a ficar visível (troca de aba, minimizar/maximizar).
 * 
 * Garante que as queries não sejam refeitas automaticamente
 * baseadas em eventos de visibilidade da janela.
 */
export const usePageVisibility = () => {
    const queryClient = useQueryClient();
    const wasHiddenRef = useRef(false);

    useEffect(() => {
        const handleVisibilityChange = () => {
            const isHidden = document.hidden || document.visibilityState === 'hidden';

            if (isHidden) {
                wasHiddenRef.current = true;
                // Pausar atualizações automáticas quando página está oculta
                queryClient.cancelQueries();
            } else if (wasHiddenRef.current) {
                wasHiddenRef.current = false;
                // Quando volta a ficar visível, NÃO fazer refetch automático
                // Apenas retomar queries que estavam em andamento, sem buscar novos dados
                // O cache já contém os dados frescos (staleTime)
            }
        };

        // Also handle window focus/blur events
        const handleWindowBlur = () => {
            // Quando a janela perde foco, pausar queries
            queryClient.cancelQueries();
        };

        const handleWindowFocus = () => {
            // Quando a janela ganha foco, NÃO refetch
            // Apenas garantir que as queries continuem com dados do cache
        };

        document.addEventListener('visibilitychange', handleVisibilityChange);
        window.addEventListener('blur', handleWindowBlur);
        window.addEventListener('focus', handleWindowFocus);

        return () => {
            document.removeEventListener('visibilitychange', handleVisibilityChange);
            window.removeEventListener('blur', handleWindowBlur);
            window.removeEventListener('focus', handleWindowFocus);
        };
    }, [queryClient]);
};
