# beast.etki.me

This repository contains Chef configuration to deploy my little home 
server.

Everything is managed in quite boring usual way, by a single cookbook
with corresponding policy file. Except that is expected to deployed via
knife zero, which is exploited by scripts in `bin/`. So don't forget to run
`chef gem install knife-zero`.

## bin/ scripts

There are two scripts that drive the whole thing.

- `bin/update.sh` will refresh policy lock and configure `workspace/` 
directory. It doesn't require any arguments.
- `bin/converge.sh` will converge target node. Additional arguments
for knife call can be supplied: `bin/converge --sudo --use-sudo-password -U etki -P 'hunter2'`
