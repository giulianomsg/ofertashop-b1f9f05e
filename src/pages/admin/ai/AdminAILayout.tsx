import { useState } from "react";
import { Outlet, Link, useLocation } from "react-router-dom";
import { BarChart3, Wand2, Users, Calendar, Bot, Settings } from "lucide-react";

const AI_NAV = [
  { icon: BarChart3, label: "Dashboard", path: "/admin/ai/dashboard" },
  { icon: Wand2, label: "Gerador", path: "/admin/ai/generator" },
  { icon: Users, label: "Personas", path: "/admin/ai/personas" },
  { icon: Calendar, label: "Campanhas", path: "/admin/ai/campaigns" },
  { icon: Bot, label: "Automações", path: "/admin/ai/automations" },
];

const AdminAILayout = () => {
  const location = useLocation();

  return (
    <div className="space-y-6">
      {/* Sub-navigation */}
      <div className="flex items-center gap-1 overflow-x-auto pb-1">
        {AI_NAV.map((item) => {
          const active = location.pathname === item.path;
          return (
            <Link
              key={item.path}
              to={item.path}
              className={`flex items-center gap-1.5 px-3 py-2 rounded-lg text-sm font-medium transition-all whitespace-nowrap ${
                active
                  ? "bg-accent/10 text-accent"
                  : "text-muted-foreground hover:bg-secondary hover:text-foreground"
              }`}
            >
              <item.icon className="w-4 h-4" />
              {item.label}
            </Link>
          );
        })}
      </div>

      <Outlet />
    </div>
  );
};

export default AdminAILayout;
