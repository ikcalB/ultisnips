import re
import sys

BS = '\x7f'

# These keys usually need to be escaped for a testing interface. We therefore
# special case them and handle them as one keystroke everywhere.
SEQUENCE_RE = re.compile(r"(\x1b[LRUDE])")
SEQUENCE_LENGTH = 2
ESC = '\x1bE'
ARR_L = '\x1bL'
ARR_R = '\x1bR'
ARR_U = '\x1bU'
ARR_D = '\x1bD'

# Defined Constants
JF = '?'  # Jump forwards
JB = '+'  # Jump backwards
LS = '@'  # List snippets
EX = '\t'  # EXPAND
EA = '#'  # Expand anonymous

COMPL_KW = chr(24) + chr(14)
COMPL_ACCEPT = chr(25)

PYTHON3 = sys.version_info >= (3, 0)
