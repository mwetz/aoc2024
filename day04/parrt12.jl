lines = readlines("C:/tmp/factorio/julia/day04/input.txt")
mat = reduce(hcat, [[i for i in line] for line in lines])

c = 0
for i in 1:140
    for j in 1:140
        if i > 3 && j < 140-2
            str = join([mat[i,j], mat[i-1,j+1],mat[i-2,j+2],mat[i-3,j+3]])
            if str == "XMAS"
                global c+=1
            end
        end
        if i > 3
            str = join([mat[i,j], mat[i-1,j],mat[i-2,j],mat[i-3,j]])
            if str == "XMAS"
                global c+=1
            end
        end
        if i > 3 && j > 3
            str = join([mat[i,j], mat[i-1,j-1],mat[i-2,j-2],mat[i-3,j-3]])
            if str == "XMAS"
                global c+=1
            end
        end
        if j > 3
            str = join([mat[i,j], mat[i,j-1],mat[i,j-2],mat[i,j-3]])
            if str == "XMAS"
                global c+=1
            end
        end
        if i < 140-2 && j > 3
            str = join([mat[i,j], mat[i+1,j-1],mat[i+2,j-2],mat[i+3,j-3]])
            if str == "XMAS"
                global c+=1
            end
        end
        if i < 140-2
            str = join([mat[i,j], mat[i+1,j],mat[i+2,j],mat[i+3,j]])
            if str == "XMAS"
                global c+=1
            end
        end
        if i < 140-2 && j < 140-2
            str = join([mat[i,j], mat[i+1,j+1],mat[i+2,j+2],mat[i+3,j+3]])
            if str == "XMAS"
                global c+=1
            end
        end
        if j < 140-2
            str = join([mat[i,j], mat[i,j+1],mat[i,j+2],mat[i,j+3]])
            if str == "XMAS"
                global c+=1
            end
        end
    end
end
c

c = 0
for i in 1+1:140-1
    for j in 1+1:140-1
        if mat[i,j] == 'A'
            str = join([mat[i-1,j-1], mat[i+1,j-1], mat[i+1,j+1], mat[i-1,j+1]])
            if str in ["SSMM", "MSSM", "MMSS", "SMMS"]
                global c+=1
            end
        end
    end
end
c