def wsearch [
  site_id?: string                                  # the designation for the site to be searched
  search_term?: string                              # the string to be searched for on the designated site
  --list (-l)                                       # list the site designators and their search urls
  --add (-a): record<site_id: string, search_url: string>  # a record consisting of a site id and its search url
] {
    if not ("WEBSEARCH_FILE" in $env) {print "The environment variable WEBSEARCH_FILE is not defined."; return}

    let wsearch_file = ($env.WEBSEARCH_FILE)

    let search_table = if ($wsearch_file | path exists) {open $wsearch_file | from json}

    if not ($add | is-empty) {
        $search_table | append [[site_id search_url]; [$add.site_id $add.search_url]] | to json | save -f $wsearch_file
    }

    if $search_table != null and $site_id in ($search_table | get "site_id") {
       if ($search_term | is-empty) { print "need to supply search term"; return}
       let full_url = ($search_table | where site_id == $site_id | get search_url.0) + $search_term
       start $full_url
    }

    if $list {$search_table}
}
