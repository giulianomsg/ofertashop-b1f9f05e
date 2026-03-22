const fs = require('fs');
const { createClient } = require('@supabase/supabase-js');

let env = '';
try { env = fs.readFileSync('.env.local', 'utf8'); } catch(e) { env = fs.readFileSync('.env', 'utf8'); }
const vars = {};
env.split('\n').forEach(line => {
  if (line.includes('=')) {
    const [k, v] = line.split('=');
    vars[k.trim()] = v.trim().replace(/"/g, '');
  }
});

const url = vars.VITE_SUPABASE_URL || vars.SUPABASE_URL;
const key = vars.SUPABASE_SERVICE_ROLE_KEY || vars.VITE_SUPABASE_ANON_KEY;
if (!url || !key) {
   console.error("Missing supabase URL or KEY");
   process.exit(1);
}

const supabase = createClient(url, key);

async function run() {
  const { data: latest } = await supabase.from('ml_tokens').select('id').order('updated_at', { ascending: false }).limit(1).single();
  const payload = {
    access_token: 'APP_USR-1311651017806191-032213-be4f61493a3ba829c9dec5dd28ca8e5a-225054608',
    refresh_token: 'TG-69c021923060ea0001dbbb37-225054608',
    expires_at: new Date(Date.now() + 6 * 3600 * 1000).toISOString(),
    updated_at: new Date().toISOString()
  };
  if (latest) {
    const { error } = await supabase.from('ml_tokens').update(payload).eq('id', latest.id);
    console.log(error ? error : "Updated tokens successfully.");
  } else {
    const { error } = await supabase.from('ml_tokens').insert([payload]);
    console.log(error ? error : "Inserted tokens successfully.");
  }
}
run();
