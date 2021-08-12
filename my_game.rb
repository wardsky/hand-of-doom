require './game'

class MyGame < Game

  def initialize
    super

    @name = nil

    command 'hi' do
      if @name.nil?
        puts 'Hello.'
      else
        puts "Hello #{@name}."
      end
    end

    command 'me' do |*name|
      @name = name.join(' ')
    end
  end
end
