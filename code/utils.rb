
def d6(n=nil)
  n ? Array.new(n) { rand(1..6) } : rand(1..6)
end

def conjunction_list(elements, conj)
  case elements.count
  when 0
    nil
  when 1
    elements.first.to_s
  when 2
    "#{elements.first} #{conj} #{elements.last}"
  else
    [*elements[0..-2], "#{conj} #{elements[-1]}"].join(', ')
  end
end
