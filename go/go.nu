def --env go [   
  bm?: string          # the bookmark for a directory
  --list (-l)          # list the known directory bookmarks
  --add (-a): string   # add a new directory bookmark
] {
  if not "GO_FILE" in $env {print "The environment variable GO_FILE is not defined."; return}
    
  let go_file = ($env.GO_FILE)
    
  let bookmark_table = if ($go_file | path exists) {open $go_file | from json}
    
  # add a new book mark if required and save the new table to the go file
  if not ($add | is-empty) {
    $bookmark_table | append [[bookmark directory]; [$add (pwd)]] | to json | save -f $go_file
  }
    
  if $bookmark_table != null and $bm in ($bookmark_table | get "bookmark") {
    cd ($bookmark_table | where bookmark == $bm | get directory.0)
  }
 
  if $list {$bookmark_table}
}
