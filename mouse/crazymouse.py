# file two.py
import sys


if sys.argv[1:]:
   seconds = sys.argv[1]
   import cli
else:
   import gui