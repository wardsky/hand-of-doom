class DangerDeck
  attr_reader :statevars

  def initialize(filename, statevars=nil)
    @data = YAML.load_file(filename)
    @statevars = statevars || initial_state(@data)
  end

  def draw_card
    card_index = @statevars['draw_pile'].shift
    @statevars['discard_pile'] << card_index
    @data[card_index]
  end

  def reshuffle!
    @statevars['draw_pile'].concat(@statevars['discard_pile']).shuffle!
    @statevars['discard_pile'].clear
  end

  def initial_state(data)
    {
      'draw_pile' => data.keys.shuffle,
      'discard_pile' => [],
    }
  end
end
