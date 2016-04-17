module PCLKDTree

export KdTree, KdTreeFLANN, nearestKSearch

using LibPCL
using PCLCommon
using Cxx

const libpcl_kdtree = LibPCL.find_library_e("libpcl_kdtree")
try
    Libdl.dlopen(libpcl_kdtree, Libdl.RTLD_GLOBAL)
catch e
    warn("You might need to set DYLD_LIBRARY_PATH to load dependencies proeprty.")
    rethrow(e)
end

cxx"""
#include <pcl/kdtree/kdtree_flann.h>
#include <pcl/kdtree/impl/kdtree_flann.hpp>
"""

import PCLCommon: setInputCloud

abstract KdTree

@defpcltype KdTreeFLANN{T} <: KdTree "pcl::KdTreeFLANN"
@defptrconstructor KdTreeFLANN{T}() "pcl::KdTreeFLANN"
@defconstructor KdTreeFLANNVal{T}() "pcl::KdTreeFLANN"

setInputCloud(kd::KdTree, cloud::PointCloud) =
    icxx"$(kd.handle)->setInputCloud($(cloud.handle));"

function nearestKSearch(flann::KdTreeFLANN, point, k::Integer,
    k_indices, k_sqr_distances)
    found_neighs = icxx"$(flann.handle)->nearestKSearch($point,
        $k, $k_indices, $k_sqr_distances);"
    Int(found_neighs)
end

end # module
