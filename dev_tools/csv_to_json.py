import csv
import json
import argparse
import os

CAT = "category"
LANG = "language"
ADIR = "assetdir"
DEFAULT_DIR = "../assets/data"

def generate_source_path(category, language):
    return f"wordgame - {category} {language}.csv"

def generate_target_path(asset_dir, category, language):
    return f"{asset_dir}/exercises_{category.lower()}_{language.lower()}.json"

def parse_arguments():
    parser = argparse.ArgumentParser()
    for name in (CAT, LANG):
        parser.add_argument(name, help=f"exercise {name}")
    parser.add_argument(f"--{ADIR}", help=f"asset {ADIR}", default=DEFAULT_DIR)
    args = vars(parser.parse_args())
    return args[CAT], args[LANG], args[ADIR]


def csv_to_json(source_path, target_path):
    with open(source_path, "r", encoding="utf-8", newline="") as source_file:
        r = csv.DictReader(source_file)
        data_as_dicts = [line for line in r]
        data_as_json = json.dumps(data_as_dicts, indent=2, ensure_ascii=False)
        with open(target_path, "w", encoding="utf-8") as target_file:
            target_file.write(data_as_json)

if __name__ == "__main__":
    category, language, assetdir = parse_arguments()
    source_path = generate_source_path(category, language)

    if not os.path.exists(assetdir):
        print(f"The asset path {assetdir} doesn't exist.")
        raise SystemExit(1)
    target_path = generate_target_path(assetdir, category, language)

    try:
        csv_to_json(source_path, target_path)
        print("Success!")
        print(f"json output in {target_path}")
    except FileNotFoundError:
        print(f"csv file for category: {category} and language: {language} not found:")
