import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
dotenv.config({ path: '.env.local' });
if (!process.env.SUPABASE_URL) dotenv.config({ path: '.env' });

const supabase = createClient(
  process.env.SUPABASE_URL || process.env.VITE_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.VITE_SUPABASE_ANON_KEY
);

async function updateToken() {
  const { data: latest, error: fetchErr } = await supabase
    .from('ml_tokens')
    .select('id')
    .order('updated_at', { ascending: false })
    .limit(1)
    .single();

  const payload = {
    access_token: 'APP_USR-1311651017806191-032213-be4f61493a3ba829c9dec5dd28ca8e5a-225054608',
    refresh_token: 'TG-69c021923060ea0001dbbb37-225054608',
    expires_at: new Date(Date.now() + 6 * 3600 * 1000).toISOString(),
    updated_at: new Date().toISOString()
  };

  if (latest) {
    console.log("Updating existing token row:", latest.id);
    const { error } = await supabase.from('ml_tokens').update(payload).eq('id', latest.id);
    if (error) console.error("Error updating:", error);
    else console.log("Success! Token updated.");
  } else {
    console.log("Inserting new token row");
    const { error } = await supabase.from('ml_tokens').insert([payload]);
    if (error) console.error("Error inserting:", error);
    else console.log("Success! Token inserted.");
  }
}
updateToken();
