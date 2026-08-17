import sitemap from '@astrojs/sitemap';
import starlight from '@astrojs/starlight';
import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://phucnht.github.io',
  base: '/texchanges',
  integrations: [
    sitemap(),
    starlight({
      title: 'Texchanges',
      description: 'LaTeX-native track changes for human and AI-assisted review.',
      // English stays at the site root. Pages that are not translated fall back
      // to English automatically, with Starlight's own notice.
      defaultLocale: 'root',
      locales: {
        root: { label: 'English', lang: 'en' },
        vi: { label: 'Tiếng Việt', lang: 'vi' },
        fr: { label: 'Français', lang: 'fr' }
      },
      favicon: '/favicon.svg',
      social: [{ icon: 'github', label: 'GitHub', href: 'https://github.com/phucnht/texchanges' }],
      editLink: { baseUrl: 'https://github.com/phucnht/texchanges/edit/main/website/' },
      customCss: ['./src/styles/custom.css'],
      components: {
        SiteTitle: './src/components/SiteTitle.astro',
        SocialIcons: './src/components/SocialIcons.astro'
      },
      head: [
        { tag: 'meta', attrs: { property: 'og:image', content: 'https://phucnht.github.io/texchanges/social-card.svg' } },
        { tag: 'meta', attrs: { name: 'theme-color', content: '#fbfbf9' } }
      ],
      sidebar: [
        {
          label: 'Overview',
          translations: { vi: 'Tổng quan', fr: 'Vue d’ensemble' },
          items: ['index', 'roadmap']
        },
        {
          label: 'Start here',
          translations: { vi: 'Bắt đầu', fr: 'Commencer ici' },
          items: ['getting-started/installation', 'getting-started/quick-start', 'getting-started/examples']
        },
        {
          label: 'Guides',
          translations: { vi: 'Hướng dẫn', fr: 'Guides' },
          items: [{ autogenerate: { directory: 'guides' } }]
        },
        {
          label: 'Reference',
          translations: { vi: 'Tham khảo', fr: 'Référence' },
          items: [{ autogenerate: { directory: 'reference' } }]
        },
        {
          label: 'Migration',
          translations: { vi: 'Chuyển đổi', fr: 'Migration' },
          items: ['migration/from-changes']
        }
      ]
    })
  ]
});
