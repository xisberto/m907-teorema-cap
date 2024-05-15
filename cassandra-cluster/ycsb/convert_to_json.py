import json
import re
import sys
from abc import ABC, abstractmethod

class MetricProcessor(ABC):
    """Abstract class for processing different kinds of metrics."""
    
    @abstractmethod
    def process(self, line, results):
        pass

class GeneralMetricProcessor(MetricProcessor):
    """Process general metrics and complex metrics."""
    
    def process(self, line, results):
        match = re.search(r'\[(\w+)\], (\w+), (.+)', line)
        if match:
            operation, metric, value = match.groups()
            if operation not in results:
                results[operation] = {}
            if re.match(r'^[\d.]+$', value.strip()):
                results[operation][metric] = float(value)
            else:
                self.process_complex_metric(operation, metric, value, results)

    def process_complex_metric(self, operation, metric, value, results):
        sub_metrics = value.split('; ')
        for sub_metric in sub_metrics:
            sub_match = re.match(r'(\w+)\((\w+)\)=(\d+\.?\d*)', sub_metric)
            if sub_match:
                sub_metric_name, unit, sub_value = sub_match.groups()
                metric_name = f"{metric}_{sub_metric_name} ({unit})"
                results[operation][metric_name] = float(sub_value)
            else:
                key_value_pair = sub_metric.split('=')
                if len(key_value_pair) == 2:
                    key, value = key_value_pair
                    try:
                        results[operation][key.strip()] = float(value.strip())
                    except ValueError:
                        results[operation][key.strip()] = value.strip()

class TimePerformanceProcessor(MetricProcessor):
    """Process time and performance related metrics."""
    
    def process(self, line, results):
        time_pattern = re.compile(r'(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}:\d{3}) (\d+) sec: (\d+) operations; (.+?)current ops/sec; est completion in (.+? second[s]?) (.*)')
        if time_match := time_pattern.search(line):
            timestamp, elapsed_sec, operations, ops_sec, est_completion, additional_info = time_match.groups()
            if 'Timed_Performance' not in results:
                results['Timed_Performance'] = []
            performance_snapshot = {
                'Timestamp': timestamp,
                'Elapsed_sec': int(elapsed_sec),
                'Operations': int(operations),
                'Ops_per_sec': float(ops_sec.split()[0]),
                'Est_completion': est_completion
            }
            # Parse additional metrics such as latency
            if additional_info:
                additional_metrics = {}
                for part in additional_info.split('] ['):
                    part = part.replace('[', '').replace(']', '')
                    if 'AverageLatency' in part:
                        operation, latency = part.split(' ', 1)
                        _, latency_value = latency.split('=')
                        additional_metrics[operation + '_AverageLatency(us)'] = float(latency_value)
                performance_snapshot['Additional_Info'] = additional_metrics
            results['Timed_Performance'].append(performance_snapshot)

class YCSBParser:
    """Parser for YCSB output using different metric processors."""
    
    def __init__(self, input_path, output_path):
        self.input_path = input_path
        self.output_path = output_path
        self.results = {}
        self.processors = [GeneralMetricProcessor(), TimePerformanceProcessor()]

    def parse_output(self):
        with open(self.input_path, 'r') as file:
            for line in file:
                for processor in self.processors:
                    processor.process(line, self.results)

    def save_results(self):
        with open(self.output_path, 'w') as json_file:
            json.dump(self.results, json_file, indent=4, sort_keys=True)
        print(f"Results saved to {self.output_path}")

def main():
    if len(sys.argv) < 3:
        print("Usage: python parse_ycsb.py input.txt output.json")
        sys.exit(1)
    
    parser = YCSBParser(sys.argv[1], sys.argv[2])
    parser.parse_output()
    parser.save_results()

if __name__ == "__main__":
    main()
