using FileIO

function prepare_paths(param_file)
    params = YAML.load(open(param_file))

    data_path = params["input_tiff_dir"]
    output_path = params["output_base_path"]
        
    return params, data_path, output_path

end

function load_tiffstack(img_path)
    filenames = readdir(img_path)
    c1_files = filenames[[file[end-7:end] .== "c001.tif" for file in filenames]]
    temp = load(img_path * "/" * c1_files[1])
    voi = zeros(eltype(temp), size(temp)..., size(c1_files)[1])
    for (k, file) in enumerate(c1_files)
        filename = img_path .* "/" .* file
        img = load(filename)
        voi[:,:,k]=img
    end
    return voi
end


##**** Napari handlers

# bind a function to toggle the good_point annotation of the selected points
function decrease_threshold(viewer, points_layer, amplitude, confidence_t, decrement)
    print("bye")
    confidence_t  = confidence_t -  decrement
    points_layer.properties["good_point"] =  amplitude > confidence_t

    # we need to manually refresh since we did not use the Points.properties setter
    # to avoid changing the color map if all points get toggled to the same class,
    # we set update_colors=False (only re-colors the point using the previously-determined color mapping).
    points_layer.refresh_colors(update_color_mapping=false)
    return confidence_t
end

# bind a function to toggle the good_point annotation of the selected points
function increase_threshold(viewer, points_layer, amplitude, confidence_t, increment)
  
    confidence_t  = confidence_t + increment
    points_layer.properties["good_point"] = amplitude > confidence_t

    # we need to manually refresh since we did not use the Points.properties setter
    # to avoid changing the color map if all points get toggled to the same class,
    # we set update_colors=False (only re-colors the point using the previously-determined color mapping).
    points_layer.refresh_colors(update_color_mapping=false)
    return confidence_t
end

# bind a function to toggle the good_point annotation of the selected points
function toggle_class(viewer, points_layer)
    selected_points = points_layer.selected_data
    if length(selected_points) > 0
        println("Toggling $(length(selected_points)) points")
        good_point = points_layer.properties["good_point"]
        good_point[selected_points] = .!good_point[selected_points]
        points_layer.properties["good_point"] = good_point
        points_layer.refresh_colors(update_color_mapping=false)
    end
end


# bind a function to hide the bad (blue - points)
function hide_bad_points(object)
    global show_bad_points
    global points_layer
    if show_bad_points
        points_layer.face_color_cycle = [[0, 0, 1, 0], [0, 1, 0, 1]]
        show_bad_points = false
    else
        points_layer.face_color_cycle = [[0, 0, 1, 1], [0, 1, 0, 1]]
        show_bad_points = true
    end
end      
        
function save_points(viewer)

    print("Saving labeled points to file")
    #save results to files.

    # fout = output_path + "/roi_" + str(roi_idx) + "/curated_blobs.npz"
    # np.savez(fout, coords=points_layer.data, class_label=points_layer.properties["good_point"], 
    #                 size=points_layer.size, confidence=points_layer.properties["confidence"],
    #                 threshold=[confidence_t])

    # print("Saved")
end