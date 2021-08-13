require './code/utils'

class Adventurer

  CLASSES = {}

  STARTING_CHARACTER = {
    'statuses' => [],
    'wounds' => 0,
  }

  def initialize(character)
    @character = character
  end

  def method_missing(m)
    if m.end_with? '?'
      return (self.traits + self.statuses).any? { |trait_or_status| "#{trait_or_status.downcase}?" == m.to_s }
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

  def traits
    self.class::TRAITS
  end

  def statuses
    @character['statuses']
  end

  def agi
    if statuses.include? 'Slimed'
      self.class::AGI - 1
    else
      self.class::AGI
    end
  end

  def con
    if statuses.include? 'Poisoned'
      self.class::CON - 1
    else
      self.class::CON
    end
  end

  def mag
    if statuses.include? 'Exalted'
      self.class::MAG + 1
    elsif statuses.include? 'Suppressed'
      self.class::MAG - 1
    else
      self.class::MAG
    end
  end

  def mrl
    if statuses.include? 'Blessed'
      self.class::MRL + 1
    elsif statuses.include? 'Demoralized'
      self.class::MRL - 1
    else
      self.class::MRL
    end
  end

  def per
    if statuses.include? 'Focused'
      self.class::PER + 1
    elsif statuses.include? 'Blinded'
      self.class::PER - 1
    else
      self.class::PER
    end
  end

  def str
    if statuses.include? 'Invigorated'
      self.class::STR + 1
    elsif statuses.include? 'Weakened'
      self.class::STR - 1
    else
      self.class::STR
    end
  end

  def test_attr(attr)
    if %i|agi con mag mrl per str|.include? attr
      attr_value = self.send(attr)
      roll = d6(2)
      return roll.sum <= attr_value ? roll.max : 0
    end
  end

  def wounds
    @character['wounds']
  end

  def hp
    2 * con
  end

  def gp
    @character['gp']
  end

  def xp
    @character['xp']
  end

  def luck
    @character['luck']
  end

  def arm
    0
  end

  def items
    @character['items']
  end

  def skills
    @character['skills']
  end
end

class AngelOfDeath < Adventurer

  Adventurer::CLASSES['Angel of Death'] = self

  TRAITS = %w|Human Rogue Scholar|

  AGI = 8
  CON = 6
  MAG = 7
  MRL = 7
  PER = 8
  STR = 6

  STARTING_CHARACTER = Adventurer::STARTING_CHARACTER.merge(
    'gp' => 8,
    'xp' => 6,
    'luck' => 2,
    'items' => [
      'Flash Bomb',
      'Light Pistol',
    ],
    'skills' => [
      'Alchemy',
    ],
  )
end
