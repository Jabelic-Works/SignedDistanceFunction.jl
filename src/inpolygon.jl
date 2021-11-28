module Inpolygon
    import DataFrames,DelimitedFiles, Luxor, BenchmarkTools
    using DataFrames, DelimitedFiles, Luxor, BenchmarkTools


    # 定義上のある点に対して全てのganma曲線上との距離を算出
    function distanceToCurve(px::Float64, py::Float64, gem::Array) # TODO: 型
        min_distance = 10000.0 # 初期値は大きく
        for i = 1:length(gem[:,1])
            distnow = sqrt((gem[i,1] - px)^2 + (gem[i,2] - py)^2)
            if (distnow < min_distance)
                min_distance = distnow
            end
        end
        return min_distance
    end
    precompile(distanceToCurve, (Float64, Float64, Array))

    # Normal processing, a jordan curve.
    function create_signed_distance(_x::Array, _y::Array, _gamma::Array)
        x_length = length(_x[:,1])
        return_value = zeros(Float64, x_length, x_length)
        for indexI = 1:length(_y)
            for indexJ = 1:length(_x)
                sdist = 1.0 * distanceToCurve(_x[indexJ], _y[indexI], _gamma)
                # ganmaが閉曲線でないと成立しない。
                # omegaとの境界線上はErrorになる
                if Point(_x[indexJ], _y[indexI]) in [Point(_gamma[i,1], _gamma[i,2]) for i = 1:length(_gamma[:,1])]
                    sdist = 0
                elseif isinside(Point(_x[indexJ], _y[indexI]), [Point(_gamma[i,1], _gamma[i,2]) for i = 1:length(_gamma[:,1])])
                    sdist = (-1) * sdist
                end
                return_value[indexI,indexJ] = sdist
            end
        end
        return return_value
    end
    precompile(create_signed_distance, (Array, Array, Array))
    
    # Multi processing, a jordan curve.
    function create_signed_distance_multiprocess(_x::Array, _y::Array, _gamma::Array)
        x_length = length(_x[:,1])
        return_value = zeros(Float64, x_length, x_length)
        Threads.@threads for indexI = 1:length(_y)
            for indexJ = 1:length(_x)
                sdist = 1.0 * distanceToCurve(_x[indexJ], _y[indexI], _gamma)
                if Point(_x[indexJ], _y[indexI]) in [Point(_gamma[i,1], _gamma[i,2]) for i = 1:length(_gamma[:,1])]
                    sdist = 0
                elseif isinside(Point(_x[indexJ], _y[indexI]), [Point(_gamma[i,1], _gamma[i,2]) for i = 1:length(_gamma[:,1])])
                    sdist = (-1) * sdist
                end
                return_value[indexI,indexJ] = sdist
            end
        end
        return return_value
    end
    precompile(create_signed_distance_multiprocess, (Array, Array, Array))

    export create_signed_distance_multiprocess,create_signed_distance,distanceToCurve
end