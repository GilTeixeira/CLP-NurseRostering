import configparser
DATASET_PATH = '../Dataset/Instance1.txt'
config = configparser.ConfigParser()
config.sections()
config.read(DATASET_PATH)
print(config.sections())
print("wut")