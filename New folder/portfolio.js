const gallery=document.getElementById('gallery'),follow=document.getElementById('follow'),modal=document.getElementById('modal'),modalImage=document.getElementById('mimg');
const categories={thumbnails:'THUMB<br><em>NAILS</em>',posters:'SOCIAL<br><em>POSTERS</em>',flyers:'FLY<br><em>ERS</em>',banners:'BANN<br><em>ERS</em>',events:'EVENT<br><em>POSTERS</em>',all:'SELECTED<br><em>WORK</em>'};
let projects=[],activeCategory='all',lastFocus=null;
let galleryFrame=0;
function layoutGallery(){
 if(!gallery.classList.contains('is-masonry'))return;
 const style=getComputedStyle(gallery),row=parseFloat(style.gridAutoRows)||4,gap=parseFloat(style.getPropertyValue('--card-gap'))||32;
 const cards=Array.from(gallery.querySelectorAll('.card'));
 const spans=cards.map(card=>Math.ceil((card.offsetHeight+gap)/row));
 cards.forEach((card,i)=>{const span='span '+spans[i];if(card.style.gridRowEnd!==span)card.style.gridRowEnd=span;});
}
function scheduleGalleryLayout(){if(galleryFrame)return;galleryFrame=requestAnimationFrame(()=>{galleryFrame=0;layoutGallery();});}
const galleryObserver=typeof ResizeObserver==='undefined'?null:new ResizeObserver(scheduleGalleryLayout);
function resetGallery(){galleryObserver?.disconnect();gallery.classList.remove('is-masonry');gallery.replaceChildren();}
window.addEventListener('resize',scheduleGalleryLayout,{passive:true});
document.fonts?.ready.then(scheduleGalleryLayout);
function openProject(p){lastFocus=document.activeElement;document.getElementById('mmeta').textContent=p.category==='events'?'EVENT POSTER':p.category.toUpperCase();document.getElementById('mtitle').textContent=p.title;modalImage.src=p.image_url;modalImage.alt=p.title;document.getElementById('mdesc').textContent=p.description||'';modal.classList.add('open');document.body.classList.add('modal-open');document.getElementById('close').focus();}
function closeProject(){modal.classList.remove('open');document.body.classList.remove('modal-open');lastFocus?.focus();}
function render(){
 document.querySelectorAll('.cat').forEach(btn=>{const active=btn.dataset.filter===activeCategory;btn.classList.toggle('active',active);btn.setAttribute('aria-pressed',String(active));});
 document.getElementById('workTitle').innerHTML=categories[activeCategory];
 resetGallery();
 const shown=projects.filter(p=>activeCategory==='all'||p.category===activeCategory);
 if(!shown.length){const empty=document.createElement('p');empty.className='gallery-empty';empty.textContent='New work is coming to this category soon.';gallery.append(empty);return;}
 shown.forEach((p,i)=>{
  const card=document.createElement('article');card.className='card';card.dataset.category=p.category;
  const img=document.createElement('img');img.alt=p.title;img.loading='lazy';img.decoding='async';
  if(p.category!=='thumbnails')img.style.aspectRatio=p.category==='flyers'?'707 / 1000':p.category==='banners'||p.category==='events'?'2 / 3':'1 / 1';
  const fitArtwork=()=>{if(p.category!=='thumbnails'&&img.naturalWidth&&img.naturalHeight)img.style.aspectRatio=img.naturalWidth+' / '+img.naturalHeight;scheduleGalleryLayout();};
  img.addEventListener('load',fitArtwork);img.addEventListener('error',scheduleGalleryLayout);img.src=p.image_url;if(img.complete)fitArtwork();
  const num=document.createElement('b');num.textContent=String(i+1).padStart(2,'0');
  const title=document.createElement('span');title.textContent=p.title;
  const type=document.createElement('i');type.className='type';type.textContent=p.category==='events'?'EVENT POSTER':p.category.toUpperCase().replace(/S$/,'');
  card.tabIndex=0;card.setAttribute('role','button');card.setAttribute('aria-label','View '+p.title);card.append(img,num,title,type);
  card.addEventListener('click',()=>openProject(p));card.addEventListener('keydown',e=>{if(e.key==='Enter'||e.key===' '){e.preventDefault();openProject(p);}});
  card.addEventListener('mouseenter',()=>follow.style.transform='translate(-50%,-50%) scale(1)');card.addEventListener('mouseleave',()=>follow.style.transform='translate(-50%,-50%) scale(0)');
  gallery.append(card);galleryObserver?.observe(card);
 });
 gallery.classList.add('is-masonry');scheduleGalleryLayout();
}
function load(){projects=window.ON_DESIGNS_DATA.projects;render();}
document.querySelectorAll('.cat[data-filter]').forEach(b=>b.addEventListener('click',()=>{activeCategory=b.dataset.filter;render();b.scrollIntoView?.({behavior:matchMedia('(prefers-reduced-motion:reduce)').matches?'auto':'smooth',block:'nearest',inline:'nearest'});}));
document.addEventListener('pointermove',e=>{follow.style.left=e.clientX+'px';follow.style.top=e.clientY+'px';});document.getElementById('close').addEventListener('click',closeProject);document.querySelector('.modal-bg').addEventListener('click',closeProject);
document.addEventListener('keydown',e=>{if(!modal.classList.contains('open'))return;if(e.key==='Escape')closeProject();if(e.key==='Tab'){e.preventDefault();document.getElementById('close').focus();}});
const menu=document.getElementById('menu'),navigation=document.getElementById('navigation');menu.addEventListener('click',()=>{const open=navigation.classList.toggle('is-open');menu.setAttribute('aria-expanded',String(open));menu.textContent=open?'Close':'Menu';});navigation.querySelectorAll('a').forEach(a=>a.addEventListener('click',()=>{navigation.classList.remove('is-open');menu.setAttribute('aria-expanded','false');menu.textContent='Menu';}));
function loadContact(){
 const email=window.ON_DESIGNS_DATA.contact_email,a=document.getElementById('contactLink');
 if(email){a.href='mailto:'+email;a.setAttribute('aria-label','Start a conversation by email');}
 else{a.removeAttribute('href');a.textContent='Contact details coming soon';}
}
load();loadContact();
window.addEventListener('pageshow',scheduleGalleryLayout);
