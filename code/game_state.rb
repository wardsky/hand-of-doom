require './code/world_map'
require './code/character'
require './code/roles'

class GameState
  attr_reader :statevars, :character, :world_map

  def initialize(statevars)
    @statevars = statevars
    @character = Character.new(@statevars['character_role'], @statevars['character_state'])
    @world_map = WorldMap.load_file('data/world_map.yaml')
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
