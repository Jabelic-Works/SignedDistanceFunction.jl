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
    # function floodfill(_phi::Array,N,L, filled, beginx, beginy, indexI=nothing)
    #     filled_index = 1
    #     # 始点は平面全体の縁を一周すべき
    #     # -> 閉曲線が2箇所で境界に接していたりすると、その領域のみで色塗り(符合つけ)が終わってしまうから。
    #     closed_zero = L*2*1.42/N
    #     # println("The lattice size: ",size(_phi), " the beginning point: ", point_que)
    #     if indexI !== nothing
    #         bounse_x = size(_phi[:, 1])[1]+1
    #         bounse_min_x = 0
    #     else
    #         bounse_x = N+1
    #         bounse_min_x = 0
    #     end
    #     bounse_y = size(_phi)[2]+1
    #     bounse_min_y = 0
    #     # point_que = Array{Tuple{Float64,2}}(undef,N*N, 1)
    #     # point_que = Array{Any}(undef,N*N)
    #     point_que = fill((100,100), N*N)
    #     println("point_que size: ", size(point_que))
    #     # point_que = zeros(N*N, 1)
    #     # point_que = [(beginx, beginy)]
    #     point_que[1] = (beginx, beginy)
    #     point_que_tail = 2
    #     point_que_head = 1
    #     flag = false
    #     # while length(point_que)>0
    #     # while isassigned(point_que,point_que_head)
    #     # while length(point_que[]) > length(filled[1:filled_index-1])
    #     while point_que_head != point_que_tail
    #         # TODO: point_queをいちいち参照するのは無駄なので先に取得する
    #         # _x = copy(point_que[1][1])
    #         # _y = copy(point_que[1][2])
    #         _x = copy(point_que[point_que_head][1])
    #         _y = copy(point_que[point_que_head][2])
    #         # 上
    #         if bounse_min_x < _x-1 < bounse_x && !((_x-1, _y) in filled) && abs(_phi[_x-1, _y]) > closed_zero
    #             if !((_x-1, _y) in @view point_que[1:point_que_tail-1])
    #                 # append!(point_que,[(_x-1, _y)]) # 下側の格子点をqueueに積む
    #                 point_que[point_que_tail] = (_x-1, _y)
    #                 point_que_tail += 1
    #             end
    #         end
    #         # 左
    #         if bounse_min_y < _y-1 < bounse_y && !((_x, _y-1) in filled) && abs(_phi[_x, _y-1]) > closed_zero
    #             if !((_x, _y-1) in @view point_que[1:point_que_tail-1])
    #                 # append!(point_que,[(_x, _y-1)]) # 左側の格子点をqueueに積む
    #                 point_que[point_que_tail] = (_x, _y-1)
    #                 point_que_tail += 1
    #             end
    #         end
    #         # 下
    #         if bounse_min_x < _x+1 < bounse_x && !((_x+1, _y) in filled) && abs(_phi[_x+1, _y]) > closed_zero
    #             if !((_x+1, _y) in @view point_que[1:point_que_tail-1])
    #                 # append!(point_que,[(_x+1, _y)]) # 上側の格子点をqueueに積む
    #                 point_que[point_que_tail] = (_x+1, _y)
    #                 point_que_tail += 1
    #             end
    #         end
    #         # 右
    #         if _y+1 < bounse_y && !((_x, _y+1) in filled) && abs(_phi[_x, _y+1]) > closed_zero
    #             if !((_x, _y+1) in @view point_que[1:point_que_tail-1])
    #                 # append!(point_que,[(_x, _y+1)]) # 右側の格子点をqueueに積む
    #                 point_que[point_que_tail] = (_x, _y+1)
    #                 point_que_tail += 1
    #             end
    #         end
    #         # 現在の格子点の符合を反転させる
    #         # append!(filled, [point_que[1]])
    #         # println("point_que_head: ", point_que_head, " filled_index: ", filled_index)
    #         filled[filled_index] = point_que[point_que_head]
    #         point_que_head += 1
    #         if _phi[_x, _y] < 0
    #             _phi[_x, _y]　*= (-1)
    #         end
    #         # popfirst!(point_que)
    #         filled_index += 1
    #         # println("point_que_head: ",point_que_head," point_que_tail: ",point_que_tail, " ",point_que_head != point_que_tail)
    #     end
    #     # end
    #     return _phi#, filled_index#, filled
    # end
    # precompile(floodfill, (Array, Int, Float64, Array, Int, Int, Int, Int))


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

    # 閉曲線がくぼんでたりしたらダメだ。
    function floodfill_parallel(_phi::Array,N,L, filled, beginx, beginy,filled_index, row=nothing, col=nothing)
        point_que = [(beginx, beginy)]
        closed_zero = L*2*1.42/N
        if row !== nothing
            bounse_x = row[2]+1
            bounse_min_x = row[1]-1
        else
            bounse_x = N+1
            bounse_min_x = 0
        end
        if col !== nothing
            bounse_y = col[2]+1
            bounse_min_y = col[1]-1
        else
            bounse_y = N+1
            bounse_min_y = 0
        end
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
            filled[filled_index] = point_que[1]
            if _phi[_x, _y] < 0
                _phi[_x, _y]　*= (-1)
            end
            popfirst!(point_que)
            filled_index += 1
        end
        # end
        return _phi#,filled#, filled_index#, filled
    end
    precompile(floodfill_parallel, (Array,Int,Float64, Array, Int, Int,Int, Union{Array,Nothing}, Union{Array,Nothing}))

    function signining_field(_phi::Array,N,L )
        _phi .*= (-1)
        # ======= single thread ========
        # Accuracy is good, but slow.
        filled = Array{Tuple{Int64,Int64}}(undef,N*N) # N=100だと12倍速! N=200だと60倍速!
        filled_index = 1
        # for i = 1:30:N-1
            # beginx = 1;beginy = i
            beginx = 1;beginy = 1
            indexI = 1
            # _phi = floodfill(_phi, N, L,filled,  beginx, beginy)
            _phi = floodfill(_phi,N,L, filled, beginx, beginy,filled_index, indexI)
            # println("filled_index : ",filled_index)
        # end
        
        # ========== multi thread ========== 
        # Accuracy is not good, but a little bit fast.
        # くぼんでたりしたらダメだ。
        # Threads.@threads for i = 1:4
        #     # 左上
        #     if i == 1
        #         row = [1, round(Int, N/2)]
        #         col = [1, round(Int, N/2)]
        #         filled_index = 1
        #         filled = Array{Tuple{Int64,Int64}}(undef,N*N) # N=100だと12倍速! N=200だと60倍速!
        #         beginx = 1;beginy = 1
        #         _phi = floodfill_parallel(_phi, N, L,filled,  beginx, beginy,filled_index,row,col )
        #         # _phi[row[1]:row[2], col[1]:col[2]]
        #     # 左下
        #     elseif i ==2
        #         row = [round(Int, N/2), N]
        #         col = [1, round(Int, N/2)]
        #         filled_index = 1
        #         filled = Array{Tuple{Int64,Int64}}(undef,N*N) # N=100だと12倍速! N=200だと60倍速!
        #         beginx = N;beginy = 1
        #         _phi = floodfill_parallel(_phi, N, L,filled,  beginx, beginy, filled_index, row,col)
        #     # 右下
        #     elseif i ==3
        #         row = [round(Int, N/2), N]
        #         col = [round(Int, N/2), N]
        #         filled_index = 1
        #         filled = Array{Tuple{Int64,Int64}}(undef,N*N) # N=100だと12倍速! N=200だと60倍速!
        #         beginx = N;beginy = N
        #         _phi = floodfill_parallel(_phi, N, L,filled,  beginx, beginy, filled_index,row,col)
        #     # 右上
        #     elseif i ==4
        #         row = [1, round(Int, N/2)]
        #         col = [round(Int, N/2), N]
        #         filled_index = 1
        #         filled = Array{Tuple{Int64,Int64}}(undef,N*N) # N=100だと12倍速! N=200だと60倍速!
        #         beginx = 1;beginy = N
        #         _phi = floodfill_parallel(_phi, N, L,filled,  beginx, beginy, filled_index, row,col)
        #     end
        # end
        return _phi
    end
    precompile(signining_field, (Array, Int, Float64))
    export signining_field
end