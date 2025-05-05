let s:mappings = {
    \"c": "ĉ",
    \"C": "Ĉ",
    \"g": "ĝ",
    \"G": "Ĝ",
    \"h": "ĥ",
    \"H": "Ĥ",
    \"j": "ĵ",
    \"J": "Ĵ",
    \"s": "ŝ",
    \"S": "Ŝ",
    \"u": "ŭ",
    \"U": "Ŭ",
    \}

function! s:process_text(content)
    let result = []
    for i in a:content
        if tolower(i) == "x" && len(result) != 0 && has_key(s:mappings, result[-1])
            let result[-1] = s:mappings[result[-1]]
        else
            call add(result, i)
        endif
    endfor
    return join(result, "")
endfunction

function! s:malxigi()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return
    endif
    for i in range(len(lines))
        let line = lines[i]
        let before = ""
        let after = ""
        let content = line
        if i == len(lines) - 1
            let after = strpart(content, column_end)
            let content = strpart(content, 0, column_end)
        endif
        if i == 0
            let before = strpart(content, 0, column_start - 1)
            let content = strpart(content, column_start - 1)
        endif
        let lines[i] = before . s:process_text(content) . after
    endfor
    call setline(line_start, lines)
endfunction

xnoremap <silent>m :<C-u>silent! call <SID>malxigi()<CR>
