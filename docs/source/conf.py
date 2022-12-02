# Configuration file for the Sphinx documentation builder.

import sys
import os
# -- Project information

project = 'Oxime-Biocatalysis'
copyright = '2022, Amit'
author = 'Amit'

release = '0.1'
version = '0.1.0'

# -- General configuration

extensions = [
    'sphinx.ext.duration',
    'sphinx.ext.doctest',
    'sphinx.ext.autodoc',
    'sphinx.ext.autosummary',
    'sphinx.ext.intersphinx',
#    'sphinx.ext.imgmath',
]

# sphinx.ext.imgmath setup
#html_math_renderer = 'imgmath'
#imgmath_image_format = 'svg'
#imgmath_font_size = 14
# sphinx.ext.imgmath setup END

intersphinx_mapping = {
    'python': ('https://docs.python.org/3/', None),
    'sphinx': ('https://www.sphinx-doc.org/en/master/', None),
}
intersphinx_disabled_domains = ['std']

templates_path = ['_templates']

# Option for Latex
#latex_engine = 'xelatex'
#latex_elements = {
#    'extrapackages': r'\usepackage{chemfig}',
#    'extrapackages': r'\usepackage[dvipdfmx]{graphicx}',
#}


# -- Options for HTML output

html_theme = 'sphinx_rtd_theme'

# -- Options for EPUB output
epub_show_urls = 'footnote'
