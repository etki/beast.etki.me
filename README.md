# satellite.etki.me

This repository contains Chef configuration to deploy my little home 
server.

Everything is managed in quite boring usual way, by a single cookbook with 
corresponding policy file. Except that is expected to deployed via knife zero, 
which is exploited by scripts in `bin/`. So don't forget to run
`chef gem install knife-zero`.

## bin/ scripts

There are three scripts that drive the whole thing.

- `bin/update.sh` will refresh policy lock file and configure `workspace/` 
directory. It doesn't require any arguments.
- `bin/converge.sh` will converge target node. Additional arguments
for knife call can be supplied: `bin/converge.sh --sudo --use-sudo-password -U etki -P 'hunter2'`
- `bin/deploy.sh` just combines two above.

## Licensing?

Here are yours [MIT](LICENSE-MIT) and [UPL-1.0](LICENSE-UPL-1.0) licenses. Have 
fun!
