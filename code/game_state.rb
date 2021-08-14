require './code/world_map'
require './code/character'

class GameState
  attr_reader :statevars

  def initialize(statevars)

    @statevars = statevars
    @world_map = WorldMap.load_file('data/world_map.yaml')

    if @statevars.empty?
      character_role = 'Angel of Death'
      @statevars['character_role'] = character_role
      @statevars['character'] = Character::CLASSES[character_role]::STARTING_STATEVARS
      @statevars['current_space'] = 'Brüttelburg'
    end
  end

  def method_missing(m, *args, &block)
    if statevars.key? m.to_s
      @statevars[m.to_s]
    else
      super
    end
  end

  def respond_to?(m)
    (@statevars.key? m.to_s) || super
  end

  def character
    Character::CLASSES[@statevars['character_role']].new(@statevars['character'])
  end

  def set_character_status(status)
    @statevars['character']['statuses'] << status unless @statevars['character']['statuses'].include? status
  end

  def current_space
    @world_map.spaces[@statevars['current_space']]
  end

  def current_space=(space)
    @statevars['current_space'] = @world_map.spaces.key(space)
  end
end
