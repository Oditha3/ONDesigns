-- ON Designs: migrate the existing bundled portfolio into the CMS.
-- Safe to run more than once: matching title/category/image rows are not duplicated.
insert into public.projects (title, category, description, image_url, is_published, sort_order)
select v.title, v.category, v.description, v.image_url, v.is_published, v.sort_order
from (values
  ('Pizza Campaign', 'posters', 'Food advertising with a bold product presentation and a clear offer.', 'pizza-poster.webp', true, 1),
  ('Royal Biriyani', 'posters', 'Warm colors and expressive typography for a biriyani promotion.', 'biriyani-poster.webp', true, 2),
  ('Mountain Black — New Year', 'posters', 'A seasonal social campaign for Mountain Black Online Store.', 'new-year.webp', true, 3),
  ('Chamara Weerasingha', 'thumbnails', 'A music thumbnail built around a dynamic portrait composition.', 'chamara-thumbnail.webp', true, 4),
  ('Social Account Reveal', 'thumbnails', 'A vibrant video thumbnail with a strong headline and expressive visual cues.', 'social-thumbnail.webp', true, 5),
  ('Live Music Event', 'banners', 'An event poster bringing the performers, date, and venue into one composition.SAMPLE ONLY!', 'event-poster.png', true, 6),
  ('Burger Promotion', 'flyers', 'A promotional food flyer with product photography, offers, and menu details.', 'burger-flyer.webp', true, 7),
  ('Food Menu', 'banners', 'A restaurant menu that combines readable pricing with rich food imagery.', 'food-menu-banner.png', true, 8),
  ('Biology Class Campaign', 'posters', 'An educational campaign combining science imagery and course information.', 'biology-poster.webp', true, 9),
  ('New Arrival — Shoes', 'posters', 'A pastel footwear advertising concept.', 'shoe-product.webp', true, 10),
  ('Seeking Designer', 'posters', 'A recruitment poster using bold type and an illustrated portrait.', 'seeking-designer.webp', true, 11),
  ('Hot Burger', 'posters', 'A food advertising concept with a strong headline and product image.', 'hot-burger.webp', true, 12),
  ('Vortex Runner', 'posters', 'A colorful athletic footwear promotion.', 'vortex-runner.webp', true, 13),
  ('John — Birthday Tribute', 'posters', 'A portrait-led birthday tribute designed for social media.', 'john-birthday.webp', true, 14),
  ('Pizza Menu Flyer', 'flyers', 'A pizza restaurant flyer combining menu choices, product photography, and a promotional offer.', 'pizza-menu-flyer.webp', true, 15),
  ('Call of Duty — Warzone', 'thumbnails', 'A cinematic gaming thumbnail designed around Call of Duty: Warzone.', 'cod-warzone.webp', true, 16),
  ('Promotional Poster', 'flyers', 'A bold fast-food promotional poster highlighting signature dishes, special burger offers, operating hours, and ordering information.', 'chicken-poster.webp', true, 17)
) as v(title, category, description, image_url, is_published, sort_order)
where not exists (
  select 1
  from public.projects p
  where p.title = v.title
    and p.category = v.category
    and p.image_url = v.image_url
);

-- Confirm the migration count.
select count(*) as total_projects,
       count(*) filter (where is_published) as published_projects
from public.projects;
