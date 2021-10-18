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
    function floodfill(_phi::Array,N,L, filled, beginx, beginy,indexI=nothing)
        println(size(_phi))
        # 始点は平面全体の縁を一周すべき
        # -> 閉曲線が2箇所で境界に接していたりすると、その領域のみで色塗り(符合つけ)が終わってしまうから。
        ind_que = [(beginx, beginy)]
        tmp = 1
        closed_zero = L*2*1.414/N
        println("sdfsdf",size(_phi),  ind_que, "  ")
        if indexI != nothing
            bounse_x = size(_phi[:, 1])[1]+1
            bounse_min_x = 0
        else
            bounse_x = N+1
            bounse_min_x = 0
        end
        bounse_y = size(_phi)[2]+1
        println(bounse_min_x," ",bounse_x," ", bounse_y)
        while length(ind_que)>0 #&& tmp < 102
            flag = false
            # 下
            if bounse_min_x < ind_que[1][1]-1 < bounse_x && abs(_phi[ind_que[1][1]-1, ind_que[1][2]]) > closed_zero && !((ind_que[1][1]-1, ind_que[1][2]) in filled)
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
            if 0 < ind_que[1][2]-1 < bounse_y && abs(_phi[ind_que[1][1], ind_que[1][2]-1]) > closed_zero && !((ind_que[1][1], ind_que[1][2]-1) in filled)
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
            if bounse_min_x < ind_que[1][1]+1 < bounse_x && abs(_phi[ind_que[1][1]+1, ind_que[1][2]]) > closed_zero && !((ind_que[1][1]+1, ind_que[1][2]) in filled)
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
            if ind_que[1][2]+1 < bounse_y && abs(_phi[ind_que[1][1], ind_que[1][2]+1]) > closed_zero && !((ind_que[1][1], ind_que[1][2]+1) in filled)
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
        # indexJ = 1
        # interval = 20
        # for indexI = 1:interval:N-1
        #     println(indexI)
        #         for i = 1:2
        #             if i == 1
        #                 beginx = 1;beginy = 1
        #             else
        #                 beginx = 1;beginy = 101
        #             end
        #             # beginx = 1;beginy=i
        #             filled = []
        #             if !([indexI, indexJ] in filled)　# 始点
        #                 _phi[indexI:indexI+interval, :] = floodfill(_phi[indexI:indexI+interval, :], N, L,filled,  beginx, beginy,indexI)
        #             end
        #         end
        # end
        indexI = 1;filled = []
        beginx = 1;beginy = 1
        _phi= floodfill(_phi, N, L,filled,  beginx, beginy,indexI)
        return _phi
    end
    export signining_field
end