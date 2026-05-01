hs.hotkey.bind({"cmd", "shift"}, "L", function()
    local contents = hs.pasteboard.getContents()

    if not contents or contents == "" then
        hs.alert.show("Clipboard is empty")
        return
    end

    contents = contents:gsub("^%s+", ""):gsub("%s+$", "")

    if contents == "" then
        hs.alert.show("Clipboard was empty after trimming")
        return
    end

    local encoded = hs.http.encodeForQuery("[[" .. contents .. "]]")
    local link = "hammerspoon://note?link=" .. encoded

    hs.pasteboard.setContents(link)

    hs.alert.show("Copied: " .. link, 2)
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
