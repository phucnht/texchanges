// Strings used by the landing page components. LaTeX command names, package
// names, engine names, and CLI flags stay in English in every locale, because
// they are what the reader types.

export type Locale = 'en' | 'vi' | 'fr';

export function localeFrom(url: URL): Locale {
  const segment = url.pathname.split('/').filter(Boolean)[1];
  return segment === 'vi' || segment === 'fr' ? segment : 'en';
}

export function pathFor(locale: Locale, path: string): string {
  return locale === 'en' ? `/texchanges${path}` : `/texchanges/${locale}${path}`;
}

export const ui = {
  en: {
    navDocs: 'Docs',
    navExamples: 'Examples',
    navCheatsheet: 'Cheatsheet',
    navRoadmap: 'Roadmap',
    heroEyebrow: '% LaTeX-native track changes',
    heroSubtitle: 'Review decisions that live in your source',
    heroTagline:
      'Additions, removals, replacements, comments, and accept or reject decisions written as plain LaTeX. Compile the same file as a marked-up review, as the accepted document, or as the original.',
    ctaStart: 'Start reviewing',
    ctaCheatsheet: 'Cheatsheet',

    introEyebrow: '% what is texchanges',
    introLead:
      'Texchanges gives authors, reviewers, and editing tools one vocabulary for proposing and deciding changes, written directly in the document. Nothing lives in a proprietary format, a sidebar, or a separate service.',

    factsEyebrow: '% at a glance',
    factEngines: 'Engines',
    factEnginesValue: 'pdfTeX, XeTeX, and LuaTeX.',
    factTexlive: 'TeX Live',
    factTexliveValue: '2023 and newer, checked against each of those years in continuous integration.',
    factOverleaf: 'Overleaf',
    factOverleafValue: 'Upload the bundle beside your document. No installation, no admin rights.',
    factDeps: 'Dependencies',
    factDepsValue: 'None beyond a TeX Live installation. The merge tool uses only the Python standard library.',
    factLicence: 'Licence',
    factLicenceValue: 'LPPL 1.3c or later.',
    factDistribution: 'Distribution',
    factDistributionValue: 'CTAN, so tlmgr and MiKTeX can install it directly.',

    featuresEyebrow: '% features',
    f1: 'One source, three documents',
    f1b: 'Compile as review to see the markup, final to read the accepted text, or original to recover what was there before. The file never forks.',
    f2: 'Decisions, not just diffs',
    f2b: 'Every change carries an author, a stable ID, an optional note, and a status of pending, accepted, or rejected. Reviews stay addressable across revisions.',
    f3: 'Reports you can filter',
    f3b: 'Generate a list or a summary of changes, narrowed by type, status, or author, with hyperlinks back to each change.',
    f4: 'Resolve back to clean LaTeX',
    f4b: 'The texchanges-merge tool updates statuses or removes the markup entirely, in place or to a new file, with a dry run first.',
    f5: 'Works where you already write',
    f5b: 'Overleaf, pdfTeX, XeTeX, and LuaTeX, verified in continuous integration against TeX Live 2023 through the current release.',
    f6: 'Migrates from changes',
    f6b: 'An opt-in compatibility layer accepts the changes package commands, so an existing manuscript keeps compiling while you move over.',

    installEyebrow: '% install',
    installOverleafBody: 'Upload texchanges.sty beside your main .tex file, or upload the texchanges-overleaf.zip bundle.',
    installTexliveNote: 'Then load it in the preamble.',
    installOverleafNote: 'Overleaf updates TeX Live on its own schedule, so a new CTAN release can take time to appear.',
    installMiktexNote: 'MiKTeX also installs on first use when the package is missing.',

    demoEyebrow: '% compile one source three ways',
    demoTitle: 'Review decisions without leaving LaTeX',
    demoRendered: 'Rendered document',
    demoComment: 'Clarify the claim before acceptance.',

    closingEyebrow: '% next',
    linkQuickStart: 'Quick start',
    linkAccessible: 'Accessible reviewing',
    linkMigration: 'Coming from changes'
  },

  vi: {
    navDocs: 'Tài liệu',
    navExamples: 'Ví dụ',
    navCheatsheet: 'Tra cứu nhanh',
    navRoadmap: 'Lộ trình',
    heroEyebrow: '% theo dõi thay đổi thuần LaTeX',
    heroSubtitle: 'Quyết định review nằm ngay trong mã nguồn',
    heroTagline:
      'Thêm, xóa, thay thế, ghi chú, cùng quyết định chấp nhận hay từ chối, tất cả viết bằng LaTeX thuần. Cùng một tệp có thể biên dịch thành bản review có đánh dấu, bản đã chấp nhận, hoặc bản gốc.',
    ctaStart: 'Bắt đầu review',
    ctaCheatsheet: 'Tra cứu nhanh',

    introEyebrow: '% texchanges là gì',
    introLead:
      'Texchanges cho tác giả, người review, và công cụ biên tập một bộ từ vựng chung để đề xuất và quyết định thay đổi, viết trực tiếp trong tài liệu. Không có gì nằm trong định dạng độc quyền, thanh bên, hay một dịch vụ riêng.',

    factsEyebrow: '% tổng quan nhanh',
    factEngines: 'Bộ biên dịch',
    factEnginesValue: 'pdfTeX, XeTeX, và LuaTeX.',
    factTexlive: 'TeX Live',
    factTexliveValue: 'Từ 2023 trở lên, được kiểm tra trên từng năm đó trong tích hợp liên tục.',
    factOverleaf: 'Overleaf',
    factOverleafValue: 'Tải gói lên cạnh tài liệu của bạn. Không cần cài đặt, không cần quyền quản trị.',
    factDeps: 'Phụ thuộc',
    factDepsValue: 'Không gì ngoài một bản cài TeX Live. Công cụ hợp nhất chỉ dùng thư viện chuẩn của Python.',
    factLicence: 'Giấy phép',
    factLicenceValue: 'LPPL 1.3c hoặc mới hơn.',
    factDistribution: 'Phân phối',
    factDistributionValue: 'Qua CTAN, nên tlmgr và MiKTeX cài trực tiếp được.',

    featuresEyebrow: '% tính năng',
    f1: 'Một nguồn, ba tài liệu',
    f1b: 'Biên dịch ở chế độ review để thấy đánh dấu, final để đọc bản đã chấp nhận, hoặc original để lấy lại nội dung ban đầu. Tệp không bao giờ bị tách nhánh.',
    f2: 'Quyết định, không chỉ là khác biệt',
    f2b: 'Mỗi thay đổi mang theo tác giả, một ID ổn định, ghi chú tùy chọn, và trạng thái pending, accepted, hoặc rejected. Các review vẫn tham chiếu được qua nhiều lần sửa.',
    f3: 'Báo cáo lọc được',
    f3b: 'Sinh danh sách hoặc bản tóm tắt thay đổi, lọc theo loại, trạng thái, hoặc tác giả, kèm liên kết quay lại từng thay đổi.',
    f4: 'Trả về LaTeX sạch',
    f4b: 'Công cụ texchanges-merge cập nhật trạng thái hoặc gỡ bỏ hoàn toàn phần đánh dấu, ghi đè tại chỗ hoặc ra tệp mới, có thể chạy thử trước.',
    f5: 'Chạy ở nơi bạn đang viết',
    f5b: 'Overleaf, pdfTeX, XeTeX, và LuaTeX, được kiểm chứng trong tích hợp liên tục từ TeX Live 2023 tới bản hiện tại.',
    f6: 'Chuyển từ changes sang',
    f6b: 'Một lớp tương thích tùy chọn nhận các lệnh của gói changes, nên bản thảo sẵn có vẫn biên dịch được trong lúc bạn chuyển dần.',

    installEyebrow: '% cài đặt',
    installOverleafBody: 'Tải texchanges.sty lên cạnh tệp .tex chính, hoặc tải gói texchanges-overleaf.zip.',
    installTexliveNote: 'Sau đó nạp gói trong phần preamble.',
    installOverleafNote: 'Overleaf cập nhật TeX Live theo lịch riêng, nên một bản CTAN mới có thể mất thời gian mới xuất hiện.',
    installMiktexNote: 'MiKTeX cũng tự cài trong lần dùng đầu tiên khi thiếu gói.',

    demoEyebrow: '% một nguồn, ba cách biên dịch',
    demoTitle: 'Quyết định review mà không rời LaTeX',
    demoRendered: 'Tài liệu sau khi dựng',
    demoComment: 'Làm rõ luận điểm trước khi chấp nhận.',

    closingEyebrow: '% tiếp theo',
    linkQuickStart: 'Bắt đầu nhanh',
    linkAccessible: 'Review cho người khiếm thị',
    linkMigration: 'Chuyển từ gói changes'
  },

  fr: {
    navDocs: 'Docs',
    navExamples: 'Exemples',
    navCheatsheet: 'Aide-mémoire',
    navRoadmap: 'Feuille de route',
    heroEyebrow: '% suivi des modifications natif LaTeX',
    heroSubtitle: 'Des décisions de relecture inscrites dans votre source',
    heroTagline:
      'Ajouts, suppressions, remplacements, commentaires et décisions d’acceptation ou de refus, écrits en LaTeX simple. Le même fichier se compile en relecture annotée, en document accepté, ou en version d’origine.',
    ctaStart: 'Commencer la relecture',
    ctaCheatsheet: 'Aide-mémoire',

    introEyebrow: '% qu’est-ce que texchanges',
    introLead:
      'Texchanges donne aux auteurs, aux relecteurs et aux outils d’édition un vocabulaire commun pour proposer et trancher des modifications, écrit directement dans le document. Rien ne réside dans un format propriétaire, un panneau latéral, ou un service séparé.',

    factsEyebrow: '% en bref',
    factEngines: 'Moteurs',
    factEnginesValue: 'pdfTeX, XeTeX et LuaTeX.',
    factTexlive: 'TeX Live',
    factTexliveValue: '2023 et versions ultérieures, vérifiées sur chacune de ces années en intégration continue.',
    factOverleaf: 'Overleaf',
    factOverleafValue: 'Téléversez l’archive à côté de votre document. Aucune installation, aucun droit administrateur.',
    factDeps: 'Dépendances',
    factDepsValue: 'Aucune, hormis une installation TeX Live. L’outil de fusion n’utilise que la bibliothèque standard de Python.',
    factLicence: 'Licence',
    factLicenceValue: 'LPPL 1.3c ou ultérieure.',
    factDistribution: 'Distribution',
    factDistributionValue: 'Via CTAN, donc tlmgr et MiKTeX peuvent l’installer directement.',

    featuresEyebrow: '% fonctionnalités',
    f1: 'Une source, trois documents',
    f1b: 'Compilez en review pour voir le balisage, en final pour lire le texte accepté, ou en original pour retrouver l’état initial. Le fichier n’est jamais dupliqué.',
    f2: 'Des décisions, pas seulement des différences',
    f2b: 'Chaque modification porte un auteur, un identifiant stable, une note facultative et un statut pending, accepted ou rejected. Les relectures restent adressables d’une révision à l’autre.',
    f3: 'Des rapports filtrables',
    f3b: 'Produisez une liste ou un résumé des modifications, filtré par type, statut ou auteur, avec un lien vers chaque modification.',
    f4: 'Retour à du LaTeX propre',
    f4b: 'L’outil texchanges-merge met à jour les statuts ou retire entièrement le balisage, en place ou vers un nouveau fichier, avec une simulation préalable.',
    f5: 'Fonctionne là où vous écrivez déjà',
    f5b: 'Overleaf, pdfTeX, XeTeX et LuaTeX, vérifiés en intégration continue de TeX Live 2023 jusqu’à la version actuelle.',
    f6: 'Migration depuis changes',
    f6b: 'Une couche de compatibilité optionnelle accepte les commandes du paquet changes, afin qu’un manuscrit existant continue de compiler pendant la transition.',

    installEyebrow: '% installation',
    installOverleafBody: 'Téléversez texchanges.sty à côté de votre fichier .tex principal, ou téléversez l’archive texchanges-overleaf.zip.',
    installTexliveNote: 'Chargez ensuite le paquet dans le préambule.',
    installOverleafNote: 'Overleaf met à jour TeX Live selon son propre calendrier, une nouvelle version CTAN peut donc mettre du temps à apparaître.',
    installMiktexNote: 'MiKTeX installe aussi le paquet à la première utilisation lorsqu’il est absent.',

    demoEyebrow: '% une source, trois compilations',
    demoTitle: 'Décider en relecture sans quitter LaTeX',
    demoRendered: 'Document composé',
    demoComment: 'Préciser l’affirmation avant acceptation.',

    closingEyebrow: '% ensuite',
    linkQuickStart: 'Démarrage rapide',
    linkAccessible: 'Relecture accessible',
    linkMigration: 'Venir de changes'
  }
} as const;
