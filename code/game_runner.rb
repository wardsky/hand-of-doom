require 'yaml'

require './code/game_state'
require './code/utils'
require './code/world_map'

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

class GameRunner

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

    @commands = {}
    @savefile = savefile
    begin
      @statevars = YAML.load_file(savefile)
      @game_state = GameState.new(@statevars)
    rescue Errno::ENOENT
      @statevars = {
        'character_role' => option_dialog('Select your adventurer:', ROLES.keys),
        'current_space' => 'Brüttelburg',
      }
      @game_state = GameState.new(@statevars)
      File.write(savefile, YAML.dump(@statevars))
    end

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
          destination = case current_space.downriver_locations.count
          when 0
            raise "No downriver locations."
          when 1
            current_space.downriver_locations.first
          else
            destination_options = current_space.downriver_locations.map{ |location| [location.title, location] }.to_h
            option_dialog('Select your destination:', destination_options.merge('Stay at current location' => :unchanged))
          end
          unless destination == :unchanged
            character.gp -= 2
            @game_state.current_space = destination
            exec_danger_phase
            true
          end
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
            destination_options = other_lake_ports.map{ |location| [location.title, location] }.to_h
            option_dialog('Select your destination:', destination_options.merge('Stay at current location' => :unchanged))
          end
          unless destination == :unchanged
            @game_state.current_space = destination
            exec_danger_phase
            true
          end
        end
      else
        puts 'There is no port here.'
      end
    end

    command 'rest', 'r' do
      character = @game_state.character
      if character.wounds > 0
        if @game_state.current_space.perilous?
          recovery_msg = "are on the lookout for peril and do not recover any wounds"
          conj = ", but "
        else
          recoverable_wounds = character.test_attr(:mrl) ? (character.mrl.to_f / 2).ceil : character.mrl
          wounds_to_recover = [character.wounds, recoverable_wounds].min
          if wounds_to_recover > 0
            recovery_msg = "recover #{wounds_to_recover} wounds"
            conj = " and "
            character.wounds -= wounds_to_recover
          else
            recovery_msg = "do not recover any wounds"
            conj = ", but "
          end
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
      exec_danger_phase
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
            if fallback_space
              @game_state.current_space = fallback_space
              exec_danger_phase
            end
          else
            @game_state.current_space = other_space
            if may_become_fatigued
              unless character.test_attr(:con)
                puts "You become Fatigued."
                @game_state.character.fatigued!
              end
            end
            exec_danger_phase
          end
          true
        else
          puts "Cannot travel #{dir_name} from current space."
          false
        end
      end
    end

    command 'help', 'h' do
      puts "Available commands:"
      puts @commands.keys
    end

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
        statevars_updated = @commands[name].call *args
        if statevars_updated
          File.write(@savefile, YAML.dump(@statevars))
        end
      else
        puts 'What?'
      end
    end
  end

  private

  def command(*names, &block)
    names.each do |name|
      @commands[name] = block
    end
  end

  def prompt
    "#{@game_state.current_space.title} [#{@game_state.character.map_stance}]> "
  end

  def exec_danger_phase
    danger_card = @game_state.danger_deck.draw_card
    if danger_card['reshuffle']
      puts "(#{danger_card['text'].strip})"
      @game_state.danger_deck.reshuffle!
    else
      case danger_card['space']
      when 'your current space'
        affected_zone = @game_state.current_space.zone
        puts "(#{danger_card['text'].strip} #{affected_zone}.)"
        increment_danger_level(affected_zone, @game_state.current_space)
      when 'each space with a Voidgate'
        puts "(#{danger_card['text'].strip})"
        @game_state.world_map.spaces.values.each do |space|
          if space.voidgate?
            affected_zone = space.zone
            increment_danger_level(affected_zone, nil)
          end
        end
      else
        puts "(#{danger_card['text'].strip} #{danger_card['territory'] || danger_card['space']}.)"
        affected_zone = @game_state.world_map[danger_card['territory'] || danger_card['space']]
        affected_space = @game_state.world_map[danger_card['space']]
        increment_danger_level(affected_zone, affected_space)
      end
    end
    test_danger_card_value(danger_card)
  end

  def increment_danger_level(affected_zone, affected_space)
    if affected_zone.danger_level
      if affected_zone.danger_level < 6
        affected_zone.danger_level += 1
        puts "<<#{affected_zone.title} is now at danger level #{affected_zone.danger_level}>>"
      elsif affected_space
        puts "<<The Hand of Doom appears at #{affected_space}!>>"
      else
        puts "<<Nothing happens...>>"
      end
    elsif affected_zone.town_level
      if affected_zone.town_level > 1
        affected_zone.town_level -= 1
        puts "<<#{affected_zone.title} is now at town level #{affected_zone.town_level}>>"
      else
        affected_zone.town_level = nil
        affected_zone.danger_level = 1
        puts "<<#{affected_zone.title} is now dangerous!>>"
      end
    end
  end

  def test_danger_card_value(danger_card)
    current_space = @game_state.current_space
    value = if danger_card['value'].is_a? Integer
      danger_card['value']
    elsif danger_card['value'].is_a? Hash
      if current_space.traits.include? danger_card['value']['if']
        danger_card['value']['then']
      else
        danger_card['value']['else']
      end
    end
    if danger_card['law'] and current_space.law?
      if @game_state.world_map.bounty_level >= value
        if danger_card['encounter']
          puts "<<#{@game_state.current_space.region} encounter triggered>>"
        end
        puts "<<#{danger_card['monsters'].first} Law monsters appear>>"
        if danger_card['epic_monsters']
          puts "<<#{danger_card['epic_monsters'].first} Law epic monster appears>>"
        end
      end
    else
      if current_space.danger_level and current_space.danger_level >= value
        if danger_card['encounter']
          puts "<<#{@game_state.current_space.region} encounter triggered>>"
        end
        puts "<<#{danger_card['monsters'].first} #{@game_state.current_space.region} monsters appear>>"
        if danger_card['epic_monsters']
          puts "<<#{danger_card['epic_monsters'].first} #{@game_state.current_space.region} epic monster appears>>"
        end
      end
    end
  end
end
