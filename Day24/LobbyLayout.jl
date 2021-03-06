file = open("input.txt")
lines = readlines(file)

function MoveInGrid(loc,dir,prev_dir)
    if (dir == 's')
        loc[1] -=1
    elseif (dir == 'n')
        loc[1] +=1
    elseif (dir == 'e')
        if (prev_dir == 's' || prev_dir == 'n')
            loc[2] +=1
        else
            loc[2] +=2
        end
    else
        if (prev_dir == 's' || prev_dir == 'n')
            loc[2] -=1
        else
            loc[2] -=2
        end
    end
    return loc
end

function FlipTiles(input)
    TileDict = Dict{Vector,Bool}()
    for i in 1:length(input)
        Loc = [0,0]
        Loc = MoveInGrid(Loc,input[i][1],'0')
        for j in 2:length(input[i])
            Loc = MoveInGrid(Loc,input[i][j],input[i][j-1])
        end
        if (haskey(TileDict,Loc))
            TileDict[Loc] = !(TileDict[Loc])
        else
            TileDict[Loc] = 1
        end
    end
    return sum(collect(values(TileDict))),TileDict
end

black_tiles,TileDict = FlipTiles(lines)
println("Solution to Part 1 is : ",black_tiles)

function FlipTilesPart2(TileDict)
    black_tile_indices = reduce(hcat,(collect(keys(TileDict))))
    tile_values = collect(values(TileDict))
    FloorExhibitMain = zeros(Int,150,400)
    black_tile_indices = black_tile_indices .+ [75;201]
    black_tile_indices = collect(transpose(black_tile_indices))
    for n in 1:size(black_tile_indices,1)
        FloorExhibitMain[black_tile_indices[n,1],black_tile_indices[n,2]] = tile_values[n]
    end
    day_number = 1
    while day_number <= 100
        FloorExhibit = deepcopy(FloorExhibitMain)
        for i in 2:1:149
            if (isodd(i))
                start_j = 3
            else
                start_j = 4
            end
            for j in start_j:2:398
                neighbor_tiles = [FloorExhibit[i+1,j+1] FloorExhibit[i-1,j-1] FloorExhibit[i,j+2] FloorExhibit[i,j-2] FloorExhibit[i-1,j+1] FloorExhibit[i+1,j-1]]
                black_tile_neighbors = sum(neighbor_tiles .== 1)
                if (FloorExhibit[i,j] == 0 && black_tile_neighbors == 2)
                    FloorExhibitMain[i,j] = 1;
                elseif (FloorExhibit[i,j] == 1 && (black_tile_neighbors == 0 || black_tile_neighbors > 2))
                    FloorExhibitMain[i,j] = 0;
                end
            end
        end
        day_number+=1
    end
    return sum(FloorExhibitMain .== 1)
end

sol2 = FlipTilesPart2(TileDict)
println("Solution to Part 2 is : ",sol2)