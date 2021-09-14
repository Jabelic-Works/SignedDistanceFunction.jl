module Generate
L = 1.5
"""
    generate_array(len, rev)

    array size: len
    reverse sort: rev=true
"""
function generate_array(len::Int=100, rev::Bool=false)
    tmp_length = len * 3
    # tmp = sort(append!([0.0], [rand() for i = 1:tmp_length])) # for debug
    
    if rev
        tmp = sort([rand() * L for i = 1:tmp_length], rev=true)
    else
        tmp = sort([rand() * L for i = 1:tmp_length])
    end
    # cutout element > len

    indexs::Array = sort([rand((1:tmp_length)) for j = 1:len])
    tmp = [tmp[indexs[i]] for i = 1:len]
    
    #  xが0と接する関数の時のみ実行
    if !(0.0 in tmp)
        popat!(tmp, rand(1:len))
        if rev 
            tmp = push!(tmp, 0.0)
        else
            tmp = pushfirst!(tmp, 0.0)
        end
    end
    #  xがLに接する関数の時のみ実行
    if !(L in tmp)
        popat!(tmp, rand(2:len))
        if rev 
            tmp = pushfirst!(tmp, L)
        else
            tmp = push!(tmp, L)
        end
    end
    return tmp
end


function generate_circle_y(ary::Array, str)
    r = L / 2
    if str == "pos"
        tmp = [(r^2 - (x - r)^2) for x in ary]
    else
        tmp = [-(r^2 - (x - r)^2) for x in ary]
    end
    return tmp
end

using LinearAlgebra
function get_mock_data(L::Float64=1.5, N::Int=100)
    data_length = Int(N / 2)
    data_x = append!(generate_array(data_length, false), generate_array(data_length, true))
    data_y = append!(generate_circle_y(data_x[1:data_length], "pos"), generate_circle_y(data_x[data_length + 1:data_length * 2], "neg"))
    tmp = zeros(Float64, data_length * 2, 2)
    for i = 1:data_length * 2
        tmp[i, 1] = data_x[i]
        tmp[i, 2] = data_y[i]
    end
    return tmp
end
get_mock_data(1.5, 100)
export get_mock_data
end