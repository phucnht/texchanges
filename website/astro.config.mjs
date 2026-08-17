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
      favicon: '/favicon.svg',
      social: [{ icon: 'github', label: 'GitHub', href: 'https://github.com/phucnht/texchanges' }],
      editLink: { baseUrl: 'https://github.com/phucnht/texchanges/edit/main/website/' },
      customCss: ['./src/styles/custom.css'],
      components: { SiteTitle: './src/components/SiteTitle.astro' },
      head: [
        { tag: 'meta', attrs: { property: 'og:image', content: 'https://phucnht.github.io/texchanges/social-card.svg' } },
        { tag: 'meta', attrs: { name: 'theme-color', content: '#fbfbf9' } }
      ],
      sidebar: [
        { label: 'Overview', items: ['index', 'roadmap'] },
        { label: 'Start here', items: ['getting-started/installation', 'getting-started/quick-start', 'getting-started/examples'] },
        { label: 'Guides', items: [{ autogenerate: { directory: 'guides' } }] },
        { label: 'Reference', items: [{ autogenerate: { directory: 'reference' } }] },
        { label: 'Migration', items: ['migration/from-changes'] }
      ]
    })
  ]
});
