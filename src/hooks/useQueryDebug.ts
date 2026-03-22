import { useQueryClient } from "@tanstack/react-query";
import { useEffect } from "react";

/**
 * Hook de debug para monitorar quando queries estão sendo disparadas
 * Útil para diagnosticar problemas de refetch inesperado
 */
export const useQueryDebug = () => {
    const queryClient = useQueryClient();

    useEffect(() => {
        // Monitorar quando queries são iniciadas
        const onQueryStart = () => {
            console.log("[Query Debug] Query started");
        };

        // Monitorar quando queries são concluídas com sucesso
        const onQuerySuccess = () => {
            console.log("[Query Debug] Query success");
        };

        // Monitorar quando queries falham
        const onQueryError = () => {
            console.log("[Query Debug] Query error");
        };

        // Monitorar quando queries são invalidadas
        const onQueryInvalidated = () => {
            console.log("[Query Debug] Query invalidated");
        };

        // Assinar nos eventos do query client (API correta do React Query v5)
        const unsubscribeStart = queryClient.getQueryCache().subscribe(onQueryStart);
        const unsubscribeSuccess = queryClient.getQueryCache().subscribe(onQuerySuccess);
        const unsubscribeError = queryClient.getQueryCache().subscribe(onQueryError);
        const unsubscribeInvalidated = queryClient.getQueryCache().subscribe(onQueryInvalidated);

        // Limpar subscriptions
        return () => {
            unsubscribeStart();
            unsubscribeSuccess();
            unsubscribeError();
            unsubscribeInvalidated();
        };
    }, [queryClient]);
};