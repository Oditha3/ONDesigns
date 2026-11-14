// Public Supabase project settings. These values are safe to expose in the browser
// ONLY when the database and Storage RLS policies in supabase-setup.sql are enabled.
window.ON_SUPABASE = {
  url: "https://abxvchrpicwolwsrkrxb.supabase.co",
  anonKey: "sb_publishable_eTHzzKZRg8mdgX8Tdp2eug_Ogc_p_cO"
};
window.ON_SUPABASE_CONFIGURED = !window.ON_SUPABASE.url.startsWith("YOUR_") &&
  !window.ON_SUPABASE.anonKey.startsWith("YOUR_");
