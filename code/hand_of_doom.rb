require './code/game'
require './code/world_map'
require './code/adventurer'
require './code/utils'

class HandOfDoom < Game

  def initialize(savefile)
    super

    @world_map = WorldMap.load_file('data/world_map.yaml')

    if @statevars.empty?
      adventurer = 'Angel of Death'
      @statevars['adventurer'] = adventurer
      @statevars['character'] = Adventurer::CLASSES[adventurer]::STARTING_CHARACTER
      @statevars['current_space'] = 'Brüttelburg'
      @statevars['map_stance'] = 'Bold'
    end

    command 'info', 'i' do
      char = character
      puts @statevars['adventurer']
      puts ''
      puts 'AGI %2d %s' % [char.agi, char.statuses.intersection(['Slimed']).first]
      puts 'CON %2d %s' % [char.con, char.statuses.intersection(['Poisoned']).first]
      puts 'MAG %2d %s' % [char.mag, char.statuses.intersection(['Exalted', 'Suppressed']).first]
      puts 'MRL %2d %s' % [char.mrl, char.statuses.intersection(['Blessed', 'Demoralized']).first]
      puts 'PER %2d %s' % [char.per, char.statuses.intersection(['Focused', 'Blinded']).first]
      puts 'STR %2d %s' % [char.str, char.statuses.intersection(['Invigorated', 'Weakened']).first]
      puts ''
      other_statuses = char.statuses.intersection(['Fatigued', 'Detained', 'Infected', 'Stunned'])
      unless other_statuses.empty?
        puts other_statuses.join(', ')
        puts ''
      end
      puts '%2d Wounds (%d HP)' % [char.wounds, char.hp]
      puts '%2d GP' % char.gp
      puts '%2d XP' % char.xp
      puts '%2d Luck' % char.luck
      false
    end

    command 'bold', 'b' do
      self.map_stance = 'Bold'
      true
    end

    command 'cautious', 'c' do
      self.map_stance = 'Cautious'
      true
    end

    command 'look', 'l' do
      puts "You are #{current_space.preposition} #{current_space.name}."
      current_space.exits.each do |dir, other_space|
        puts "To the #{WorldMap::DIRECTIONS[dir][:name]} is #{other_space.name_relative_to(current_space)}."
      end
      if current_space.river_port?
        puts "There is a river port here. You can travel downriver to #{conjunction_list(current_space.downriver, 'or')} for 2 GP."
      end
      if current_space.lake_port?
        lake_port_spaces = @world_map.spaces.values.select { |space| space.lake_port? and not space == current_space }
        puts "There is a lake port here. You can travel to #{conjunction_list(lake_port_spaces.map(&:name), 'or')}."
      end
      false
    end

    command 'rest', 'r' do
      char = character
      test_result = char.test_attr(:mrl)
      wounds_to_recover = [@statevars['character']['wounds'], test_result == 0 ? -(char.mrl.to_f / 2).ceil : -char.mrl].min
      if wounds_to_recover > 0
        puts "You recover #{wounds_to_recover} wounds."
        @statevars['character']['wounds'] -= wounds_to_recover
      end
      @statevars['character']['statuses'].each do |status|
        puts "You are no longer #{status}."
      end
      @statevars['character']['statuses'].clear
      true
    end

    WorldMap::DIRECTIONS.keys.each do |dir|
      command dir do
        other_space = current_space.exits[dir]
        if other_space
          char = character
          if other_space.road? and bold? and not char.fatigued?
            other_space = other_space.destination_relative_to(current_space)
            if char.test_attr(:con) == 0
              puts 'You become Fatigued.'
              self.set_character_status('Fatigued')
            end
          end
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

  def prompt
    case map_stance
    when 'Bold'
      'B> '
    when 'Cautious'
      'C> '
    end
  end

  def character
    Adventurer::CLASSES[@statevars['adventurer']].new(@statevars['character'])
  end

  def map_stance
    @statevars['map_stance']
  end

  def map_stance=(stance)
    raise "Invalid map stance" unless ['Bold', 'Cautious'].include? stance
    @statevars['map_stance'] = stance
  end

  def bold?
    map_stance == 'Bold'
  end

  def cautious?
    map_stance == 'Cautious'
  end

  def combat_stance
    @statevars['combat_stance']
  end

  def combat_stance=(stance)
    raise "Invalid combat stance" unless ['Attack', 'Guard'].include? stance
    @statevars['combat_stance'] = stance
  end

  def assault?
    combat_stance == 'Assault'
  end

  def guard?
    combat_stance == 'Guard'
  end

  def clear_character_statuses
    @statevars['character']['statuses'].clear
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
