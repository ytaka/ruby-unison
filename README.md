# ruby-unison

Ruby interface of the command of file synchronizer [unison](http://www.cis.upenn.edu/~bcpierce/unison/).
ruby-unison defines UnisonCommand class to execute unison in unison.rb.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-unison'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-unison

## Examples of usage

### Basic usage

    require 'unison'
    uc = UnisonCommand.new("pref", "root1", "root2")
    uc.execute
    
    uc = UnisonCommand.new("root1", "root2")
    uc.execute

### Dry run

    require 'unison'
    uc = UnisonCommand.new("pref", "root1", "root2")
    uc.execute(true)

### Usage of unison options

    require 'unison'
    uc = UnisonCommand.new("root1", "root2", :force => "root2", :path => ["Document", "Desktop"], :auto => true)
    uc.execute

### Change of unison path

    require 'unison'
    uc = UnisonCommand.new("root1", "root2")
    uc.command = "/path/to/unison"
    uc.execute

## Contributing to ruby-unison
 
- Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
- Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
- Fork the project
- Start a feature/bugfix branch
- Commit and push until you are happy with your contribution
- Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
- Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.
