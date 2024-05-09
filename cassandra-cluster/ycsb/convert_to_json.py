import json
import sys
import re

def convert_ycsb_output_to_json(file_path):
    data = {}
    with open(file_path, 'r') as file:
        current_section = None
        for line in file:
            # Se a linha começa com [, consideramos uma nova seção de métricas
            if line.startswith('['):
                # Extrair o tipo de seção (por exemplo, OVERALL, READ, UPDATE)
                match_section = re.search(r'\[(\w+)\]', line.strip())
                if match_section:
                    current_section = match_section.group(1)
                    data[current_section] = {}
            # Se a linha contiver métricas
            elif current_section:
                # Extrair as métricas
                match_metric = re.findall(r'\[(\w+)\], (\w+), (.+)', line.strip())
                if match_metric:
                    for metric in match_metric:
                        metric_name = metric[0]
                        metric_key = metric[1]
                        metric_value = metric[2]
                        if metric_name not in data[current_section]:
                            data[current_section][metric_name] = {}
                        data[current_section][metric_name][metric_key] = metric_value
    return data


def main():
    if len(sys.argv) < 3:
        print("Usage: python convert_to_json.py <input_file> <output_file>")
        return
    
    input_path = sys.argv[1]
    output_path = sys.argv[2]

    result_data = convert_ycsb_output_to_json(input_path)
    with open(output_path, 'w') as json_file:
        json.dump(result_data, json_file, indent=4)

if __name__ == "__main__":
    main()
