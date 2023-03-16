import subprocess
import yaml
import pathlib
import typing

def compile(cue_file: pathlib.Path, out_file: pathlib.Path):
  data = cue_export_to_yaml(cue_file=cue_file)
  data_translated = translate_vaulted_tag(data=data)

  with open(out_file, mode="w") as f:
    yaml.dump(data_translated, f)

def cue_export_to_yaml(cue_file: pathlib.Path) -> typing.Any:
  proc = subprocess.run(
    ["cue", "export", "--out", "yaml", cue_file],
    capture_output=True,
    text=True
  )
  if proc.returncode != 0:
    print(proc.stderr)
    exit(1)

  return yaml.safe_load(proc.stdout)

def translate_vaulted_tag(data: typing.Any) -> typing.Any:
  if type(data) is str:
    return data

  if type(data) is int:
    return data

  if type(data) is float:
    return data

  if type(data) is bool:
    return data

  if type(data) is list:
    data_translated = []
    for item in data:
      data_translated.append(translate_vaulted_tag(item))

    return data_translated

  if type(data) is dict:
    if list(data.keys()) == ["__ansible_vault"]:
      return Vault(data["__ansible_vault"])
    else:
      data_translated = dict()
      for key, item in data.items():
        data_translated[key] = translate_vaulted_tag(item)

      return data_translated

class Vault:
  def __init__(self, vaulted: str):
    self.vaulted = vaulted

  def __repr__(self):
    return "!vault | %s" % self.vaulted

def vault_representer(dumper, data: Vault):
  return dumper.represent_scalar("!vault", data.vaulted)

yaml.add_representer(Vault, vault_representer)
