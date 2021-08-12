require 'yaml'
require './game'

class HandOfDoom < Game

  LOCATIONS = YAML.load_file('data/locations.yaml')

  DIRECTIONS = {
    'n'  => { name: 'north', opposite: 's' },
    'nw' => { name: 'northwest', opposite: 'se'},
    'ne' => { name: 'northeast', opposite: 'sw'},
    's'  => { name: 'south', opposite: 'n' },
    'sw' => { name: 'southwest', opposite: 'ne'},
    'se' => { name: 'southeast', opposite: 'nw'},
    'w'  => { name: 'west', opposite: 'e' },
    'e'  => { name: 'east', opposite: 'w' },
  }

  def initialize
    super

    @current_space = "Brüttelburg"

    command 'look', 'l' do
      if @current_space.is_a? Array
        puts "You are on #{space_name(@current_space)}."
      elsif current_location['traits'].include? 'Inside'
        puts "You are in #{space_name(@current_space)}."
      elsif current_location['traits'].include? 'Outside'
        puts "You are at #{space_name(@current_space)}."
      else
        raise 'Cannot determine preposition for current space'
      end
      exits_from_current_space.each do |dir, exit|
        puts "To the #{DIRECTIONS[dir][:name]} is #{exit_name(exit)}."
      end
    end

    %w|n nw ne s sw se w e|.each do |dir|
      command dir do
        space = exits_from_current_space[dir]
        if space
          @current_space = space
          puts space_name(@current_space).sub(/^./) { |c| c.upcase }
        else
          puts "Cannot travel #{DIRECTIONS[dir][:name]} from current space."
        end
      end
    end
  end

  private

  def space_name(space)
    if space.is_a? Array
      (territory, type) = space
      "a #{type} through #{territory}"
    else
      space
    end
  end

  def current_location
    LOCATIONS.find { |location| location['name'] == @current_space }
  end

  def exit_name(exit)
    if exit.is_a? Array
      (territory, type, index) = exit
      other_location = find_other_location(exit)
      "the #{type} to #{other_location['name']}"
    else
      exit
    end
  end

  def find_connected_locations(connection)
    connected_locations = LOCATIONS.select do |location|
      next unless location['exits']
      location['exits'].values.any? { |exit| exit == connection }
    end
    raise 'Unexpected number of connected locations' unless connected_locations.length == 2
    return connected_locations
  end

  def find_other_location(exit)
    connected_locations = find_connected_locations(exit)
    return connected_locations[0] if connected_locations[1] == current_location
    return connected_locations[1] if connected_locations[0] == current_location
    raise "Connected locations don't include current location"
  end

  def connection_exits(connection)
    exits = {}
    LOCATIONS.each do |location|
      next unless location['exits']
      location['exits'].each do |dir, space|
        opposite_dir = DIRECTIONS[dir][:opposite]
        exits[opposite_dir] = location['name'] if space == connection
      end
    end
    raise 'Unexpected number of connection exits' unless exits.length == 2
    return exits
  end

  def exits_from_current_space
    if @current_space.is_a? String
      current_location['exits'] || {}
    else
      connection_exits(@current_space)
    end
  end
end
