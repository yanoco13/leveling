import os

# ★制作してるフォルダ（プロジェクトの場所に変更）★
BASE_PATH = '/Users/yanoryou/Desktop/project/levelog-arena/'

# 書き出し先
OUTPUT_FILE = os.path.join(BASE_PATH, "project_code.txt")

# 対象にする拡張子
EXTENSIONS = (".js", ".php", ".html", ".css", ".java", ".swift", ".kt", ".xml", ".yaml", ".json", ".rb", ".properties")

def collect_code(base_path):
    code_dict = {}
    for root, dirs, files in os.walk(base_path):
        for file in files:
            if file.endswith(EXTENSIONS):
                path = os.path.join(root, file)
                try:
                    with open(path, "r", encoding="utf-8") as f:
                        code_dict[path] = f.read()
                except Exception as e:
                    code_dict[path] = f"読み込みエラー: {e}"
    return code_dict

if __name__ == "__main__":
    project_code = collect_code(BASE_PATH)
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        for path, code in project_code.items():
            f.write(f"--- {path} ---\n")
            f.write(code + "\n\n")
    print(f"書き出し完了: {OUTPUT_FILE}")