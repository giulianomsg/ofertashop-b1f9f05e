export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.1"
  }
  public: {
    Tables: {
      admin_settings: {
        Row: {
          key: string
          updated_at: string | null
          value: Json
        }
        Insert: {
          key: string
          updated_at?: string | null
          value: Json
        }
        Update: {
          key?: string
          updated_at?: string | null
          value?: Json
        }
        Relationships: []
      }
      ai_ab_tests: {
        Row: {
          created_at: string
          id: string
          metrics: Json | null
          name: string
          product_id: string | null
          status: Database["public"]["Enums"]["ai_ab_test_status"]
          updated_at: string
          variant_a_id: string | null
          variant_b_id: string | null
          winner_id: string | null
        }
        Insert: {
          created_at?: string
          id?: string
          metrics?: Json | null
          name: string
          product_id?: string | null
          status?: Database["public"]["Enums"]["ai_ab_test_status"]
          updated_at?: string
          variant_a_id?: string | null
          variant_b_id?: string | null
          winner_id?: string | null
        }
        Update: {
          created_at?: string
          id?: string
          metrics?: Json | null
          name?: string
          product_id?: string | null
          status?: Database["public"]["Enums"]["ai_ab_test_status"]
          updated_at?: string
          variant_a_id?: string | null
          variant_b_id?: string | null
          winner_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "ai_ab_tests_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      ai_analytics_events: {
        Row: {
          date: string
          event_type: string
          id: string
          metrics: Json | null
          platform: string
          product_id: string | null
        }
        Insert: {
          date?: string
          event_type: string
          id?: string
          metrics?: Json | null
          platform: string
          product_id?: string | null
        }
        Update: {
          date?: string
          event_type?: string
          id?: string
          metrics?: Json | null
          platform?: string
          product_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "ai_analytics_events_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      ai_campaigns: {
        Row: {
          created_at: string
          description: string | null
          end_date: string | null
          id: string
          name: string
          settings: Json | null
          start_date: string | null
          status: Database["public"]["Enums"]["ai_campaign_status"]
          type: Database["public"]["Enums"]["ai_campaign_type"]
          updated_at: string
          user_id: string
        }
        Insert: {
          created_at?: string
          description?: string | null
          end_date?: string | null
          id?: string
          name: string
          settings?: Json | null
          start_date?: string | null
          status?: Database["public"]["Enums"]["ai_campaign_status"]
          type?: Database["public"]["Enums"]["ai_campaign_type"]
          updated_at?: string
          user_id: string
        }
        Update: {
          created_at?: string
          description?: string | null
          end_date?: string | null
          id?: string
          name?: string
          settings?: Json | null
          start_date?: string | null
          status?: Database["public"]["Enums"]["ai_campaign_status"]
          type?: Database["public"]["Enums"]["ai_campaign_type"]
          updated_at?: string
          user_id?: string
        }
        Relationships: []
      }
      ai_competitor_tracking: {
        Row: {
          competitor_name: string
          content_analyzed: string | null
          detected_trends: Json | null
          id: string
          logged_at: string
          source: string
        }
        Insert: {
          competitor_name: string
          content_analyzed?: string | null
          detected_trends?: Json | null
          id?: string
          logged_at?: string
          source: string
        }
        Update: {
          competitor_name?: string
          content_analyzed?: string | null
          detected_trends?: Json | null
          id?: string
          logged_at?: string
          source?: string
        }
        Relationships: []
      }
      ai_gamification_draws: {
        Row: {
          created_at: string
          draw_date: string | null
          id: string
          prize: string
          product_id: string | null
          rules: string | null
          status: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          draw_date?: string | null
          id?: string
          prize: string
          product_id?: string | null
          rules?: string | null
          status?: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          draw_date?: string | null
          id?: string
          prize?: string
          product_id?: string | null
          rules?: string | null
          status?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "ai_gamification_draws_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      ai_personas: {
        Row: {
          created_at: string
          description: string | null
          id: string
          name: string
          preferences: Json | null
          tone: string
          triggers: string[] | null
          updated_at: string
          user_id: string
        }
        Insert: {
          created_at?: string
          description?: string | null
          id?: string
          name: string
          preferences?: Json | null
          tone?: string
          triggers?: string[] | null
          updated_at?: string
          user_id: string
        }
        Update: {
          created_at?: string
          description?: string | null
          id?: string
          name?: string
          preferences?: Json | null
          tone?: string
          triggers?: string[] | null
          updated_at?: string
          user_id?: string
        }
        Relationships: []
      }
      amazon_product_mappings: {
        Row: {
          amazon_current_price: number | null
          amazon_item_id: string
          amazon_original_price: number | null
          amazon_rating: number | null
          amazon_review_count: number | null
          amazon_status: string | null
          created_at: string | null
          id: string
          last_synced_at: string | null
          product_id: string | null
          updated_at: string | null
        }
        Insert: {
          amazon_current_price?: number | null
          amazon_item_id: string
          amazon_original_price?: number | null
          amazon_rating?: number | null
          amazon_review_count?: number | null
          amazon_status?: string | null
          created_at?: string | null
          id?: string
          last_synced_at?: string | null
          product_id?: string | null
          updated_at?: string | null
        }
        Update: {
          amazon_current_price?: number | null
          amazon_item_id?: string
          amazon_original_price?: number | null
          amazon_rating?: number | null
          amazon_review_count?: number | null
          amazon_status?: string | null
          created_at?: string | null
          id?: string
          last_synced_at?: string | null
          product_id?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "amazon_product_mappings_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      api_clients: {
        Row: {
          api_key: string
          client_name: string
          created_at: string
          id: string
          is_active: boolean
          updated_at: string
          webhook_events: string[] | null
          webhook_url: string | null
        }
        Insert: {
          api_key: string
          client_name: string
          created_at?: string
          id?: string
          is_active?: boolean
          updated_at?: string
          webhook_events?: string[] | null
          webhook_url?: string | null
        }
        Update: {
          api_key?: string
          client_name?: string
          created_at?: string
          id?: string
          is_active?: boolean
          updated_at?: string
          webhook_events?: string[] | null
          webhook_url?: string | null
        }
        Relationships: []
      }
      banners: {
        Row: {
          created_at: string
          cta_text: string | null
          id: string
          image_url: string
          is_active: boolean
          link_url: string | null
          sort_order: number
          subtitle: string | null
          title: string | null
          updated_at: string
        }
        Insert: {
          created_at?: string
          cta_text?: string | null
          id?: string
          image_url: string
          is_active?: boolean
          link_url?: string | null
          sort_order?: number
          subtitle?: string | null
          title?: string | null
          updated_at?: string
        }
        Update: {
          created_at?: string
          cta_text?: string | null
          id?: string
          image_url?: string
          is_active?: boolean
          link_url?: string | null
          sort_order?: number
          subtitle?: string | null
          title?: string | null
          updated_at?: string
        }
        Relationships: []
      }
      brands: {
        Row: {
          created_at: string
          id: string
          name: string
        }
        Insert: {
          created_at?: string
          id?: string
          name: string
        }
        Update: {
          created_at?: string
          id?: string
          name?: string
        }
        Relationships: []
      }
      categories: {
        Row: {
          created_at: string
          icon: string | null
          id: string
          name: string
          slug: string
        }
        Insert: {
          created_at?: string
          icon?: string | null
          id?: string
          name: string
          slug: string
        }
        Update: {
          created_at?: string
          icon?: string | null
          id?: string
          name?: string
          slug?: string
        }
        Relationships: []
      }
      coupon_votes: {
        Row: {
          coupon_id: string
          created_at: string | null
          id: string
          is_working: boolean
          session_token: string
        }
        Insert: {
          coupon_id: string
          created_at?: string | null
          id?: string
          is_working: boolean
          session_token: string
        }
        Update: {
          coupon_id?: string
          created_at?: string | null
          id?: string
          is_working?: boolean
          session_token?: string
        }
        Relationships: [
          {
            foreignKeyName: "coupon_votes_coupon_id_fkey"
            columns: ["coupon_id"]
            isOneToOne: false
            referencedRelation: "coupons"
            referencedColumns: ["id"]
          },
        ]
      }
      coupons: {
        Row: {
          active: boolean | null
          code: string
          conditions: string | null
          created_at: string | null
          description: string | null
          discount_amount: string | null
          discount_value: string | null
          id: string
          is_link_only: boolean | null
          link_url: string | null
          platform_id: string | null
          reports_inactive: number | null
          subtitle: string | null
          title: string
          updated_at: string
        }
        Insert: {
          active?: boolean | null
          code?: string
          conditions?: string | null
          created_at?: string | null
          description?: string | null
          discount_amount?: string | null
          discount_value?: string | null
          id?: string
          is_link_only?: boolean | null
          link_url?: string | null
          platform_id?: string | null
          reports_inactive?: number | null
          subtitle?: string | null
          title?: string
          updated_at?: string
        }
        Update: {
          active?: boolean | null
          code?: string
          conditions?: string | null
          created_at?: string | null
          description?: string | null
          discount_amount?: string | null
          discount_value?: string | null
          id?: string
          is_link_only?: boolean | null
          link_url?: string | null
          platform_id?: string | null
          reports_inactive?: number | null
          subtitle?: string | null
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "coupons_platform_id_fkey"
            columns: ["platform_id"]
            isOneToOne: false
            referencedRelation: "platforms"
            referencedColumns: ["id"]
          },
        ]
      }
      email_queue: {
        Row: {
          created_at: string | null
          html_content: string | null
          id: string
          status: string | null
          subject: string
          user_id: string | null
        }
        Insert: {
          created_at?: string | null
          html_content?: string | null
          id?: string
          status?: string | null
          subject: string
          user_id?: string | null
        }
        Update: {
          created_at?: string | null
          html_content?: string | null
          id?: string
          status?: string | null
          subject?: string
          user_id?: string | null
        }
        Relationships: []
      }
      institutional_pages: {
        Row: {
          active: boolean | null
          content_html: string | null
          created_at: string | null
          id: string
          section_type: string | null
          slug: string
          title: string
        }
        Insert: {
          active?: boolean | null
          content_html?: string | null
          created_at?: string | null
          id?: string
          section_type?: string | null
          slug: string
          title: string
        }
        Update: {
          active?: boolean | null
          content_html?: string | null
          created_at?: string | null
          id?: string
          section_type?: string | null
          slug?: string
          title?: string
        }
        Relationships: []
      }
      links: {
        Row: {
          created_at: string
          icon_url: string | null
          id: string
          is_active: boolean
          sort_order: number
          title: string
          url: string
        }
        Insert: {
          created_at?: string
          icon_url?: string | null
          id?: string
          is_active?: boolean
          sort_order?: number
          title: string
          url: string
        }
        Update: {
          created_at?: string
          icon_url?: string | null
          id?: string
          is_active?: boolean
          sort_order?: number
          title?: string
          url?: string
        }
        Relationships: []
      }
      ml_product_mappings: {
        Row: {
          created_at: string | null
          id: string
          last_synced_at: string | null
          ml_available_quantity: number | null
          ml_category_id: string | null
          ml_condition: string | null
          ml_current_price: number | null
          ml_item_id: string
          ml_original_price: number | null
          ml_permalink: string | null
          ml_rating_average: number | null
          ml_rating_count: number | null
          ml_seller_id: string | null
          ml_sold_quantity: number | null
          ml_status: string | null
          ml_thumbnail: string | null
          product_id: string
          sync_status: string | null
        }
        Insert: {
          created_at?: string | null
          id?: string
          last_synced_at?: string | null
          ml_available_quantity?: number | null
          ml_category_id?: string | null
          ml_condition?: string | null
          ml_current_price?: number | null
          ml_item_id: string
          ml_original_price?: number | null
          ml_permalink?: string | null
          ml_rating_average?: number | null
          ml_rating_count?: number | null
          ml_seller_id?: string | null
          ml_sold_quantity?: number | null
          ml_status?: string | null
          ml_thumbnail?: string | null
          product_id: string
          sync_status?: string | null
        }
        Update: {
          created_at?: string | null
          id?: string
          last_synced_at?: string | null
          ml_available_quantity?: number | null
          ml_category_id?: string | null
          ml_condition?: string | null
          ml_current_price?: number | null
          ml_item_id?: string
          ml_original_price?: number | null
          ml_permalink?: string | null
          ml_rating_average?: number | null
          ml_rating_count?: number | null
          ml_seller_id?: string | null
          ml_sold_quantity?: number | null
          ml_status?: string | null
          ml_thumbnail?: string | null
          product_id?: string
          sync_status?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "ml_product_mappings_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      ml_sync_logs: {
        Row: {
          completed_at: string | null
          created_at: string | null
          error_message: string | null
          id: string
          items_deactivated: number | null
          items_processed: number | null
          items_updated: number | null
          status: string
          sync_type: string
          triggered_by: string | null
        }
        Insert: {
          completed_at?: string | null
          created_at?: string | null
          error_message?: string | null
          id?: string
          items_deactivated?: number | null
          items_processed?: number | null
          items_updated?: number | null
          status?: string
          sync_type: string
          triggered_by?: string | null
        }
        Update: {
          completed_at?: string | null
          created_at?: string | null
          error_message?: string | null
          id?: string
          items_deactivated?: number | null
          items_processed?: number | null
          items_updated?: number | null
          status?: string
          sync_type?: string
          triggered_by?: string | null
        }
        Relationships: []
      }
      ml_tokens: {
        Row: {
          access_token: string
          created_at: string | null
          expires_at: string
          id: string
          ml_user_id: string | null
          refresh_token: string
          updated_at: string | null
          user_id: string
        }
        Insert: {
          access_token: string
          created_at?: string | null
          expires_at: string
          id?: string
          ml_user_id?: string | null
          refresh_token: string
          updated_at?: string | null
          user_id: string
        }
        Update: {
          access_token?: string
          created_at?: string | null
          expires_at?: string
          id?: string
          ml_user_id?: string | null
          refresh_token?: string
          updated_at?: string | null
          user_id?: string
        }
        Relationships: []
      }
      models: {
        Row: {
          brand_id: string
          created_at: string
          id: string
          name: string
        }
        Insert: {
          brand_id: string
          created_at?: string
          id?: string
          name: string
        }
        Update: {
          brand_id?: string
          created_at?: string
          id?: string
          name?: string
        }
        Relationships: [
          {
            foreignKeyName: "models_brand_id_fkey"
            columns: ["brand_id"]
            isOneToOne: false
            referencedRelation: "brands"
            referencedColumns: ["id"]
          },
        ]
      }
      newsletter_products: {
        Row: {
          id: string
          newsletter_id: string
          product_id: string
        }
        Insert: {
          id?: string
          newsletter_id: string
          product_id: string
        }
        Update: {
          id?: string
          newsletter_id?: string
          product_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "newsletter_products_newsletter_id_fkey"
            columns: ["newsletter_id"]
            isOneToOne: false
            referencedRelation: "newsletters"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "newsletter_products_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      newsletters: {
        Row: {
          created_at: string | null
          html_content: string | null
          id: string
          status: string | null
          subject: string
        }
        Insert: {
          created_at?: string | null
          html_content?: string | null
          id?: string
          status?: string | null
          subject: string
        }
        Update: {
          created_at?: string | null
          html_content?: string | null
          id?: string
          status?: string | null
          subject?: string
        }
        Relationships: []
      }
      platforms: {
        Row: {
          created_at: string
          id: string
          logo_url: string | null
          name: string
        }
        Insert: {
          created_at?: string
          id?: string
          logo_url?: string | null
          name: string
        }
        Update: {
          created_at?: string
          id?: string
          logo_url?: string | null
          name?: string
        }
        Relationships: []
      }
      price_history: {
        Row: {
          created_at: string | null
          id: string
          price: number
          product_id: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          price: number
          product_id: string
        }
        Update: {
          created_at?: string | null
          id?: string
          price?: number
          product_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "price_history_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      product_clicks: {
        Row: {
          created_at: string | null
          id: string
          product_id: string
          session_token: string | null
          user_id: string | null
        }
        Insert: {
          created_at?: string | null
          id?: string
          product_id: string
          session_token?: string | null
          user_id?: string | null
        }
        Update: {
          created_at?: string | null
          id?: string
          product_id?: string
          session_token?: string | null
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "product_clicks_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      product_likes: {
        Row: {
          created_at: string
          id: string
          product_id: string
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          product_id: string
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          product_id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "product_likes_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      product_trust_votes: {
        Row: {
          created_at: string | null
          id: string
          is_trusted: boolean
          product_id: string
          session_token: string | null
          user_id: string | null
        }
        Insert: {
          created_at?: string | null
          id?: string
          is_trusted?: boolean
          product_id: string
          session_token?: string | null
          user_id?: string | null
        }
        Update: {
          created_at?: string | null
          id?: string
          is_trusted?: boolean
          product_id?: string
          session_token?: string | null
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "product_trust_votes_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      products: {
        Row: {
          affiliate_url: string
          ai_content_metadata: Json | null
          available_quantity: number | null
          badge: string | null
          brand_id: string | null
          category: string
          category_id: string | null
          clicks: number
          commission_rate: number | null
          created_at: string
          created_by: string | null
          description: string | null
          discount: number | null
          discount_percentage: number | null
          external_id: string | null
          extra_metadata: Json | null
          features: Json | null
          gallery_urls: string[] | null
          id: string
          image_url: string | null
          is_active: boolean
          model_id: string | null
          original_price: number | null
          platform_id: string | null
          price: number
          rating: number
          registered_by: string | null
          review_count: number
          sales_count: number | null
          store: string
          title: string
          updated_at: string
          video_url: string | null
        }
        Insert: {
          affiliate_url: string
          ai_content_metadata?: Json | null
          available_quantity?: number | null
          badge?: string | null
          brand_id?: string | null
          category?: string
          category_id?: string | null
          clicks?: number
          commission_rate?: number | null
          created_at?: string
          created_by?: string | null
          description?: string | null
          discount?: number | null
          discount_percentage?: number | null
          external_id?: string | null
          extra_metadata?: Json | null
          features?: Json | null
          gallery_urls?: string[] | null
          id?: string
          image_url?: string | null
          is_active?: boolean
          model_id?: string | null
          original_price?: number | null
          platform_id?: string | null
          price: number
          rating?: number
          registered_by?: string | null
          review_count?: number
          sales_count?: number | null
          store: string
          title: string
          updated_at?: string
          video_url?: string | null
        }
        Update: {
          affiliate_url?: string
          ai_content_metadata?: Json | null
          available_quantity?: number | null
          badge?: string | null
          brand_id?: string | null
          category?: string
          category_id?: string | null
          clicks?: number
          commission_rate?: number | null
          created_at?: string
          created_by?: string | null
          description?: string | null
          discount?: number | null
          discount_percentage?: number | null
          external_id?: string | null
          extra_metadata?: Json | null
          features?: Json | null
          gallery_urls?: string[] | null
          id?: string
          image_url?: string | null
          is_active?: boolean
          model_id?: string | null
          original_price?: number | null
          platform_id?: string | null
          price?: number
          rating?: number
          registered_by?: string | null
          review_count?: number
          sales_count?: number | null
          store?: string
          title?: string
          updated_at?: string
          video_url?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "products_brand_id_fkey"
            columns: ["brand_id"]
            isOneToOne: false
            referencedRelation: "brands"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "products_category_id_fkey"
            columns: ["category_id"]
            isOneToOne: false
            referencedRelation: "categories"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "products_model_id_fkey"
            columns: ["model_id"]
            isOneToOne: false
            referencedRelation: "models"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "products_platform_id_fkey"
            columns: ["platform_id"]
            isOneToOne: false
            referencedRelation: "platforms"
            referencedColumns: ["id"]
          },
        ]
      }
      profiles: {
        Row: {
          avatar_url: string | null
          created_at: string
          full_name: string | null
          id: string
          is_active: boolean
          newsletter_opt_in: boolean
          price_alert_opt_in: boolean
          updated_at: string
          user_id: string
        }
        Insert: {
          avatar_url?: string | null
          created_at?: string
          full_name?: string | null
          id?: string
          is_active?: boolean
          newsletter_opt_in?: boolean
          price_alert_opt_in?: boolean
          updated_at?: string
          user_id: string
        }
        Update: {
          avatar_url?: string | null
          created_at?: string
          full_name?: string | null
          id?: string
          is_active?: boolean
          newsletter_opt_in?: boolean
          price_alert_opt_in?: boolean
          updated_at?: string
          user_id?: string
        }
        Relationships: []
      }
      reports: {
        Row: {
          created_at: string
          id: string
          product_id: string
          report_type: string
          reporter_email: string
          resolved_by: string | null
          status: string
        }
        Insert: {
          created_at?: string
          id?: string
          product_id: string
          report_type: string
          reporter_email: string
          resolved_by?: string | null
          status?: string
        }
        Update: {
          created_at?: string
          id?: string
          product_id?: string
          report_type?: string
          reporter_email?: string
          resolved_by?: string | null
          status?: string
        }
        Relationships: [
          {
            foreignKeyName: "reports_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      reviews: {
        Row: {
          comment: string | null
          created_at: string
          helpful_count: number
          id: string
          product_id: string
          rating: number
          status: string
          user_id: string | null
          user_name: string
        }
        Insert: {
          comment?: string | null
          created_at?: string
          helpful_count?: number
          id?: string
          product_id: string
          rating: number
          status?: string
          user_id?: string | null
          user_name: string
        }
        Update: {
          comment?: string | null
          created_at?: string
          helpful_count?: number
          id?: string
          product_id?: string
          rating?: number
          status?: string
          user_id?: string | null
          user_name?: string
        }
        Relationships: [
          {
            foreignKeyName: "reviews_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      search_cache: {
        Row: {
          created_at: string | null
          data: Json
          expires_at: string | null
          id: string
          keyword: string
          offset_val: number
        }
        Insert: {
          created_at?: string | null
          data: Json
          expires_at?: string | null
          id?: string
          keyword: string
          offset_val: number
        }
        Update: {
          created_at?: string | null
          data?: Json
          expires_at?: string | null
          id?: string
          keyword?: string
          offset_val?: number
        }
        Relationships: []
      }
      shopee_product_mappings: {
        Row: {
          created_at: string | null
          id: string
          last_synced_at: string | null
          offer_valid_from: string | null
          offer_valid_to: string | null
          product_id: string
          shopee_commission_rate: number | null
          shopee_extra_data: Json | null
          shopee_image_url: string | null
          shopee_item_id: string
          shopee_offer_id: string | null
          shopee_product_url: string | null
          shopee_shop_id: string | null
          shopee_short_link: string | null
          sync_status: string | null
        }
        Insert: {
          created_at?: string | null
          id?: string
          last_synced_at?: string | null
          offer_valid_from?: string | null
          offer_valid_to?: string | null
          product_id: string
          shopee_commission_rate?: number | null
          shopee_extra_data?: Json | null
          shopee_image_url?: string | null
          shopee_item_id: string
          shopee_offer_id?: string | null
          shopee_product_url?: string | null
          shopee_shop_id?: string | null
          shopee_short_link?: string | null
          sync_status?: string | null
        }
        Update: {
          created_at?: string | null
          id?: string
          last_synced_at?: string | null
          offer_valid_from?: string | null
          offer_valid_to?: string | null
          product_id?: string
          shopee_commission_rate?: number | null
          shopee_extra_data?: Json | null
          shopee_image_url?: string | null
          shopee_item_id?: string
          shopee_offer_id?: string | null
          shopee_product_url?: string | null
          shopee_shop_id?: string | null
          shopee_short_link?: string | null
          sync_status?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "shopee_product_mappings_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      shopee_sync_logs: {
        Row: {
          completed_at: string | null
          created_at: string | null
          error_message: string | null
          id: string
          items_deactivated: number | null
          items_processed: number | null
          items_updated: number | null
          status: string
          sync_type: string
          triggered_by: string | null
        }
        Insert: {
          completed_at?: string | null
          created_at?: string | null
          error_message?: string | null
          id?: string
          items_deactivated?: number | null
          items_processed?: number | null
          items_updated?: number | null
          status?: string
          sync_type: string
          triggered_by?: string | null
        }
        Update: {
          completed_at?: string | null
          created_at?: string | null
          error_message?: string | null
          id?: string
          items_deactivated?: number | null
          items_processed?: number | null
          items_updated?: number | null
          status?: string
          sync_type?: string
          triggered_by?: string | null
        }
        Relationships: []
      }
      special_page_products: {
        Row: {
          id: string
          product_id: string
          special_page_id: string
        }
        Insert: {
          id?: string
          product_id: string
          special_page_id: string
        }
        Update: {
          id?: string
          product_id?: string
          special_page_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "special_page_products_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "special_page_products_special_page_id_fkey"
            columns: ["special_page_id"]
            isOneToOne: false
            referencedRelation: "special_pages"
            referencedColumns: ["id"]
          },
        ]
      }
      special_pages: {
        Row: {
          active: boolean
          created_at: string
          description: string | null
          id: string
          slug: string
          title: string
        }
        Insert: {
          active?: boolean
          created_at?: string
          description?: string | null
          id?: string
          slug: string
          title: string
        }
        Update: {
          active?: boolean
          created_at?: string
          description?: string | null
          id?: string
          slug?: string
          title?: string
        }
        Relationships: []
      }
      user_roles: {
        Row: {
          id: string
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Insert: {
          id?: string
          role?: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Update: {
          id?: string
          role?: Database["public"]["Enums"]["app_role"]
          user_id?: string
        }
        Relationships: []
      }
      webhook_logs: {
        Row: {
          api_client_id: string
          created_at: string
          endpoint_url: string
          id: string
          payload: Json | null
          response_body: string | null
          status_code: number | null
        }
        Insert: {
          api_client_id: string
          created_at?: string
          endpoint_url: string
          id?: string
          payload?: Json | null
          response_body?: string | null
          status_code?: number | null
        }
        Update: {
          api_client_id?: string
          created_at?: string
          endpoint_url?: string
          id?: string
          payload?: Json | null
          response_body?: string | null
          status_code?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "webhook_logs_api_client_id_fkey"
            columns: ["api_client_id"]
            isOneToOne: false
            referencedRelation: "api_clients"
            referencedColumns: ["id"]
          },
        ]
      }
      whatsapp_groups: {
        Row: {
          active: boolean
          created_at: string
          id: string
          link: string
          name: string | null
        }
        Insert: {
          active?: boolean
          created_at?: string
          id?: string
          link: string
          name?: string | null
        }
        Update: {
          active?: boolean
          created_at?: string
          id?: string
          link?: string
          name?: string | null
        }
        Relationships: []
      }
      wishlists: {
        Row: {
          created_at: string
          id: string
          price_when_favorited: number | null
          product_id: string
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          price_when_favorited?: number | null
          product_id: string
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          price_when_favorited?: number | null
          product_id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "wishlists_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      admin_users_view: {
        Row: {
          avatar_url: string | null
          created_at: string | null
          email: string | null
          full_name: string | null
          is_active: boolean | null
          profile_id: string | null
          role: Database["public"]["Enums"]["app_role"] | null
          user_id: string | null
        }
        Relationships: []
      }
    }
    Functions: {
      admin_delete_user: {
        Args: { target_user_id: string }
        Returns: undefined
      }
      admin_update_user_email: {
        Args: { new_email: string; target_user_id: string }
        Returns: undefined
      }
      admin_update_user_role: {
        Args: {
          new_role: Database["public"]["Enums"]["app_role"]
          target_user_id: string
        }
        Returns: undefined
      }
      generate_price_alerts: { Args: never; Returns: number }
      has_role: {
        Args: {
          _role: Database["public"]["Enums"]["app_role"]
          _user_id: string
        }
        Returns: boolean
      }
    }
    Enums: {
      ai_ab_test_status: "RUNNING" | "COMPLETED" | "CANCELLED"
      ai_campaign_status: "ACTIVE" | "DRAFT" | "EXPIRED"
      ai_campaign_type:
        | "EASTER"
        | "MOTHERS_DAY"
        | "FATHERS_DAY"
        | "VALENTINES_DAY"
        | "BLACK_FRIDAY"
        | "CYBER_MONDAY"
        | "CHRISTMAS"
        | "NEW_YEAR"
        | "CARNIVAL"
        | "BACK_TO_SCHOOL"
        | "CUSTOM"
      app_role: "admin" | "editor" | "viewer"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      ai_ab_test_status: ["RUNNING", "COMPLETED", "CANCELLED"],
      ai_campaign_status: ["ACTIVE", "DRAFT", "EXPIRED"],
      ai_campaign_type: [
        "EASTER",
        "MOTHERS_DAY",
        "FATHERS_DAY",
        "VALENTINES_DAY",
        "BLACK_FRIDAY",
        "CYBER_MONDAY",
        "CHRISTMAS",
        "NEW_YEAR",
        "CARNIVAL",
        "BACK_TO_SCHOOL",
        "CUSTOM",
      ],
      app_role: ["admin", "editor", "viewer"],
    },
  },
} as const
