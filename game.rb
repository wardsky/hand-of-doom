class Game

  def initialize
    @commands = {}

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
        @commands[name].call *args
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
