import csv
import json
import argparse
import os

CAT = "category"
LANG = "language"
SOURCE_DIR = "./exercises_csv"
TARGET_DIR = "./exercises_json"

def generate_source_path(category, language):
    return f"{SOURCE_DIR}/wordgame - {category} {language}.csv"

def generate_target_path(category, language):
    cat_snake = category.lower().replace(" ", "_")
    lang_snake = language.lower().replace(" ", "_")
    return f"{TARGET_DIR}/exercises_{cat_snake}_{lang_snake}.json"

def parse_arguments():
    parser = argparse.ArgumentParser()
    for name in (CAT, LANG):
        parser.add_argument(name, help=f"exercise {name}")
    args = vars(parser.parse_args())
    return args[CAT], args[LANG]


def csv_to_json(source_path, target_path):
    with open(source_path, "r", encoding="utf-8", newline="") as source_file:
        r = csv.DictReader(source_file)
        data_as_dicts = [line for line in r]
        data_as_json = json.dumps(data_as_dicts, indent=2, ensure_ascii=False)
        with open(target_path, "w", encoding="utf-8") as target_file:
            target_file.write(data_as_json)

if __name__ == "__main__":
    category, language = parse_arguments()
    source_path = generate_source_path(category, language)
    target_path = generate_target_path(category, language)

    try:
        csv_to_json(source_path, target_path)
        print("Success!")
        print(f"json output in {target_path}")
    except FileNotFoundError:
        cat = f"category: {category}"
        lang = f"language: {language}"
        print(f"csv file for {cat} and {lang} not found:")
