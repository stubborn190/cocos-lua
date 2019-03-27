function mapref_return_value(REFNAME, WHERE)
    WHERE = WHERE or 1
    return {
        AFTER = format_snippet [[
            olua_mapref(L, ${WHERE}, "${REFNAME}", -1);
        ]]
    }
end

function mapref_arg_value(REFNAME, WHERE, OBJ)
    WHERE = WHERE or 1
    OBJ = OBJ or 2
    return {
        BEFORE = format_snippet [[
            olua_mapref(L, ${WHERE}, "${REFNAME}", ${OBJ});
        ]]
    }
end

function mapunef_by_compare(REFNAME, WHERE)
    WHERE = WHERE or 1
    return {
        BEFORE = format_snippet [[
            xlua_startcmpunref(L, ${WHERE}, "${REFNAME}");
        ]],
        AFTER = format_snippet [[
            xlua_endcmpunref(L, ${WHERE}, "${REFNAME}");
        ]]
    }
end

function mapref_arg_value_and_mapunef_by_compare(REFNAME, WHERE, OBJ)
    WHERE = WHERE or 1
    OBJ = OBJ or 2
    return {
        BEFORE = format_snippet [[
            olua_mapref(L, ${WHERE}, "${REFNAME}", ${OBJ});
            xlua_startcmpunref(L, ${WHERE}, "${REFNAME}");
        ]],
        AFTER = format_snippet [[
            xlua_endcmpunref(L, ${WHERE}, "${REFNAME}");
        ]]
    }
end