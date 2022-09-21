module Utils
# ジョルダン曲線: ねじれのない閉曲線のこと.
"""
ジョルダン閉曲線であるかどうか
Whether Array Data represents the jordan curve or not.
"""
function is_jordan_curve(_gamma::Array)
    progression_of_differences = [sqrt((_gamma[i, 1] - _gamma[i+1, 1])^2 + (_gamma[i, 2] - _gamma[i+1, 2])^2) for i = 1:(length(_gamma[:, 1])-1)]
    ave_distance = sum(progression_of_differences) / length(progression_of_differences)
    if ave_distance * 2 < abs(_gamma[1, 1] - _gamma[length(_gamma[:, 1]), 1])
        return true
    else
        return false
    end
end

# FIXME: 倍々ではなく, linearに補完数を指定できるように。

"""
    n行目とn+1行目の間のデータを補完.
    set data between array[n] and array[n+1]: ..., array[n], new data, array[n+1], ...
    array size is from (x, 2) to (x*2-1, 2)
"""
function set_data_between_array_elements(array::Array, multiple::Bool, average_interval_between_points::Float64)
    (x, y) = size(array)
    return_value = Array{Float64}(undef, 2 * x, y)
    if multiple
        for i = 1:x-1
            # 点の間隔が平均以下なので、補間する -> 同一の曲線とみなす
            if sqrt(sum((array[i, :] .- array[i+1, :]) .^ 2)) < average_interval_between_points * 5 # NOTE: ここの加減が難しい. Nに依存?
                return_value[i*2-1, :] = array[i, :]
                return_value[i*2, :] = (array[i, :] .+ array[i+1, :]) ./ 2
                # 点の間隔が離れているので違う曲線とみる
            else
                return_value[i*2-1, :] = array[i, :]
                return_value[i*2, :] = array[i, :]
            end
        end
        return_value[x*2-1, :] = array[x, :]
        return_value[x*2, :] = array[x, :]
    else
        for i = 1:x-1
            # 点の間隔が平均以下なので、補間する -> 同一の曲線とみなす
            return_value[i*2-1, :] = array[i, :]
            return_value[i*2, :] = (array[i, :] .+ array[i+1, :]) ./ 2
        end
        return_value[x*2-1, :] = array[x, :]
        return_value[x*2, :] = array[1, :] # Note: _gamma += _gamma's head line coz boundary condition. size: (N+1,2)
    end
    return return_value
end
precompile(set_data_between_array_elements, (Array, Bool, Float64))

function remove_equal_value_in_next_points(array::Any)
    if length(array) == 0
        return
    end
    return_value = Array{Any}(undef, 0, length(array[1, :]))
    array_length = length(array[:, 1])
    for i = 1:array_length-1
        if array[i, :] != array[i+1, :]
            return_value = vcat(return_value, array[i, :]')
        end
    end
    return_value = vcat(return_value, array[array_length, :]')

    return return_value
end

"""
    times回, 倍の数だけデータを補完する
"""
function interpolation(array::Array, times::Int, multiple = false)
    if times > 0
        tmp = []
        (x, y) = size(array)
        
        """
            データの点と点の間隔の平均
        """
        average_interval_between_points = sum([sqrt(sum((array[i, :] .- array[i+1, :]) .^ 2)) for i = 1:x-1]) / x
        
        for _ = 1:times
            tmp = set_data_between_array_elements(array, multiple, average_interval_between_points)
            array = tmp
        end
        
        return remove_equal_value_in_next_points(tmp)
    end
end
precompile(interpolation, (Array, Int, Bool))

export is_jordan_curve, interpolation, remove_equal_value_in_next_points
end
