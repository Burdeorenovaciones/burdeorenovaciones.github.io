(() => {
  const SOCIALS = [
    { name: 'Instagram', url: 'https://www.instagram.com/burdeorenovaciones/', icon: 'fa-instagram' },
    { name: 'Facebook', url: 'https://www.facebook.com/burdeorenueva/', icon: 'fa-facebook-f' },
    { name: 'YouTube', url: 'https://www.youtube.com/@BurdeoRenovaciones', icon: 'fa-youtube' },
    { name: 'TikTok', url: 'https://www.tiktok.com/@burdeorenovaciones', icon: 'fa-tiktok' }
  ];

  function ensureFontAwesome() {
    if (document.querySelector('link[href*="font-awesome"], link[href*="fontawesome"]')) return;
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css';
    link.crossOrigin = 'anonymous';
    document.head.appendChild(link);
  }

  function makeLinks(className) {
    const box = document.createElement('div');
    box.className = className;
    box.setAttribute('aria-label', 'Redes sociales de Burdeo Renovaciones');
    SOCIALS.forEach(({ name, url, icon }) => {
      const a = document.createElement('a');
      a.href = url;
      a.target = '_blank';
      a.rel = 'noopener noreferrer';
      a.setAttribute('aria-label', name + ' de Burdeo Renovaciones');
      a.title = name;
      a.innerHTML = '<i class="fab ' + icon + '" aria-hidden="true"></i><span class="sr-only">' + name + '</span>';
      box.appendChild(a);
    });
    return box;
  }

  function addStyles() {
    if (document.getElementById('burdeo-social-nav-styles')) return;
    const style = document.createElement('style');
    style.id = 'burdeo-social-nav-styles';
    style.textContent = `
      .burdeo-social-nav{display:flex;align-items:center;gap:7px;flex:0 0 auto;margin-left:24px;padding-left:22px;border-left:1px solid rgba(128,0,32,.18)}
      .burdeo-social-nav + .nav-links,.burdeo-social-nav + .br-nav-links{margin-left:auto!important}
      .burdeo-social-nav a,.burdeo-social-mobile a{width:34px;height:34px;display:inline-flex;align-items:center;justify-content:center;border-radius:50%;border:1px solid rgba(128,0,32,.22);background:#fff;color:#800020!important;text-decoration:none!important;font-size:14px;line-height:1;transition:background .2s ease,color .2s ease,transform .2s ease,border-color .2s ease,box-shadow .2s ease}
      .burdeo-social-nav a:hover,.burdeo-social-nav a:focus-visible,.burdeo-social-mobile a:hover,.burdeo-social-mobile a:focus-visible{background:#800020;color:#fff!important;border-color:#800020;transform:translateY(-2px);box-shadow:0 5px 12px rgba(128,0,32,.16);outline:none}
      .burdeo-social-mobile{display:none}
      .burdeo-social-label{width:100%;margin:2px 0 8px;color:#76706d;font-size:11px;font-weight:700;letter-spacing:.12em;text-transform:uppercase;text-align:center}
      @media (max-width:1100px) and (min-width:769px){.burdeo-social-nav{gap:5px;margin-left:14px;padding-left:14px}.burdeo-social-nav a{width:29px;height:29px;font-size:12px}.nav-links,.br-nav-links{gap:18px!important}}
      @media (max-width:768px){.burdeo-social-nav{display:none!important}.burdeo-social-mobile{display:flex;flex-wrap:wrap;align-items:center;justify-content:center;gap:10px;margin-top:8px;padding:14px 8px 8px;border-top:1px solid #eee}.burdeo-social-mobile a{width:38px;height:38px;font-size:15px}}
    `;
    document.head.appendChild(style);
  }

  function init() {
    if (document.querySelector('.burdeo-social-nav')) return;
    const header = document.querySelector('header');
    if (!header) return;
    const nav = header.querySelector('nav') || header.querySelector('.nav-flex') || header.querySelector('.site-nav') || header.querySelector('.br-site-nav');
    if (!nav) return;
    const logo = nav.querySelector('a.logo-img') || nav.querySelector('a.logo-link') || nav.querySelector('a.br-site-logo') || nav.querySelector('a[aria-label*="Burdeo"]') || nav.querySelector('a[aria-label*="Inicio"]');
    if (!logo) return;

    ensureFontAwesome();
    addStyles();

    const desktop = makeLinks('burdeo-social-nav');
    logo.insertAdjacentElement('afterend', desktop);

    const mobileMenu = nav.querySelector('.mobile-menu, .br-mobile-menu');
    if (mobileMenu && !mobileMenu.querySelector('.burdeo-social-mobile')) {
      const label = document.createElement('div');
      label.className = 'burdeo-social-label';
      label.textContent = 'Síguenos';
      const mobile = makeLinks('burdeo-social-mobile');
      const cta = mobileMenu.querySelector('.mobile-cta, .br-mobile-cta');
      if (cta) {
        mobileMenu.insertBefore(label, cta);
        mobileMenu.insertBefore(mobile, cta);
      } else {
        mobileMenu.appendChild(label);
        mobileMenu.appendChild(mobile);
      }
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init, { once: true });
  } else {
    init();
  }
})();