import csv
import json

CATEGORIES = ["Animals", "People", "Places", "Good things", "Shopping"]
LANGUAGES = ["English", "Hungarian", "Luganda"]

def get_csv(source_path):
    with open(source_path, "r", encoding="utf-8", newline="") as source_file:
        r = csv.DictReader(source_file)
        data_as_dicts = [line for line in r]
        return data_as_dicts

if __name__ == "__main__":
    with open("exercises.json", "w", encoding="utf-8") as f:
        data = []
        for lang in LANGUAGES:
            for cat in CATEGORIES:
                try:
                    source_path = f"./exercises_csv/wordgame - {cat} {lang}.csv"
                    data += get_csv(source_path)
                    print(f"+: data for {cat} and {lang} added.")
                except FileNotFoundError:
                    print(f"-: csv file for {cat} and {lang} not found.")
        data_as_json = json.dumps(data, indent=2, ensure_ascii=False)
        f.write(data_as_json)
