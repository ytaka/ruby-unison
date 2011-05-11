# ruby-unison

Ruby interface of the command of file synchronizer [unison](http://www.cis.upenn.edu/~bcpierce/unison/).

## Examples

### Basic usage

    uc = UnisonCommand.new("pref", "root1", "root2")
    uc.execute

### Dry run

    uc = UnisonCommand.new("pref", "root1", "root2")
    uc.execute(true)

### Usage of unison options

    uc = UnisonCommand.new("root1", "root2", :force => "root2", :path => ["Document", "Desktop"], :auto => true)
    uc.execute

## Contributing to ruby-unison
 
- Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
- Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
- Fork the project
- Start a feature/bugfix branch
- Commit and push until you are happy with your contribution
- Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
- Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Takayuki YAMAGUCHI. See LICENSE.txt for
further details.
