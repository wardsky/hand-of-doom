require './code/game_runner'
require './code/game_state'
require './code/utils'

class HandOfDoom < GameRunner

  DIRECTIONS = {
    'n'  => 'north',
    'nw' => 'northwest',
    'ne' => 'northeast',
    's'  => 'south',
    'sw' => 'southwest',
    'se' => 'southeast',
    'w'  => 'west',
    'e'  => 'east',
  }

  def initialize(savefile)
    super

    @game_state = GameState.new(@statevars)

    command 'info', 'i' do
      character = @game_state.character
      puts @game_state.character_role
      puts ''
      puts 'AGI %2d %s' % [character.agi, (character.statuses & ['Slimed']).first]
      puts 'CON %2d %s' % [character.con, (character.statuses & ['Poisoned']).first]
      puts 'MAG %2d %s' % [character.mag, (character.statuses & ['Exalted', 'Suppressed']).first]
      puts 'MRL %2d %s' % [character.mrl, (character.statuses & ['Blessed', 'Demoralized']).first]
      puts 'PER %2d %s' % [character.per, (character.statuses & ['Focused', 'Blinded']).first]
      puts 'STR %2d %s' % [character.str, (character.statuses & ['Invigorated', 'Weakened']).first]
      puts ''
      other_statuses = character.statuses & ['Fatigued', 'Detained', 'Infected', 'Stunned']
      unless other_statuses.empty?
        puts other_statuses.join(', ')
        puts ''
      end
      puts '%2d Wounds (%d HP)' % [character.wounds, character.hp]
      puts '%2d GP' % character.gp
      puts '%2d XP' % character.xp
      puts '%2d Luck' % character.luck
      false
    end

    command 'bold', 'b' do
      @game_state.character.bold!
      true
    end

    command 'cautious', 'c' do
      @game_state.character.cautious!
      true
    end

    command 'look', 'l' do
      current_space = @game_state.current_space
      puts "You are #{current_space.preposition} #{current_space.name}."
      current_space.exits.each do |dir, other_space|
        puts "To the #{DIRECTIONS[dir]} is #{other_space.name_relative_to(current_space)}."
      end
      if current_space.river_port?
        downriver_locations = conjunction_list(current_space.downriver, 'or')
        puts "There is a river port here. You can travel downriver to #{downriver_locations} for 2 GP."
      end
      if current_space.lake_port?
        lake_port_spaces = @world_map.spaces.values.select { |space| space.lake_port? and not space == current_space }
        lake_locations = conjunction_list(lake_port_spaces.map(&:name), 'or')
        puts "There is a lake port here. You can travel to #{lake_locations}."
      end
      false
    end

    command 'rest', 'r' do
      character = @game_state.character
      test_result = character.test_attr(:mrl)
      potential_wounds_to_recover = character.test_attr(:mrl) ? -(character.mrl.to_f / 2).ceil : -character.mrl
      wounds_to_recover = [character.wounds, potential_wounds_to_recover].min
      if wounds_to_recover > 0
        puts "You recover #{wounds_to_recover} wounds."
        character['wounds'] -= wounds_to_recover
      end
      character.statuses.each do |status|
        puts "You are no longer #{status}."
      end
      character.statuses.clear
      true
    end

    DIRECTIONS.each do |dir, dir_name|
      command dir_name, dir do
        current_space = @game_state.current_space
        other_space = current_space.exits[dir]
        if other_space
          character = @game_state.character
          if other_space.road? and character.bold? and not character.fatigued?
            other_space = other_space.destination_relative_to(current_space)
            unless character.test_attr(:con)
              puts 'You become Fatigued.'
              @game_state.character.fatigued!
            end
          end
          puts other_space.name.sub(/^./) { |c| c.upcase }
          @game_state.current_space = other_space
          true
        else
          puts "Cannot travel #{dir_name} from current space."
          false
        end
      end
    end
  end

  def prompt
    case @game_state.character.map_stance
    when 'Bold'
      'B> '
    when 'Cautious'
      'C> '
    end
  end
end
