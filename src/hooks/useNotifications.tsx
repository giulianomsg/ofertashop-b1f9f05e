import React, { createContext, useContext, useEffect, useState, useCallback } from "react";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

export interface Notification {
  id: string;
  title: string;
  message: string;
  date: Date;
  read: boolean;
  link?: string;
  product_id?: string;
}

interface NotificationContextType {
  notifications: Notification[];
  unreadCount: number;
  markAsRead: (id: string) => void;
  markAllAsRead: () => void;
  clearNotifications: () => void;
}

const NotificationContext = createContext<NotificationContextType | undefined>(undefined);

export const NotificationProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [notifications, setNotifications] = useState<Notification[]>([]);

  const addNotification = useCallback((notification: Omit<Notification, "id" | "date" | "read">) => {
    setNotifications((prev) => {
      const newNotif: Notification = {
        ...notification,
        id: crypto.randomUUID(),
        date: new Date(),
        read: false,
      };
      // Manter apenas as últimas 5 notificações
      return [newNotif, ...prev].slice(0, 5);
    });
  }, []);

  const markAsRead = useCallback((id: string) => {
    setNotifications((prev) => prev.map((n) => (n.id === id ? { ...n, read: true } : n)));
  }, []);

  const markAllAsRead = useCallback(() => {
    setNotifications((prev) => prev.map((n) => ({ ...n, read: true })));
  }, []);

  const clearNotifications = useCallback(() => {
    setNotifications([]);
  }, []);

  useEffect(() => {
    // Escutar eventos da tabela `products`
    const channel = supabase
      .channel("public:products:global")
      .on("postgres_changes", { event: "*", schema: "public", table: "products" }, (payload) => {
        const isUpdate = payload.eventType === "UPDATE";
        const isInsert = payload.eventType === "INSERT";
        
        let title = "Atualização de Oferta";
        let message = "Uma oferta foi atualizada.";
        let link = "";
        let productId = "";

        if (isUpdate && payload.new && 'id' in payload.new) {
           productId = payload.new.id;
           title = "Oferta Atualizada";
           message = payload.new.title ? `O produto "${payload.new.title}" sofreu alterações.` : "Um produto que você pode ter interesse foi atualizado.";
           link = `/produto/${productId}`;
        } else if (isInsert && payload.new && 'id' in payload.new) {
           productId = payload.new.id;
           title = "Nova Oferta";
           message = payload.new.title ? `Novo produto adicionado: ${payload.new.title}` : "Uma nova oferta foi adicionada ao catálogo.";
           link = `/produto/${productId}`;
        }

        // Se for uma exclusão ignoramos, ou poderemos adicionar na notificação
        if (!isUpdate && !isInsert) return;

        // --- REGRA DE EXCEÇÃO PARA CLICKS ---
        if (isUpdate && payload.old && payload.new) {
          const oldKeys = Object.keys(payload.old);
          // Verifica se o Supabase enviou o registro antigo completo (requer REPLICA IDENTITY FULL na tabela)
          if (oldKeys.length > 1) {
             const changedFields = Object.keys(payload.new).filter((key) => {
                if (key === 'updated_at') return false; // Ignora updated_at que muda automaticamente
                return JSON.stringify(payload.new[key]) !== JSON.stringify(payload.old[key]);
             });
             
             // Se o único campo alterado for 'clicks', abortamos a notificação
             if (changedFields.length === 1 && changedFields[0] === 'clicks') {
                return;
             }
          }
        }
        // ------------------------------------

        addNotification({ title, message, link, product_id: productId });

        // Identifica onde o usuário está
        const currentPath = window.location.pathname;
        
        if (currentPath === `/produto/${productId}`) {
           toast(title, {
              description: 'Este produto que você está visualizando foi atualizado agora mesmo! Recarregue a página.',
              action: {
                label: 'Atualizar',
                onClick: () => window.location.reload()
              },
              duration: 25000,
           });
        } else {
           toast(title, {
              description: message,
              action: {
                label: 'Ver oferta',
                onClick: () => { window.location.href = link }
              },
              duration: 5000,
           });
        }
      })
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [addNotification]);

  const unreadCount = notifications.filter((n) => !n.read).length;

  return (
    <NotificationContext.Provider value={{ notifications, unreadCount, markAsRead, markAllAsRead, clearNotifications }}>
      {children}
    </NotificationContext.Provider>
  );
};

export const useNotifications = () => {
  const context = useContext(NotificationContext);
  if (context === undefined) {
    throw new Error("useNotifications must be used within a NotificationProvider");
  }
  return context;
};
