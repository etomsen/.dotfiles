hs.hotkey.bind({"cmd", "shift"}, "L", function()
    -- Save current clipboard so we can restore it after pasting
    local savedClipboard = hs.pasteboard.getContents()

    -- Trigger Cmd+C to copy the current selection
    hs.eventtap.keyStroke({"cmd"}, "c")

    -- Give the system a moment to populate the clipboard
    hs.timer.usleep(100000)  -- 100ms

    local selection = hs.pasteboard.getContents()

    if not selection or selection == "" or selection == savedClipboard then
        hs.alert.show("No text selected")
        return
    end

    -- Trim whitespace/newlines
    selection = selection:gsub("^%s+", ""):gsub("%s+$", "")

    if selection == "" then
        hs.alert.show("Selection was empty after trimming")
        return
    end

    -- URL-encode the selection (the [[ ]] need encoding too)
    local encoded = hs.http.encodeForQuery("[[" .. selection .. "]]")
    local link = "hammerspoon://note?link=" .. encoded

    -- Paste the link directly, replacing the selection
    hs.pasteboard.setContents(link)
    hs.eventtap.keyStroke({"cmd"}, "v")

    -- Give paste a moment to consume the clipboard, then restore the original
    hs.timer.doAfter(0.2, function()
        if savedClipboard then
            hs.pasteboard.setContents(savedClipboard)
        end
    end)

    hs.alert.show("Pasted: " .. link, 2)
end)

hs.urlevent.bind("note", function(eventName, params)
    local link = params["link"]

    if not link or link == "" then
        hs.alert.show("note URL missing 'link' parameter")
        return
    end

    -- Strip surrounding [[ ]] if present
    local inner = link:match("^%[%[(.+)%]%]$") or link

    -- Split on the LAST slash so multi-level folders work
    -- "_types/React"          → folder="_types",         name="React"
    -- "Projects/2026/Q4 Plan" → folder="Projects/2026",  name="Q4 Plan"
    -- "React"                 → folder=nil,              name="React"
    local folder, name = inner:match("^(.*)/([^/]+)$")
    if not name then
        name = inner
        folder = nil
    end

    if not name or name == "" then
        hs.alert.show("Could not parse note name from link: " .. link)
        return
    end

    openNote(name, folder)
end)

function openNote(name, folder)
    local escapedName = escapeForAS(name)
    local script

    if folder and folder ~= "" then
        local leafFolder = folder:match("([^/]+)$") or folder
        local escapedFolder = escapeForAS(leafFolder)

        script = string.format([[
            tell application "Notes"
                activate

                -- Find or create the folder
                set targetFolder to missing value
                repeat with f in folders
                    if name of f is "%s" then
                        set targetFolder to f
                        exit repeat
                    end if
                end repeat

                if targetFolder is missing value then
                    set targetFolder to (make new folder with properties {name:"%s"})
                end if

                -- Find or create the note within that folder
                set matches to (every note of targetFolder whose name is "%s")
                if (count of matches) > 0 then
                    show item 1 of matches
                else
                    set newNote to (make new note at targetFolder with properties {body:"<h1>%s</h1>"})
                    show newNote
                end if
            end tell
        ]], escapedFolder, escapedFolder, escapedName, escapedName)
    else
        script = string.format([[
            tell application "Notes"
                activate
                set matches to (every note whose name is "%s")
                if (count of matches) > 0 then
                    show item 1 of matches
                else
                    set newNote to (make new note with properties {body:"<h1>%s</h1>"})
                    show newNote
                end if
            end tell
        ]], escapedName, escapedName)
    end

    local ok, result = hs.osascript.applescript(script)
    if not ok then
        hs.alert.show("Notes error: " .. tostring(result))
    end
end

function escapeForAS(s)
    return s:gsub("\\", "\\\\"):gsub('"', '\\"')
end
