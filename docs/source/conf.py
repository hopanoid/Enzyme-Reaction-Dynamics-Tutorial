# Configuration file for the Sphinx documentation builder.

import sys
import os
# -- Project information

project = 'Oxime-Biocatalysis'
copyright = '2023-2025, Amit Singh Sahrawat'
author = 'Amit Singh Sahrawat'

release = '0.1'
version = '0.1.0'

# -- General configuration

extensions = [
    'sphinx.ext.duration',
    'sphinx.ext.extlinks',
]

extlinks = {
    'repo':    ('https://github.com/hopanoid/Enzyme-Reaction-Dynamics-Tutorial/blob/main/%s', '%s'),
    'repodir': ('https://github.com/hopanoid/Enzyme-Reaction-Dynamics-Tutorial/tree/main/%s', '%s'),
}

templates_path = ['_templates']

# Option for Latex
#latex_engine = 'xelatex'
#latex_elements = {
#    'extrapackages': r'\usepackage{chemfig}',
#    'extrapackages': r'\usepackage[dvipdfmx]{graphicx}',
#}


# -- Options for HTML output

html_theme = 'sphinx_rtd_theme'

########## TOC
html_theme_options = {
# Toc options
'collapse_navigation': True,
'sticky_navigation': True,
'navigation_depth': 3,
'includehidden': True,
'titles_only': False
}

# -- Options for EPUB output
epub_show_urls = 'footnote'

### Angstrom symbol
latex_elements = {
#this allows \AA to be used in equations
'preamble': '\\global\\renewcommand{\\AA}{\\text{\\r{A}}}',
}
