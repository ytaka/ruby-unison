class Unison
  UNISON_DEFAULT_COMMAND = 'unison'
  UNISON_OPTION_SPEC = {
    :addprefsto => :array,
    :addversionno => :bool,
    :auto => :bool,
    :backup => :array,
    :backupcurrent => :array,
    :backupcurrentnot => :array,
    :backupdir => :string,
    :backuplocation => ['local', 'central']
    :backupnot => :array,
    :backupprefix => :string,
    :backups => :bool,
    :backupsuffix => :string,
    :batch => :bool,
    :confirmbigdeletes => :bool,
    :confirmmerge => :bool,
    :contactquietly => :bool,
    :debug => ['all', 'verbose']
    :dumbtty => :bool,
    :fastcheck => ['true', 'false', 'default'],
    :follow => :array,
    :force => :string,
    :forcepartial => :array,
    :group => :bool,
    :host => :string,
    :ignore => :array,
    :ignorecase => ['true', 'false', 'default'],
    :ignorelocks => :bool,
    :ignorenot => :array,
    :immutable => :array,
    :immutablenot => :array,
    :key => :array,
    :killserver => :bool,
    :label => :string,
    :log => :bool,
    :logfile => :string,
    :maxbackups => :number,
    :maxthreads => :number,
    :merge => :array,
    :mountpoint => :array,
    :numericids => :bool,
    :owner => :bool,
    :path => :array,
    :perms => :string, # check the option later
    :prefer => :array,
    :preferpartial => :array,
    :pretendwin => :bool,
    :repeat => :string,
    :retry => :number
    :root => :array,
    :rootalias => :array,
    :rsrc => ['true', 'false', 'default'],
    :rsync => :bool,
    :selftest => :bool,
    :servercmd => :string,
    :showarchive => :bool,
    :silent => :bool,
    :socket => :string,
    :sortbysize => :bool,
    :sortfirst => :array,
    :sortlast => :array,
    :sortnewfirst => :bool,
    :sshargs => :string,
    :sshcmd => :string,
    :terse => :bool,
    :testserver => :bool,
    :times => :bool,
    :xferbycopying => :bool
  }

  # The options -doc, -heeight, -version are ignored.
  # The option -ui is set 'text' to.

  attr_accessor :profile, :root1, :root2, :option, :command

  # +args+
  # root1, root2, opts = {}
  # profilename, opts = {}
  # profilename, root1, root2, opts = {}
  def initialize(*args)
    if Hash === args[-1]
      @option = args[-1]
      args = args[0...-1]
    else
      @option = {}
    end
    case args.size
    when 1
      @profile = args[0]
      @root1 = nil
      @root2 = nil
    when 2
      @profile = nil
      @root1 = args[0]
      @root2 = args[1]
    when 3
      @profile = args[0]
      @root1 = args[1]
      @root2 = args[2]
    else
      raise ArgumentError, "Invalid"
    end
    @command = UNISON_DEFAULT_COMMAND
  end

  def get_command
    cmd = [@command]
    cmd << @profile << @root1 << @root2
    @option.each do |key, val|
      if spec = UNISON_OPTION_SPEC[key.intern]
        case spec
        when :bool
          if val
            cmd << "-#{key}" << val.to_s
          end
        when :array
          k = "-#{key}"
          if val.respond_to?(:each)
            val.each do |v|
              cmd << k << v.to_s
            end
          else
            cmd << k << val.to_s
          end
        when :string
          cmd << "-#{key}" << spec.to_s
        when Array
          v = val.to_s
          unless spec.include?(v)
            raise StandardError, "Invalid unison option for #{key}: #{v}"
          end
          cmd << "-#{key}" << v
        end
      else
        raise StandardError, "Nonexistent unison option: #{key.to_s}"
      end
    end
    cmd.compact!
  end
  private :get_command

  def execute
    cmd = get_command
    # Search exit code of unison command.
    system(cmd)
  end
end
