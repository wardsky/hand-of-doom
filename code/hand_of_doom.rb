require 'yaml'

require './code/game_runner'
require './code/game_state'
require './code/utils'

def option_dialog(message, options)
  selectors = ('a'..'zz').to_a
  selection = nil
  option_keys = (options.respond_to? :keys) ? options.keys : options
  option_values = (options.respond_to? :values) ? options.values : options
  while selection.nil? do
    puts message
    option_keys.each.with_index do |option_key, index|
      puts "#{selectors[index]}) #{option_key}"
    end
    print "? "
    index = selectors.index(gets.strip)
    selection = index && option_values[index]
  end
  return selection
end

class HandOfDoom < GameRunner

  DIRECTIONS = {
    'n'  => 'North',
    'nw' => 'Northwest',
    'ne' => 'Northeast',
    's'  => 'South',
    'sw' => 'Southwest',
    'se' => 'Southeast',
    'w'  => 'West',
    'e'  => 'East',
  }

  def initialize(savefile)
    super

    if @statevars.empty?
      @statevars['character_role'] = option_dialog('Select your adventurer:', ROLES.keys)
      @statevars['character_state'] = {}
      @statevars['current_space'] = 'Brüttelburg'
      File.write(savefile, YAML.dump(@statevars))
    end

    @game_state = GameState.new(@statevars)

    command 'info', 'i' do
      character = @game_state.character
      puts @game_state.character_role
      puts '---'
      puts 'AGI %2d %s' % [character.agi, (character.statuses & ['Slimed']).first]
      puts 'CON %2d %s' % [character.con, (character.statuses & ['Poisoned']).first]
      puts 'MAG %2d %s' % [character.mag, (character.statuses & ['Exalted', 'Suppressed']).first]
      puts 'MRL %2d %s' % [character.mrl, (character.statuses & ['Blessed', 'Demoralized']).first]
      puts 'PER %2d %s' % [character.per, (character.statuses & ['Focused', 'Blinded']).first]
      puts 'STR %2d %s' % [character.str, (character.statuses & ['Invigorated', 'Weakened']).first]
      puts '---'
      other_statuses = character.statuses & ['Fatigued', 'Detained', 'Infected', 'Stunned']
      unless other_statuses.empty?
        puts other_statuses.join(', ')
        puts '---'
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
      puts "You are #{current_space.preposition} #{current_space.name}, #{current_space.description}."
      current_space.exits.each do |dir, other_space|
        puts "To the #{DIRECTIONS[dir]} is #{other_space.name_relative_to(current_space)}."
      end
      if current_space.river_port?
        msg = "There is a river port here."
        msg += " You can travel downriver to #{conjunction_list(current_space.downriver_locations, 'or')} for 2 GP." unless current_space.downriver_locations.empty?
        puts msg
      end
      if current_space.lake_port?
        msg = "There is a lake port here."
        other_lake_ports = @game_state.world_map.spaces.values.select { |space| space.lake_port? and not space == current_space }
        msg += " You can travel to #{conjunction_list(other_lake_ports, 'or')}." unless other_lake_ports.empty?
        puts msg
      end
      false
    end

    command 'port', 'p' do
      current_space = @game_state.current_space
      character = @game_state.character
      if current_space.river_port?
        if !character.bold?
          puts "You must be Bold to travel by river."
        elsif current_space.downriver_message
          puts current_space.downriver_message
        elsif character.gp < 2
          puts "You can't afford the fare."
        else
          character.gp -= 2
          destination = case current_space.downriver_locations.count
          when 0
            raise "No downriver locations."
          when 1
            current_space.downriver_locations.first
          else
            option_dialog('Select your destination:', current_space.downriver_locations.map{ |location| [location.title, location] }.to_h)
          end
          @game_state.current_space = destination
        end
      elsif current_space.lake_port?
        if !character.bold?
          puts "You must be Bold to travel by lake."
        else
          other_lake_ports = @game_state.world_map.spaces.values.select { |space| space.lake_port? and not space == current_space }
          destination = case other_lake_ports.count
          when 0
            raise "No other lake port locations."
          when 1
            other_lake_ports.first
          else
            option_dialog('Select your destination:', other_lake_ports.map{ |location| [location.title, location] }.to_h)
          end
          @game_state.current_space = destination
        end
      else
        puts 'There is no port here.'
      end
    end

    command 'rest', 'r' do
      character = @game_state.character
      test_result = character.test_attr(:mrl)
      recoverable_wounds = character.test_attr(:mrl) ? (character.mrl.to_f / 2).ceil : character.mrl
      wounds_to_recover = [character.wounds, recoverable_wounds].min
      if wounds_to_recover > 0
        if @game_state.current_space.perilous?
          recovery_msg = "are on the lookout for peril and do not recover any wounds"
          conj = ', but '
        else
          recovery_msg = "recover #{wounds_to_recover} wounds"
          conj = ' and '
          character.wounds -= wounds_to_recover
        end
      else
        recovery_msg = nil
      end
      if character.statuses.empty?
        statuses = nil
      else
        statuses_msg = "are no longer #{conjunction_list(character.statuses, 'or')}"
        character.statuses.clear
      end
      if recovery_msg && statuses_msg
        puts "You #{recovery_msg}#{conj}#{statuses_msg}."
      elsif recovery_msg
        puts "You #{recovery_msg}."
      elsif statuses_msg
        puts "You #{statuses_msg}."
      end
      true
    end

    DIRECTIONS.each do |dir, dir_name|
      command dir_name, dir do
        current_space = @game_state.current_space
        other_space = current_space.exits[dir]
        if other_space
          character = @game_state.character
          may_become_fatigued = false
          fallback_space = nil
          if other_space.road? and character.bold? and not character.fatigued?
            may_become_fatigued = true
            fallback_space = other_space
            other_space = other_space.destination_relative_to(current_space)
          end
          if other_space.metaphysical? and character.statuses.empty?
            puts "Strange energies emanate from this direction & prevent you from going any further."
            @game_state.current_space = fallback_space if fallback_space
          else
            @game_state.current_space = other_space
            if may_become_fatigued
              unless character.test_attr(:con)
                puts "You become Fatigued."
                @game_state.character.fatigued!
              end
            end
          end
          true
        else
          puts "Cannot travel #{dir_name} from current space."
          false
        end
      end
    end
  end

  def prompt
    "#{@game_state.current_space.title} [#{@game_state.character.map_stance}]> "
  end
end
