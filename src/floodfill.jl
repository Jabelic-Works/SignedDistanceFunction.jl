module Floodfill
include("./environments.jl")
#=== 
Flood-fill (node):
    1. Set Q to the empty queue or stack.
    2. Add node to the end of Q.
    3. While Q is not empty:
    4.   Set n equal to the first element of Q.
    5.   Remove first element from Q.
    6.   If n is Inside:
            Set the n
            Add the node to the west of n to the end of Q.
            Add the node to the east of n to the end of Q.
            Add the node to the north of n to the end of Q.
            Add the node to the south of n to the end of Q.
    7. Continue looping until Q is exhausted.
    8. Return.
===#
function floodfill(_phi::Array, N, L, filled, beginx, beginy, filled_index, indexI = nothing, multiprocess = true)
    # 始点は平面全体の縁を一周すべき
    # -> 閉曲線が2箇所で境界に接していたりすると、その領域のみで色塗り(符合つけ)が終わってしまうから。
    point_que = [(beginx, beginy)]
    closed_zero = L * 2 * 1.42 / (N + 1)
    # println("The lattice size: ",size(_phi), " the beginning point: ", point_que)
    if indexI !== nothing
        bounse_x = size(_phi[:, 1])[1] + 1
        bounse_min_x = 0
    else
        bounse_x = N + 1
        bounse_min_x = 0
    end
    bounse_y = size(_phi)[2] + 1
    bounse_min_y = 0

    STEP = 2^1
    # STEP=1
    while length(point_que) > 0
        _x = copy(point_que[1][1])
        _y = copy(point_que[1][2])
        # 現在の格子点の符合を反転させる
        if _phi[_x, _y] <= 0
            _phi[_x, _y] *= (-1)
        end
        filled[filled_index] = point_que[1]
        popfirst!(point_que)
        filled_index += 1
        # 下
        if bounse_min_x < _x - STEP < bounse_x && !((_x - STEP, _y) in filled) && abs(_phi[_x-STEP, _y]) > closed_zero
            if !((_x - STEP, _y) in point_que) && _phi[_x-STEP, _y] <= 0
                append!(point_que, [(_x - STEP, _y)]) # 下側の格子点をqueueに積む
            end
        end
        # 左
        if bounse_min_y < _y - STEP < bounse_y && !((_x, _y - STEP) in filled) && abs(_phi[_x, _y-STEP]) > closed_zero
            if !((_x, _y - STEP) in point_que) && _phi[_x, _y-STEP] <= 0
                append!(point_que, [(_x, _y - STEP)]) # 左側の格子点をqueueに積む
            end
        end
        # 上
        if bounse_min_x < _x + STEP < bounse_x && !((_x + STEP, _y) in filled) && abs(_phi[_x+STEP, _y]) > closed_zero
            if !((_x + STEP, _y) in point_que) && _phi[_x+STEP, _y] <= 0
                append!(point_que, [(_x + STEP, _y)]) # 上側の格子点をqueueに積む
            end
        end
        # 右
        if _y + STEP < bounse_y && !((_x, _y + STEP) in filled) && abs(_phi[_x, _y+STEP]) > closed_zero
            if !((_x, _y + STEP) in point_que) && _phi[_x, _y+STEP] <= 0
                append!(point_que, [(_x, _y + STEP)]) # 右側の格子点をqueueに積む
            end
        end
    end
    # end
    if STEP == 2
        _phi = assign_signs(_phi, STEP, N, L, multiprocess)
    end
    return _phi, filled_index#, filled
end
precompile(floodfill, (Array, Int, Float64, Array, Int, Int, Int, Int, Int))

