require 'date'

t = Time.now

starting_day = Date.new(t.year, t.month, 1)
puts starting_day.strftime("%A")
