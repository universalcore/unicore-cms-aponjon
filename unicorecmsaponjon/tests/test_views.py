from datetime import datetime
from pyramid import testing

from cms.tests.base import UnicoreTestCase
from unicorecmsaponjon import main
from unicore.content.models import Page, Localisation


class TestViews(UnicoreTestCase):

    def setUp(self):
        self.workspace = self.mk_workspace()

        self.workspace.setup_custom_mapping(Page, {
            'properties': {
                'slug': {
                    'type': 'string',
                    'index': 'not_analyzed',
                },
                'language': {
                    'type': 'string',
                }
            }
        })
        self.workspace.setup_custom_mapping(Localisation, {
            'properties': {
                'locale': {
                    'type': 'string',
                    'index': 'not_analyzed',
                }
            }
        })

        settings = {
            'git.path': self.workspace.working_dir,
            'git.content_repo_url': '',
            'es.index_prefix': self.workspace.index_prefix,
            'cache.enabled': 'false',
            'cache.regions': 'long_term, default_term',
            'cache.long_term.expire': '1',
            'cache.default_term.expire': '1',
            'pyramid.default_locale_name': 'eng_GB',
        }
        self.config = testing.setUp(settings=settings)
        self.app = self.mk_app(self.workspace, settings=settings, main=main)

    def test_homepage_page(self):
        self.create_categories(self.workspace, count=1)

        intro_page = Page({
            'title': 'Homepage Intro Title', 'language': 'eng_GB',
            'description': 'this is the description text',
            'slug': 'homepage-intro', 'content': 'this is the body of work',
            'position': 0, 'modified_at': datetime.utcnow().isoformat()})
        self.workspace.save(intro_page, 'save intro')
        self.workspace.refresh_index()

        def localise_logo(locale, logo_text):
            try:
                [l] = self.workspace.S(Localisation).filter(locale=locale)
                l = l.get_object()
                l = l.update({'logo_text': logo_text})
                self.workspace.save(l, 'Localisation updated')
                self.workspace.refresh_index()
            except ValueError:
                l = self.create_localisation(
                    self.workspace,
                    locale=locale,
                    logo_text=logo_text)
            resp = self.app.get('/?_LOCALE_=%s' % locale, status=200)
            return resp.body

        # check default locale
        resp = self.app.get('/', status=200)
        self.assertTrue(
            '<div id="banner">Advice from experts and parents</div>' in
            resp.body)

        # check locale without translation
        self.assertTrue(
            '<div id="banner">Advice from experts and parents</div>' in
            localise_logo('eng_GB', None))
        self.assertTrue(
            '<div id="banner">Advice from experts and parents</div>' in
            localise_logo('eng_UK', None))
        self.assertTrue(
            '<div id="banner">Advice foo</div>' in
            localise_logo('eng_GB', 'Advice foo'))

        # check locale with translation
        self.assertTrue(
            '<div id="banner">Advice foo</div>' in
            localise_logo('ind_ID', 'Advice foo'))
