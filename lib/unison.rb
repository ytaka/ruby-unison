class UnisonCommand
  UNISON_DEFAULT_COMMAND = 'unison'
  UNISON_OPTION_SPEC = {
    :addprefsto => :array,
    :addversionno => :bool,
    :auto => :bool,
    :backup => :array,
    :backupcurrent => :array,
    :backupcurrentnot => :array,
    :backupdir => :string,
    :backuplocation => ['local', 'central'],
    :backupnot => :array,
    :backupprefix => :string,
    :backups => :bool,
    :backupsuffix => :string,
    :batch => :bool,
    :confirmbigdeletes => :bool,
    :confirmmerge => :bool,
    :contactquietly => :bool,
    :debug => ['all', 'verbose'],
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
    :retry => :number,
    :root => :array,
    :rootalias => :array,
    :rshargs => :string,
    :rshcmd => :string,
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

  class InvalidOption < StandardError
  end

  class NonExistentOption < StandardError
  end

  attr_accessor :profile, :root1, :root2, :option, :command
  attr_reader :status

  # +args+ accepts the following three pattern:
  # - root1, root2, opts = \{\}
  # - profilename, opts = \{\}
  # - profilename, root1, root2, opts = \{\}
  # We set option of unison command to optinal hash.
  # The keys are symbols made from hypen-removed options of unison command and
  # the values are booleans (true or false), strings, and arrays of strings
  # corresponding to unison's options.
  # Note that to set boolean option we do not use a string 'true' or 'false',
  # but we use TrueClass, FalseClass, or NilClass.
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
    @status = nil
  end

  def get_command
    cmd = [@command]
    cmd << @profile << @root1 << @root2
    @option.each do |key, val|
      if spec = UNISON_OPTION_SPEC[key.intern]
        case spec
        when :bool
          case val
          when TrueClass, FalseClass, NilClass
            if val
              cmd << "-#{key}"
            else
              cmd << "-#{key}=false"
            end
          else
            raise UnisonCommand::InvalidOption, "We use TrueClass, FalseClass, or NilClass for #{key}."
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
          cmd << "-#{key}" << val.to_s
        when Array
          v = val.to_s
          unless spec.include?(v)
            raise UnisonCommand::InvalidOption, "Invalid unison option for #{key}: #{v}"
          end
          cmd << "-#{key}" << v
        end
      else
        raise UnisonCommand::NonExistentOption, "Nonexistent unison option: #{key.to_s}"
      end
    end
    cmd.compact!
    cmd
  end
  private :get_command

  def get_execute_result
    $?
  end
  private :get_execute_result

  def get_exit_status
    @status = get_execute_result

    if @status.respond_to?(:exitstatus)
      @status.exitstatus
    else
      @status
    end
  end
  private :get_exit_status

  # The method returns :success when all files are synchronized,
  # :skipped when some files are skipped,
  # :non_fatal_error when non fatal error occurs, and
  # :fatal_error when fatal error occurs or process is interrupted.
  # If +dry_run+ is true, the method returns
  # an array of a unison command to execute.
  def execute(dry_run = false)
    cmd = get_command
    if dry_run
      @status = nil
      return cmd
    end
    # Search exit code of unison command.
    Kernel.system(*cmd)
    case get_exit_status
    when 0
      :success
    when 1
      :skipped
    when 2
      :non_fatal_error
    when 3
      :fatal_error
    else
      raise StandardError, "Invalid exit code of unison: #{status.inspect.strip}."
    end
  end

  def version
    `#{@command} -version`.split[2]
  end
end
