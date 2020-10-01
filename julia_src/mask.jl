using ImageSegmentation
using ImageMorphology

"""
    subregion_collage(vol::Array{Float64,3}, seed_coords::Array{Float64,2}, mask_radius::Int)
Returns a volume of labels, whcih is obtained from stiching segmenattion results
in small regions centered about the seeeds. 
The idea is that each of the samll subregions has a neclei and background
The size of the sub-regions is determined by `mask_radius`
"""
function subregion_collage(voi::Array{Float64,3}, seed_coords::Array{Float64,2}, mask_radius::Int)::Tuple{Array{Int64,3},Array{Float64,3}}
    (ni, nj, nk) = size(voi)
    voi_labels = ones(Int64, (ni, nj, nk)) 

    for si in 1:size(seed_coords)[1]
        coord_x, coord_y, coord_z = Int.(seed_coords[si, :])
        if (coord_x < mask_radius + 1 || coord_x > ni-mask_radius) || (coord_y <mask_radius + 1  || coord_y > nj-mask_radius)|| (coord_z < mask_radius + 1 || coord_z > nk-mask_radius)
            continue
        end

        sub_voi = voi[coord_x-mask_radius:coord_x+mask_radius, coord_y-mask_radius:coord_y+mask_radius, coord_z-mask_radius:coord_z+mask_radius]
        seeds = [(CartesianIndex(mask_radius + 1, mask_radius + 1, mask_radius + 1), si+1), (CartesianIndex(1, 1, 1), 1)]

        sub_segments = seeded_region_growing(sub_voi, seeds, (3,3,3))
        lc = closing(labels_map(sub_segments))
        # joint_labels = voi_labels[coord_x-mask_radius:coord_x+mask_radius, coord_y-mask_radius:coord_y+mask_radius, coord_z-mask_radius:coord_z+mask_radius] .*lc
        # joint_labels[joint_labels .> si+1] .= 1
        voi_labels[coord_x-mask_radius:coord_x+mask_radius, coord_y-mask_radius:coord_y+mask_radius, coord_z-mask_radius:coord_z+mask_radius] = lc
    end


    masked_voi = zeros(Float64, (ni, nj, nk)) 
    masked_voi[voi_labels.>1] .= voi[voi_labels.>1]
    
    return voi_labels, masked_voi
end