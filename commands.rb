module Commands

  def self.hi(args, statevars)
    if statevars[:name]
      puts "Hello #{statevars[:name]}."
    else
      puts "Hello."
    end
  end

  def self.me(args, statevars)
    if args.nil? or args.empty?
      puts "Yes?"
    else
      statevars[:name] = args.join(' ')
      puts "Ok."
    end
  end

  def self.quit(args, statevars)
    puts "Bye."
    exit
  end
end
