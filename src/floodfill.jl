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
    # function 
    function floodfill(_phi::Array,N,L, filled, beginx, beginy,indexI=nothing)
        println(size(_phi))
        # 始点は平面全体の縁を一周すべき
        # -> 閉曲線が2箇所で境界に接していたりすると、その領域のみで色塗り(符合つけ)が終わってしまうから。
        ind_que = [(beginx, beginy)]
        tmp = 1
        closed_zero = L*2*1.4/N
        println("Lattice size: ",size(_phi), " the beginning point: ", ind_que)
        if indexI != nothing
            bounse_x = size(_phi[:, 1])[1]+1
            bounse_min_x = 0
        else
            bounse_x = N+1
            bounse_min_x = 0
        end
        bounse_y = size(_phi)[2]+1
        while length(ind_que)>0 #&& tmp < 102
            flag = false
            # TODO: ind_queをいちいち参照するのは無駄なので先に取得する
            # 下
            if bounse_min_x < ind_que[1][1]-1 < bounse_x && !((ind_que[1][1]-1, ind_que[1][2]) in filled) && abs(_phi[ind_que[1][1]-1, ind_que[1][2]]) > closed_zero
                append!(filled,[ind_que[1]])
                if !((ind_que[1][1]-1, ind_que[1][2]) in ind_que)# && (ind_que[1][1]-1 < size(_phi)[1] && ind_que[1][2]< size(_phi)[2]) )
                    append!(ind_que,[(ind_que[1][1]-1, ind_que[1][2])])
                end
                if _phi[ind_que[1][1], ind_que[1][2]] < 0
                    _phi[ind_que[1][1], ind_que[1][2]]　*= (-1)
                end
                popfirst!(ind_que)
                flag = true
            end
            # 左
            if 0 < ind_que[1][2]-1 < bounse_y && !((ind_que[1][1], ind_que[1][2]-1) in filled) && abs(_phi[ind_que[1][1], ind_que[1][2]-1]) > closed_zero
                if !((ind_que[1][1], ind_que[1][2]-1) in ind_que )#&& (ind_que[1][1]< size(_phi)[1] && ind_que[1][2] - 1< size(_phi)[2]))
                    append!(ind_que,[(ind_que[1][1], ind_que[1][2]-1)])
                end
                if !flag
                    append!(filled, [ind_que[1]])
                    if _phi[ind_que[1][1], ind_que[1][2]] < 0
                        _phi[ind_que[1][1], ind_que[1][2]]　*= (-1)
                    end
                    popfirst!(ind_que)
                    flag = true
                end
            end
            # 上
            if bounse_min_x < ind_que[1][1]+1 < bounse_x && !((ind_que[1][1]+1, ind_que[1][2]) in filled) && abs(_phi[ind_que[1][1]+1, ind_que[1][2]]) > closed_zero
                if !((ind_que[1][1]+1, ind_que[1][2]) in ind_que)# && (ind_que[1][1]+1 < size(_phi)[1] && ind_que[1][2]< size(_phi)[2]))
                    append!(ind_que,[(ind_que[1][1]+1, ind_que[1][2])])
                end
                if !flag
                    append!(filled, [ind_que[1]])
                    if _phi[ind_que[1][1], ind_que[1][2]] < 0
                        _phi[ind_que[1][1], ind_que[1][2]]　*= (-1)
                    end
                    popfirst!(ind_que)
                    flag = true
                end
            end
            # 右
            if ind_que[1][2]+1 < bounse_y && !((ind_que[1][1], ind_que[1][2]+1) in filled) && abs(_phi[ind_que[1][1], ind_que[1][2]+1]) > closed_zero
                if !((ind_que[1][1], ind_que[1][2]+1) in ind_que)# && (ind_que[1][1] < size(_phi)[1] && ind_que[1][2] + 1< size(_phi)[2]))
                    append!(ind_que,[(ind_que[1][1], ind_que[1][2]+1)])
                end
                if !flag
                    append!(filled,[ind_que[1]])
                    if _phi[ind_que[1][1], ind_que[1][2]] < 0
                        _phi[ind_que[1][1], ind_que[1][2]]　*= (-1)
                    end
                    popfirst!(ind_que)
                    flag = true
                end
            end
            if !flag
                append!(filled, [ind_que[1]])
                if _phi[ind_que[1][1], ind_que[1][2]] < 0
                    _phi[ind_que[1][1], ind_que[1][2]]　*= (-1)
                end
                popfirst!(ind_que)
            end
            tmp += 1
        end
        # end
        return _phi#, filled
    end
    function signining_field(_phi::Array,N,L )
        _phi .*= (-1)
        # indexI = 1;
        filled = []
        for i = 1:10:N-1
            beginx = 1;beginy = i
            _phi= floodfill(_phi, N, L,filled,  beginx, beginy)
        end
        return _phi
    end
    export signining_field
end