import argparse
from . import compiler

def main(args: dict):
  compiler.compile(args["in"], args["out"])

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("in", help="A path of input cue file")
  parser.add_argument("out", help="A path of output yaml file")

  main(vars(parser.parse_args()))
