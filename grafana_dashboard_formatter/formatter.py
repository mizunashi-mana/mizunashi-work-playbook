import json
import pathlib
import typing
from collections import OrderedDict

def format(target: pathlib.Path):
  with open(target) as f:
    data = json.load(f)

  formatted_data = format_dashboard_json_object(data)

  with open(target, mode='w') as f:
    json.dump(formatted_data, f, indent=2)

def format_dashboard_json_object(data: typing.Any) -> typing.Any:
  if type(data) is str:
    return data

  if type(data) is int:
    return data

  if type(data) is float:
    return data

  if type(data) is bool:
    return data

  if type(data) is list:
    formatted_data = []
    for item in data:
      formatted_data.append(format_dashboard_json_object(item))

    return formatted_data

  if type(data) is dict:
    sorted_keys = sort_by_defined_order(data.keys(), dashboard_json_keys)

    return OrderedDict(
      [ (key, format_dashboard_json_object(data[key]))
        for key in sorted_keys
        ])

dashboard_json_keys = [
  "id",
  "uid",
  "refId",
  "$$hashKey",
  "builtIn",
  "version",
  "revision",
  "title",
  "description",
  "schemaVersion",
  "pluginVersion",
  "gnetId",
  "name",
  "type",
  "label",
  "tags",
  "links",
  "enable",
  "editable",
  "collapsed",
  "hide",
  "datasource",
  "query",
  "expr",
  "current",
  "style",
  "graphTooltip",
  "format",
  "legendFormat",
  "liveNow",
  "timezone",
  "weekStart",
  "fiscalYearStartMonth",
  "refresh",
  "time",
  "timepicker",
  "annotations",
  "templating",
  "targets",
  "panels",
]

def sort_by_defined_order(keys: list[str], defined_order: list[str]):
  ordered_keys = []

  for defined_key in defined_order:
    if defined_key in keys:
      ordered_keys.append(defined_key)

  for key in keys:
    if not key in defined_order:
      ordered_keys.append(key)

  return ordered_keys
