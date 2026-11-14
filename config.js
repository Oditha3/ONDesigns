// Public Supabase project settings. These values are safe to expose in the browser
// ONLY when the database and Storage RLS policies in supabase-setup.sql are enabled.
window.ON_SUPABASE = {
  url: "YOUR_SUPABASE_PROJECT_URL",
  anonKey: "YOUR_SUPABASE_PUBLISHABLE_OR_ANON_KEY"
};
window.ON_SUPABASE_CONFIGURED = !window.ON_SUPABASE.url.startsWith("YOUR_") &&
  !window.ON_SUPABASE.anonKey.startsWith("YOUR_");
