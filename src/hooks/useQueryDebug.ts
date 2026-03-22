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
        const onQueryStart = () => {};

        // Monitorar quando queries são concluídas com sucesso
        const onQuerySuccess = () => {};

        // Monitorar quando queries falham
        const onQueryError = () => {};

        // Monitorar quando queries são invalidadas
        const onQueryInvalidated = () => {};

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