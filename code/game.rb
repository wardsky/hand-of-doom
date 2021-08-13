class Game

  def initialize(savefile)
    @commands = {}
    @savefile = savefile
    @statevars = begin
      YAML.load_file(savefile)
    rescue Errno::ENOENT
      {}
    end

    command 'quit', 'q' do
      puts 'Bye.'
      exit
    end
  end

  def start
    loop do

      print prompt

      begin
        s = gets
      rescue Interrupt
        # User pressed Ctrl+C
        puts
        next
      end

      exit if s.nil?  # User pressed Ctrl+D

      (name, *args) = s.strip.split

      next unless name

      if @commands[name]
        statevars_updated = @commands[name].call *args
        if statevars_updated
          File.write(@savefile, YAML.dump(@statevars))
        end
      else
        puts 'What?'
      end
    end
  end

  protected

  def command(*names, &block)
    names.each do |name|
      @commands[name] = block
    end
  end

  def prompt
    '> '
  end
end
