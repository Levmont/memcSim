# memcSim

memcSym is a simple ruby server that simulates Memcached with basic comands

## Files
memcSym.rb           -  Front end of server

filer.rb             -  Back end of the server

code mods/memcSym.h  -  Description of memcSym.rb code

code mods/Filer.h    -  Description of filer.rb code 

## Usage

```ruby
require './path/memcSim'

# starts the server
tester = Server.start('port from 1024 to 65535')
tester.serverOpen(tester)

# server closing not implemented
# ctrl+c

# connect to the server as user by typing on terminal:
# telnet '(Local ip of the server) (selected port)'
```
## Commands implemented for user
 - get
 - gets
 - add
 - set
 - replace
 - append
 - prepend
 - cas 

head to https://lzone.de/cheat-sheet/memcached for command specifications

## Author
-Lucio Rinker
