# Snippets Manager - CLI
The following `CLI` is my daily-Dev assistant.

## Development Requirements

- [x] `tagging system` support, language, topic, subtopic ..etc.
- [x] navigated with `FZF`.
- [x] support for `markdown-cli`.
- [x] highlight the searched-word in a file.
- [x] control over which place to show the window of fzf (support highlighting the word and also show markdown).
- [x] help file and supporting man-page for further queries and development.
- [x] support different layouts for the markdown based on the `terminal-cli-markdown` to be selected.


## Working plan

### Rules
0. When create, it will open the default `Terminal Editor` with template.
1. Accept `positional arguments` by the language. if not, show the `default`.
2. Integrated with `GitHub` for portability.
3. Using `SQLite` if possible to store all the necessary snippets.
4. Can be used as a snippet manager and also some notes taking together on how to use the `snippet-command`.
5. support `hyperlinks`.

### System Setup
Limitation for current `mysnippet` is maximum file name is set to less than `255` characters, due to many snippets.



### Dependencies


### Helper commands
```bash
$ fzf --preview-window down:80% --preview "mdv {}"
$ fzf -e -i --preview-window down:80% --preview "mdv {}"
fzf --query "^core go$ | rb$ | py$"
fzf --multi # this will allow us to select several files
basname $(pwd)
rga --files-with-matches "mac" |   fzf --sort --preview-window down:80%:wrap
# This is the nearest to our current objective
rga --files-with-matches "python" |   fzf --sort --preview-window down:80%:wrap --preview 'glow --style=dark {}'
# This will read all the tags in our given file.
head -n 3 ./snippet_2022-08-28-203815_python.md |  tail -1 | awk -F ":" '{print $2}' | sed 's/ /_/g'
# You can use translate tr, instead of sed, as it shows that sed has a prblem.
echo one two three four five | tr ' ' '_'

```


