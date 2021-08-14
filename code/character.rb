require './code/utils'
require './code/roles'

class Character

  # STATUSES = [
  #   'Slimed',
  #   'Poisoned',
  #   'Exalted',
  #   'Suppressed',
  #   'Blessed',
  #   'Demoralized',
  #   'Focused',
  #   'Blinded',
  #   'Invigorated',
  #   'Weakened',
  #   'Fatigued',
  #   'Detained',
  #   'Infected',
  #   'Stunned',
  # ]

  DEFAULT_STATEVARS = {
    'statuses' => [],
    'wounds' => 0,
    'map_stance' => 'Bold',
  }

  def initialize(role, statevars)
    @role = ROLES[role]
    @statevars = statevars
    if @statevars.empty?
      @statevars.replace(
        'statuses' => [],
        'wounds' => 0,
        'gp' => @role::STARTING_GP,
        'xp' => @role::STARTING_XP,
        'luck' => @role::STARTING_LUCK,
        'items' => @role::STARTING_ITEMS.clone,
        'skills' => @role::STARTING_SKILLS.clone,
        'map_stance' => 'Bold',
      )
    end
  end

  def method_missing(m, *args, &block)
    name = m.to_s
    if @statevars.key? name
      @statevars[name]
    elsif name.end_with? '?'
      (self.traits + self.statuses).any? { |trait_or_status| name == "#{trait_or_status.downcase}?" }
    else
      super
    end
  end

  def respond_to?(m)
    name = m.to_s
    (@statevars.key? name) or
    (name.end_with? '?') or
    super
  end

  def traits
    @role::TRAITS
  end

  def agi
    if statuses.include? 'Slimed'
      @role::AGI - 1
    else
      @role::AGI
    end
  end

  def con
    if statuses.include? 'Poisoned'
      @role::CON - 1
    else
      @role::CON
    end
  end

  def mag
    if statuses.include? 'Exalted'
      @role::MAG + 1
    elsif statuses.include? 'Suppressed'
      @role::MAG - 1
    else
      @role::MAG
    end
  end

  def mrl
    if statuses.include? 'Blessed'
      @role::MRL + 1
    elsif statuses.include? 'Demoralized'
      @role::MRL - 1
    else
      @role::MRL
    end
  end

  def per
    if statuses.include? 'Focused'
      @role::PER + 1
    elsif statuses.include? 'Blinded'
      @role::PER - 1
    else
      @role::PER
    end
  end

  def str
    if statuses.include? 'Invigorated'
      @role::STR + 1
    elsif statuses.include? 'Weakened'
      @role::STR - 1
    else
      @role::STR
    end
  end

  def test_attr(attr)
    if %i|agi con mag mrl per str|.include? attr
      attr_value = self.send(attr)
      roll = d6(2)
      if block_given?
        yield roll.sum <= attr_value ? roll.max : 0
      else
        return roll.sum <= attr_value
      end
    end
  end

  def hp
    2 * self.con
  end

  def slimed!(assert=true)
    if assert
      @statevars['statuses'] |= ['Slimed']
    else
      @statevars['statuses'] -= ['Slimed']
    end
  end

  def poisoned!(assert=true)
    if assert
      @statevars['statuses'] |= ['Poisoned']
    else
      @statevars['statuses'] -= ['Poisoned']
    end
  end

  def exalted!(assert=true)
    if assert
      if @statevars['statuses'].include? 'Suppressed'
        @statevars['statuses'] -= ['Suppressed']
      else
        @statevars['statuses'] |= ['Exalted']
      end
    else
      @statevars['statuses'] -= ['Exalted']
    end
  end

  def suppressed!(assert=true)
    if assert
      if @statevars['statuses'].include? 'Exalted'
        @statevars['statuses'] -= ['Exalted']
      else
        @statevars['statuses'] |= ['Suppressed']
      end
    else
      @statevars['statuses'] -= ['Suppressed']
    end
  end

  def blessed!(assert=true)
    if assert
      if @statevars['statuses'].include? 'Demoralized'
        @statevars['statuses'] -= ['Demoralized']
      else
        @statevars['statuses'] |= ['Blessed']
      end
    else
      @statevars['statuses'] -= ['Blessed']
    end
  end

  def demoralized!(assert=true)
    if assert
      if @statevars['statuses'].include? 'Blessed'
        @statevars['statuses'] -= ['Blessed']
      else
        @statevars['statuses'] |= ['Demoralized']
      end
    else
      @statevars['statuses'] -= ['Demoralized']
    end
  end

  def focused!(assert=true)
    if assert
      if @statevars['statuses'].include? 'Blinded'
        @statevars['statuses'] -= ['Blinded']
      else
        @statevars['statuses'] |= ['Focused']
      end
    else
      @statevars['statuses'] -= ['Focused']
    end
  end

  def blinded!(assert=true)
    if assert
      if @statevars['statuses'].include? 'Focused'
        @statevars['statuses'] -= ['Focused']
      else
        @statevars['statuses'] |= ['Blinded']
      end
    else
      @statevars['statuses'] -= ['Blinded']
    end
  end

  def invigorated!(assert=true)
    if assert
      if @statevars['statuses'].include? 'Weakened'
        @statevars['statuses'] -= ['Weakened']
      else
        @statevars['statuses'] |= ['Invigorated']
      end
    else
      @statevars['statuses'] -= ['Invigorated']
    end
  end

  def weakened!(assert=true)
    if assert
      if @statevars['statuses'].include? 'Invigorated'
        @statevars['statuses'] -= ['Invigorated']
      else
        @statevars['statuses'] |= ['Weakened']
      end
    else
      @statevars['statuses'] -= ['Weakened']
    end
  end

  def fatigued!(assert=true)
    if assert and not (@statevars['statuses'].include? 'Detained')
      @statevars['statuses'] |= ['Fatigued']
    else
      @statevars['statuses'] -= ['Fatigued']
    end
  end

  def detained!(assert=true)
    if assert
      @statevars['statuses'] -= ['Fatigued']
      @statevars['statuses'] |= ['Detained']
    else
      @statevars['statuses'] -= ['Detained']
    end
  end

  def infected!(assert=true)
    if assert
      @statevars['statuses'] |= ['Infected']
    else
      @statevars['statuses'] -= ['Infected']
    end
  end

  def stunned!(assert=true)
    if assert
      @statevars['statuses'] |= ['Stunned']
    else
      @statevars['statuses'] -= ['Stunned']
    end
  end


  def map_stance=(stance)
    raise "Invalid map stance" unless ['Bold', 'Cautious'].include? stance
    @statevars['map_stance'] = stance
  end

  def bold?
    @statevars['map_stance'] == 'Bold'
  end

  def bold!
    @statevars['map_stance'] = 'Bold'
  end

  def cautious!
    @statevars['map_stance'] = 'Cautious'
  end

  def cautious?
    @statevars['map_stance'] == 'Cautious'
  end
end
