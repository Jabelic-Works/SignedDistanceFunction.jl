module Floodfill
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
    # TODO: Queueの実装
    function floodfill(_phi::Array,N,L, filled, beginx, beginy,filled_index, indexI=nothing)
        # 始点は平面全体の縁を一周すべき
        # -> 閉曲線が2箇所で境界に接していたりすると、その領域のみで色塗り(符合つけ)が終わってしまうから。
        point_que = [(beginx, beginy)]
        closed_zero = L*2*1.42/N
        # println("The lattice size: ",size(_phi), " the beginning point: ", point_que)
        if indexI !== nothing
            bounse_x = size(_phi[:, 1])[1]+1
            bounse_min_x = 0
        else
            bounse_x = N+1
            bounse_min_x = 0
        end
        bounse_y = size(_phi)[2]+1
        bounse_min_y = 0
        while length(point_que)>0
            # TODO: point_queをいちいち参照するのは無駄なので先に取得する
            _x = copy(point_que[1][1])
            _y = copy(point_que[1][2])
            # 下
            if bounse_min_x < _x-1 < bounse_x && !((_x-1, _y) in filled) && abs(_phi[_x-1, _y]) > closed_zero
                if !((_x-1, _y) in point_que)
                    append!(point_que,[(_x-1, _y)]) # 下側の格子点をqueueに積む
                end
            end
            # 左
            if bounse_min_y < _y-1 < bounse_y && !((_x, _y-1) in filled) && abs(_phi[_x, _y-1]) > closed_zero
                if !((_x, _y-1) in point_que )
                    append!(point_que,[(_x, _y-1)]) # 左側の格子点をqueueに積む
                end
            end
            # 上
            if bounse_min_x < _x+1 < bounse_x && !((_x+1, _y) in filled) && abs(_phi[_x+1, _y]) > closed_zero
                if !((_x+1, _y) in point_que)
                    append!(point_que,[(_x+1, _y)]) # 上側の格子点をqueueに積む
                end
            end
            # 右
            if _y+1 < bounse_y && !((_x, _y+1) in filled) && abs(_phi[_x, _y+1]) > closed_zero
                if !((_x, _y+1) in point_que)
                    append!(point_que,[(_x, _y+1)]) # 右側の格子点をqueueに積む
                end
            end

            # 現在の格子点の符合を反転させる
            # append!(filled, [point_que[1]])
            filled[filled_index] = point_que[1]
            if _phi[_x, _y] < 0
                _phi[_x, _y]　*= (-1)
            end
            popfirst!(point_que)
            filled_index += 1
        end
        # end
        return _phi, filled_index#, filled
    end
    precompile(floodfill, (Array, Int, Float64, Array, Int, Int, Int, Int))

    function signining_field(_phi::Array,N,L )
        _phi .*= (-1)
        filled = Array{Tuple{Int64,Int64}}(undef,N*N) # N=100だと12倍速! N=200だと60倍速!
        filled_index = 1
        for i = 1:10:N-1
            beginx = 1;beginy = i
            _phi, filled_index= floodfill(_phi, N, L,filled,  beginx, beginy, filled_index)
            # println("filled_index : ",filled_index)
        end
        return _phi
    end
    precompile(signining_field, (Array, Int, Float64))
    export signining_field
end