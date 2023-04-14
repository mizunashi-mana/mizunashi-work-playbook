import argparse
from . import formatter

def main(args: dict):
  formatter.format(target=args["target"])

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("target", help="A path of target json file")

  main(vars(parser.parse_args()))
