import yaml

def prepare_paths(param_file):
    params = None

    with open(param_file, "r") as file:
        params = yaml.load(file, Loader=yaml.FullLoader)

    data_path = params["input_mip"]
    output_path = params["output_base_path"]
        
    return params, data_path, output_path