require 'yaml'

class WorldMap

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

  class Space

    def method_missing(m)
      if m.end_with? '?'
        return self.traits.any? { |trait| "#{trait.downcase.gsub(' ', '_')}?" == m.to_s }
      else
        super
      end
    end

    def respond_to?(m)
      if m.end_with? '?'
        true
      else
        super
      end
    end
  end

  class LocationSpace < Space
    attr_reader :name, :region, :traits, :territory, :threat, :exits, :downriver

    def link(spaces, territories, data)
      @name = data['name']
      @region = data['region']
      @traits = data['traits']
      territory_name = data['territory']
      @territory = territory_name && territories[territory_name]
      @threat = data['threat']
      @exits = {}
      if data['exits']
        data['exits'].each do |dir, location_name|
          @exits[dir] = spaces[location_name]
        end
      end
      @downriver = data['downriver']
    end

    def threat
      @territory ? @territory.threat : @threat
    end

    def name_relative_to(location)
      @name
    end

    def preposition
      (@traits.include? 'Inside') ? 'in' : 'at'
    end
  end

  class ConnectionSpace < Space
    attr_reader :territory, :exits

    def link(locations, territories, designator)
      (territory_name, type, index) = designator
      @territory = territories[territory_name]
      @type = type
      @exits = {}
      locations.each do |location|
        location.exits.each do |dir, other_space|
          opposite_dir = DIRECTIONS[dir][:opposite]
          @exits[opposite_dir] = location if other_space === self
        end
      end
    end

    def name
      "a #{@type} through #{@territory.name}"
    end

    def region
      @territory.region
    end

    def traits
      @territory.traits + [@type.capitalize]
    end

    def threat
      @territory.threat
    end

    def downriver
      []
    end

    def destination_relative_to(location)
      case location
      when @exits.values.first
        @exits.values.last
      when @exits.values.last
        @exits.values.first
      end
    end

    def name_relative_to(location)
      other_location = destination_relative_to(location)
      "the #{@type} to #{other_location.name}" if other_location
    end

    def preposition
      'on'
    end
  end

  class Territory
    attr_reader :name, :region, :traits, :threat

    def initialize(data)
      @name = data['name']
      @region = data['region']
      @traits = data['traits']
      @threat = data['threat']
    end
  end

  attr_reader :spaces, :territories

  def initialize(data)

    @spaces = {}
    locations = []
    connection_designators = []
    data['locations'].each do |location_data|
      location_name = location_data['name']
      locations << (@spaces[location_name] = LocationSpace.new)
      if location_data['exits']
        location_data['exits'].values.each do |key|
          next if key.is_a? String or @spaces[key]
          @spaces[key] = ConnectionSpace.new
          connection_designators << key
        end
      end
    end

    @territories = {}
    data['territories'].each do |territory_data|
      territory_name = territory_data['name']
      @territories[territory_name] = Territory.new(territory_data)
    end

    data['locations'].each do |location_data|
      location_name = location_data['name']
      @spaces[location_name].link(@spaces, @territories, location_data)
    end

    connection_designators.each do |connection_designator|
      @spaces[connection_designator].link(locations, @territories, connection_designator)
    end
  end

  def self.load_file(filename)
    data = YAML.load_file(filename)
    return self.new(data)
  end
end
