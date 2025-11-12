# cppref
A small Lua-based command line tool for quickly accessing cppreference without having to use the mouse

## Installation

This tool requires Lua and Luarocks as it was initially written for Vim Lua. 
It will require you to install some libraries:
```
socket.http
socket.url
ssl.https
lfs
```

install.sh will install a few small bash scripts to the necessary locations. 

## Usage

`cppref-scan`
Will attempt to scrape items from the cppreference site. These are cached in `$HOME/cppref/flat.kps` to avoid hitting the site for every query. 

`cppref class[::method]`
Will open the cppreference page for any known matching entry, e.g. `cppref unordered_map` or `cppref vector::push_back`. 

## Contributing 

Feel free to fork, I am somewhat unlikely to frequently update this unless cppreference changes and the web scraping breaks. Do open issues if you find pages on the site which cannot be picked up in the tool. Note that some such as operator[] may instead be operator_at, e.g. `vector::operator_at` 
