# foreground

Control daemonizing background processes with launchd.

## Introduction

Some processes do unspeakable things, which makes it hard for launchd to
control them:

> A daemon or agent launched by launchd MUST NOT do the following in the process directly launched by launchd:
>
>   * Call daemon(3).
>   * Do the moral equivalent of daemon(3) by calling fork(2) and have the parent process exit(3) or _exit(2).
>
> -- [launchd.plist(5)](https://developer.apple.com/library/mac/#documentation/darwin/reference/manpages/man5/launchd.plist.5.html)

This tiny wrapper makes sure, that those processes are properly started
or stopped on behalf of launchd by mirroring the job's running state.

## Installation

Install it via RubyGems:

    $ gem install foreground

## Usage

Wrap your daemon command inside your launchd.plist:

    foreground --pid_file /tmp/foreground_sample_daemon.pid --command "foreground_sample_daemon --with arguments"

## Limitations

You can't control the daemons stdout, stderr, etc. this way, because the daemon will probably manage this stuff itself.

## Contributing

1. Fork it and `script/bootstrap` your environment (Note: This also
   performs a hard git reset to restore `bin/foreground_sample_daemon`,
   which gets overwritten by bundler!)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012 Björn Albers (MIT License)
