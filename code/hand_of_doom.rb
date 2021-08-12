require './code/game'
require './code/world_map'

class HandOfDoom < Game

  def initialize(filename)
    super()

    @world_map = WorldMap.load_file(filename)

    @current_space = @world_map.spaces['Brüttelburg']

    command 'look', 'l' do
      puts "You are #{@current_space.preposition} #{@current_space.name}."
      @current_space.exits.each do |dir, other_space|
        puts "To the #{WorldMap::DIRECTIONS[dir][:name]} is #{other_space.name_relative_to(@current_space)}."
      end
    end

    WorldMap::DIRECTIONS.keys.each do |dir|
      command dir do
        other_space = @current_space.exits[dir]
        if other_space
          @current_space = other_space
          puts @current_space.name.sub(/^./) { |c| c.upcase }
        else
          puts "Cannot travel #{WorldMap::DIRECTIONS[dir][:name]} from current space."
        end
      end
    end
  end
end
