# ON Designs CMS setup

The public portfolio remains a static Vercel site. The CMS uses Supabase Auth, Postgres and Storage.

## 1. Configure Supabase
1. Create a Supabase project.
2. Open SQL Editor and run all of `supabase-setup.sql`.
3. In Authentication > Users, add your own user with email/password. Do not enable public sign-ups.
4. Copy that user's UUID. In SQL Editor run:
   `insert into public.admins (user_id) values ('YOUR-AUTH-USER-UUID');`
5. In Project Settings > API, copy the Project URL and the publishable key (or legacy anon key).
6. Replace the two placeholders in `config.js`. Never put a service_role/secret key in frontend files.

## 2. Deploy
Commit and push the files to the `main` branch. Vercel should deploy automatically. The dashboard will be at `/admin.html`.

## 3. Use the CMS
Sign in at `https://YOUR-DOMAIN/admin.html`. Add a project, choose its category, upload JPG/PNG/WebP artwork (up to 8 MB), and choose whether it is published. Published records appear in the public gallery. Drafts remain private.

## Security
- There is no sign-up form in the admin interface.
- The `admins` table is an allowlist; only a user UUID inserted by the project owner is an administrator.
- Row Level Security restricts all project writes and Storage uploads to allowlisted users.
- The browser key is publishable/anon only; database policies provide authorization.
