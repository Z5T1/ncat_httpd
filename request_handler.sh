#!/bin/bash

print_http_header () {
	cat << EOF
HTTP/1.1 $@

EOF
}

html_dir=$(realpath "$(dirname "$0")/html")
error_dir=$(realpath "$(dirname "$0")/error")
index_file="index.html"

read line
echo $line >&2

cmd=$(echo $line | cut -d ' ' -f 1)

if [ "$cmd" != "GET" ]; then
	print_http_header 400 Bad Request
	cat "$error_dir/400.html"
	exit
fi

page=$(echo $line | cut -d ' ' -f 2)

if [[ "$page" == */ ]]; then
	page+=$index_file
fi

if [ ! -f "$html_dir/$page" ]; then
	print_http_header 404 Not Found
	cat "$error_dir/404.html"
else
	print_http_header 200 Ok
	cat "$html_dir/$page"
fi
