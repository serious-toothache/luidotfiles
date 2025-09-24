local function setup()
    local p_sort, p_reverse, p_dir

    ps.sub("cd", function()
        local cwd = cx.active.current.cwd

        if cwd:ends_with("Downloads") then
            -- Save the current sort state if not already saved
            if not p_sort then
                p_sort = cx.active.conf.sort_by
                p_reverse = cx.active.conf.sort_reverse
                p_dir = cx.active.conf.sort_dir_first
            end

            -- Sort Downloads by modified time (newest first, no dir-first)
            ya.manager_emit("sort", { "modified", reverse = true, dir_first = false })
        else
            -- Restore the previous sort order outside Downloads
            if p_sort then
                ya.manager_emit("sort", { p_sort, reverse = p_reverse, dir_first = p_dir })
                p_sort, p_reverse, p_dir = nil, nil, nil
            end
        end
    end)
end

return { setup = setup }