## 今のところSTEP=2の場合のみ対応
function assign_signs(_phi, STEP, N, L, multiprocess = true)
    # 閉曲線内部が「-」である。デフォが
    # Int((N-1)/100) # 再帰回数
    loops = Int(log2(STEP))
    steps_signed_grid = STEP
    steps_unsigned_grid = Int(STEP / 2)
    # if JULIA_MULTI_PROCESS
    if multiprocess
        while loops > 0
            if STEP != 1
                Threads.@threads for i = 1:steps_signed_grid:length(_phi[1, :]) # 各行を一つ飛ばしで。
                    for j = 1:steps_signed_grid:length(_phi[:, 1])
                        # if j != length(_phi[:, 1]) # ケツでない
                        if j + steps_signed_grid <= length(_phi[:, 1]) && j + steps_unsigned_grid <= length(_phi[:, 1])
                            # 掛けたらマイナス->境界を示す. かつ 両方の距離を足したらgrid点の間の2倍の距離になる(数値誤差を考慮?できてる?)
                            if _phi[i, j] * _phi[i, j+steps_signed_grid] <= 0
                                if abs(_phi[i, j]) <= abs(_phi[i, j+steps_signed_grid]) # jの方が近い
                                    if _phi[i, j] < 0 # jが内
                                        _phi[i, j+steps_unsigned_grid] *= (-1) # 外側にある
                                    end
                                else # j+2の方が近い
                                    if _phi[i, j] >= 0 # jが外
                                        _phi[i, j+steps_unsigned_grid] *= (-1)
                                    end
                                end
                            elseif _phi[i, j] > 0 && _phi[i, j+steps_signed_grid] > 0# 外側
                                _phi[i, j+steps_unsigned_grid] *= (-1)
                            end
                        end
                    end
                end
                Threads.@threads for j = 1:Int(steps_signed_grid / 2):length(_phi[:, 1])
                    for i = 1:steps_signed_grid:length(_phi[:, 1])
                        # if i != length(_phi[:, 1]) # ケツでない
                        if i + steps_signed_grid <= length(_phi[:, 1]) && i + steps_unsigned_grid <= length(_phi[:, 1])
                            if _phi[i, j] * _phi[i+steps_signed_grid, j] <= 0
                                if abs(_phi[i, j]) <= abs(_phi[i+steps_signed_grid, j]) # iの方が近い
                                    if _phi[i, j] < 0 # iが内
                                        _phi[i+steps_unsigned_grid, j] *= (-1) # 外
                                    end
                                else # i+2の方が近い
                                    # if _phi[i+steps_signed_grid, j] < 0 # i+steps_signed_gridが内
                                    if _phi[i, j] >= 0 # iが外
                                        _phi[i+steps_unsigned_grid, j] *= (-1) # 外
                                    end
                                end
                            elseif _phi[i, j] > 0 && _phi[i+steps_signed_grid, j] > 0# 外側
                                _phi[i+steps_unsigned_grid, j] *= (-1)
                            end
                        end
                    end
                end
            end
            steps_signed_grid = steps_signed_grid >= 4 ? deepcopy(Int(steps_signed_grid / 2)) : undef
            steps_unsigned_grid = steps_unsigned_grid >= 2 ? deepcopy(Int(steps_unsigned_grid / 2)) : undef
            loops -= 1
        end
    else
        while loops > 0
            if STEP != 1
                for i = 1:steps_signed_grid:length(_phi[1, :]) # 各行を一つ飛ばしで。
                    for j = 1:steps_signed_grid:length(_phi[:, 1])
                        # if j != length(_phi[:, 1]) # ケツでない
                        if j + steps_signed_grid <= length(_phi[:, 1]) && j + steps_unsigned_grid <= length(_phi[:, 1])
                            # 掛けたらマイナス->境界を示す. かつ 両方の距離を足したらgrid点の間の2倍の距離になる(数値誤差を考慮?できてる?)
                            if _phi[i, j] * _phi[i, j+steps_signed_grid] <= 0
                                if abs(_phi[i, j]) < abs(_phi[i, j+steps_signed_grid]) # jの方が近い
                                    if _phi[i, j] < 0 # jが内
                                        _phi[i, j+steps_unsigned_grid] *= (-1) # 外側にある
                                    end
                                else # j+2の方が近い
                                    if _phi[i, j] >= 0 # jが外
                                        _phi[i, j+steps_unsigned_grid] *= (-1)
                                    end
                                end
                            elseif _phi[i, j] > 0 && _phi[i, j+steps_signed_grid] > 0# 外側
                                _phi[i, j+steps_unsigned_grid] *= (-1)
                            end
                        end
                    end
                end
                for j = 1:Int(steps_signed_grid / 2):length(_phi[:, 1])
                    for i = 1:steps_signed_grid:length(_phi[:, 1])
                        # if i != length(_phi[:, 1]) # ケツでない
                        if i + steps_signed_grid <= length(_phi[:, 1]) && i + steps_unsigned_grid <= length(_phi[:, 1])
                            if _phi[i, j] * _phi[i+steps_signed_grid, j] <= 0
                                if abs(_phi[i, j]) < abs(_phi[i+steps_signed_grid, j]) # jの方が近い
                                    if _phi[i, j] < 0 # jが内
                                        _phi[i+steps_unsigned_grid, j] *= (-1)
                                    end
                                else # j+2の方が近い
                                    if _phi[i, j] >= 0 # jが外
                                        _phi[i+steps_unsigned_grid, j] *= (-1)
                                    end
                                end
                            elseif _phi[i, j] > 0 && _phi[i+steps_signed_grid, j] > 0# 外側
                                _phi[i+steps_unsigned_grid, j] *= (-1)
                            end
                        end
                    end
                end
            end
            steps_signed_grid = steps_signed_grid >= 4 ? deepcopy(Int(steps_signed_grid / 2)) : undef
            steps_unsigned_grid = steps_unsigned_grid >= 2 ? deepcopy(Int(steps_unsigned_grid / 2)) : undef
            loops -= 1
        end
    end

    return _phi
end



function signining_field(_phi::Array, N, L, multiprocess = true)
    _phi .*= (-1)
    filled = Array{Tuple{Int64,Int64}}(undef, N * N) # N=100だと12倍速! N=200だと60倍速!
    filled_index = 1
    beginx = 1
    beginy = N
    indexI = 1
    _phi = floodfill(_phi, N, L, filled, beginx, beginy, filled_index, indexI, multiprocess)
    return _phi
end
precompile(signining_field, (Array, Int, Float64))
export signining_field
end