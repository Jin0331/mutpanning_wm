# MUTAGENE input을 위한 study 별 maf preprocessing
import pandas as pd
import numpy as np
import glob

if __name__ == "__main__":
    
    root_path = "/root/mutpanning_data/"
    result_path = "/root/mutagene_preprocessing/"
    study_list = [name for name in os.listdir("/root/mutpanning_data/") if name not in "mutpanning_result"]
    # ALL remove
    study_list.sort()
    del study_list[1]
    
    for study_name in study_list:
        # file path extracion
        file_list = glob.glob(root_path + study_name + "/maf/*")
        file_maf = [file for file in file_list if file.endswith(".maf")]

        # load maf
        maf_data = pd.read_csv(file_maf[0], sep = "\t", skiprows=4, low_memory=False)

        # all column(object) to str
        all_columns = list(maf_data)
        maf_data[all_columns] = maf_data[all_columns].astype(str)

        # MT CHR remove
        maf_data_NMT = maf_data[maf_data.Chromosome != "MT"]

        # write to maf
        maf_data_NMT.to_csv(result_path + study_name + "_mutagene_input.maf", sep="\t")