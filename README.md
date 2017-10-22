# capistrano-db-sync

## Prerequisites
Install Ruby and Capistrano

### Download and install Ruby
Download and install Ruby for windows with the RubyInstaller available at [RubyInstaller](https://rubyinstaller.org)

### Install Capistrano
The following command will install the latest released Capistrano :

```ruby
gem install capistrano
```

## Install

Download and install the gem :

```ruby
gem install capistrano-db-sync
```

Add to Capfile :

```ruby
require 'capistrano/db-sync'
```

## Available tasks
```
db:sync:remote_to_local     # Synchronize your local database using remote database
db:sync:local_to_remote     # Synchronize your remote database using local database
```

## Example

```
cap production db:sync:remote_to_local
```