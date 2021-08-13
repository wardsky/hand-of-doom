require './code/game'
require './code/world_map'

class HandOfDoom < Game

  def initialize(savefile)
    super

    @world_map = WorldMap.load_file('data/world_map.yaml')

    if @statevars.empty?
      @statevars['current_space'] = 'Brüttelburg'
    end

    command 'look', 'l' do
      puts "You are #{current_space.preposition} #{current_space.name}."
      current_space.exits.each do |dir, other_space|
        puts "To the #{WorldMap::DIRECTIONS[dir][:name]} is #{other_space.name_relative_to(current_space)}."
      end
    end

    WorldMap::DIRECTIONS.keys.each do |dir|
      command dir do
        other_space = current_space.exits[dir]
        if other_space
          self.current_space = other_space
          puts current_space.name.sub(/^./) { |c| c.upcase }
          true
        else
          puts "Cannot travel #{WorldMap::DIRECTIONS[dir][:name]} from current space."
          false
        end
      end
    end
  end

  def current_space
    @world_map.spaces[@statevars['current_space']]
  end

  def current_space=(space)
    @statevars['current_space'] = @world_map.spaces.key(space)
  end
end
