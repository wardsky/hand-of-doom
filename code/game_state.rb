require './code/world_map'
require './code/character'
require './code/roles'

class GameState
  attr_reader :statevars, :character, :world_map

  WORLD_MAP_FILENAME = 'data/world_map.yaml'

  def initialize(statevars)

    @statevars = statevars

    if @statevars['character_state']
      @character = Character.new(@statevars['character_role'], @statevars['character_state'])
    else
      @character = Character.new(character_role)
      @statevars['character_state'] = @character.statevars
    end

    if @statevars['world_state']
      @world_map = WorldMap.new(WORLD_MAP_FILENAME, @statevars['world_state'])
    else
      @world_map = WorldMap.new(WORLD_MAP_FILENAME)
      @statevars['world_state'] = @world_map.statevars
    end
  end

  def method_missing(m, *args, &block)
    if @statevars.key? m.to_s
      @statevars[m.to_s]
    else
      super
    end
  end

  def respond_to?(m)
    (@statevars.key? m.to_s) || super
  end

  def current_space
    @world_map[@statevars['current_space']]
  end

  def current_space=(space)
    @statevars['current_space'] = @world_map.spaces.key(space)
  end
end
