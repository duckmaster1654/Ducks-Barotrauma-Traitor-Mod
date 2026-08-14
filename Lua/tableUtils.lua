function tableHasValue(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function randomFromTable(table)
    return table[math.random(#table)]
end

function randomFromTableRemove(tbl)
    if #tbl == 0 then return false end
    local random = math.random(#tbl)
    local output = tbl[random]
    table.remove(tbl, random)
    return output
end

function TableCopy(datatable)
    local tblRes = {}
    if type(datatable) == "table" then
        for k, v in pairs(datatable) do
            tblRes[TableCopy(k)] = TableCopy(v)
        end
    else
        tblRes = datatable
    end
    return tblRes
end

function TableCopyRecursive(value, cache)
    cache = cache or {}

    local tblRes = {}
    if type(datatable) == "table" then
        if cache[value] and cache[value] != nil then
            return cache[value] or value
        end

        for k, v in pairs(datatable) do
            tblRes[TableCopyRecursive(k, cache)] = TableCopyRecursive(v, cache)
        end
    else
        tblRes = datatable
    end

    cache[value] = tblRes

    return tblRes
end

function TableCopyShallow(orig)
    local copy = {}
    for orig_key, orig_value in pairs(orig) do
        copy[orig_key] = orig_value
    end
    return copy
end

--TableCopy = TableCopyRecursive

function tableShuffle(tbl) -- standard Fisher-Yates implementation
    assert(tbl, "given value is not valid table")

    if #tbl == 1 then return tbl end

    tableOut = TableCopy(tbl)

    for i = #tableOut, 2, -1 do
        local j = math.random(1, i)
        local swap = tableOut[i]
        tableOut[i] = tableOut[j]
        tableOut[j] = swap
    end
    return tableOut
end

function multTable(table, x)
    out = {}
    for _ = 0, x do
        table.insert(out, table)
    end
    return unpack(out)
end

function tableRemoveFromValue(table, valueToRemove)
    for _, value in pairs(table) do
        if value == valueToRemove then
            value = nil
            return
        end
    end
end

function tableHasValue(table, valueToFind)
    hasValue = false
    for _, value in pairs(table) do
        if value == valueToFind then
            hasValue = true
        end
    end

    return hasValue
end

function PrintTable(tbl)
    for i, v in pairs(tbl) do
        local str = v

        if type(v) == "boolean" then
            if v then
                str = "true"
            else
                str = "false"
            end
        end

        if type(v) == "function" then
            str = "FUNCTION"
        end

        if str == nil then
            str = "nil"
        end

        print(i .. ": " .. str)
    end

end