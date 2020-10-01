import glob
from os.path import isfile, join
import numpy as np
from skimage.external.tifffile import imread


def load_tiffstack(img_path):
    filenames = sorted([f for f in glob.glob(img_path + "/*c001.tif") if isfile(join(img_path, f))])
    
    print(img_path, " -- ", filenames)

    # initialize volume of interest
    raw = imread(filenames[0])
    (height, width) = raw.shape
    depth = len(filenames)
    voi = np.zeros((height, width, depth))

    for k in range(0, depth):
        raw = imread(filenames[k])
        voi[:,:,k]=raw

    return voi