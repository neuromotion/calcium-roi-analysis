import yaml

def prepare_paths(param_file):
    params = None

    with open(param_file, "r") as file:
        params = yaml.load(file, Loader=yaml.FullLoader)

    data_base_path = params["data_base_path"]
    output_base_path = params["output_base_path"]
    data_name = params["data_name"]
        
    data_path = data_base_path+ "/" + data_name
    output_path = output_base_path + "/" + data_name

    return params, data_path, output_path