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
    function floodfill(_phi::Array,N,L, indexI, indexJ, filled)
        # N  the splits of fields
        # 各要素の判定範囲(0近傍の定義)
        # L*2/N より大きい0近傍はない
        # n < L*2/N then, n == 0 かな?

        # この中身の処理をflood fill methodとして、exportするmethodはsigning_fieldみたいな名前の方が良い?
        println(size(_phi))
        # 始点は平面全体の縁を一周すべき
        # -> 閉曲線が2箇所で境界に接していたりすると、その領域のみで色塗り(符合つけ)が終わってしまうから。
        # indexI = 1
        # indexJ = 1
        # Indexs = Dict( "indexI" => 1
        #                 "indexJ" => 1)
        ind_que = [(1,1)]
        # filled = []
        # bouse errorを考慮していない...
        # println(ind_que[1][1])
        tmp = 1
        closed_zero = L*2*1.414/N
        while length(ind_que)>0 #&& tmp < 102
            # println(ind_que, filled)
            flag = false
            # 左
            if ind_que[1][1]-1 > 0 && abs(_phi[ind_que[1][1]-1, ind_que[1][2]]) > closed_zero && !((ind_que[1][1]-1, ind_que[1][2]) in filled)
                append!(filled,[ind_que[1]])
                if !((ind_que[1][1]-1, ind_que[1][2]) in ind_que)
                    append!(ind_que,[(ind_que[1][1]-1, ind_que[1][2])])
                end
                if _phi[ind_que[1][1], ind_que[1][2]] < 0
                    _phi[ind_que[1][1], ind_que[1][2]]　*= (-1)
                end
                popfirst!(ind_que)
                flag = true
            end
            # 下
            if ind_que[1][2]-1 > 0 && abs(_phi[ind_que[1][1], ind_que[1][2]-1]) > closed_zero && !((ind_que[1][1], ind_que[1][2]-1) in filled)
                if !((ind_que[1][1], ind_que[1][2]-1) in ind_que)
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
            # 右
            if ind_que[1][1]+1 < N+1 && abs(_phi[ind_que[1][1]+1, ind_que[1][2]]) > closed_zero && !((ind_que[1][1]+1, ind_que[1][2]) in filled)
                if !((ind_que[1][1]+1, ind_que[1][2]) in ind_que)
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
            # 上
            if ind_que[1][2]+1 < N+1 && abs(_phi[ind_que[1][1], ind_que[1][2]+1]) > closed_zero && !((ind_que[1][1], ind_que[1][2]+1) in filled)
                if !((ind_que[1][1], ind_que[1][2]+1) in ind_que)
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
        # for i = 1:N
        #     println(_phi[i ,:])
        # end
        return _phi, filled
    end
    function signining_field(_phi::Array,N,L )
        _phi .*= (-1)
        filled = []
        for i = 1:10:N
            indexI = i
            indexJ = 1
            if !([indexI, indexJ] in filled)
                _phi, filled = floodfill(_phi::Array,N,L, indexI, indexJ, filled)
            end
        end
        for i = 1:10:N
            indexI = 1
            indexJ = i
            if !([indexI, indexJ] in filled)
                _phi, filled = floodfill(_phi::Array,N,L, indexI, indexJ, filled)
            end
        end
        for i = 1:10:N
            indexI = i
            indexJ = N
            if !([indexI, indexJ] in filled)
                _phi, filled = floodfill(_phi::Array,N,L, indexI, indexJ, filled)
            end
        end
        for i = 1:10:N
            indexI = N
            indexJ = i
            if !([indexI, indexJ] in filled)
                _phi, filled = floodfill(_phi::Array,N,L, indexI, indexJ, filled)
            end
        end
        # indexI = 1
        # indexJ = N
        # _phi = floodfill(_phi::Array,N,L, indexI, indexJ)
        return _phi
    end
    export signining_field
end