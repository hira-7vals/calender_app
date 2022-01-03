require 'optparse'
require 'date'
require 'json'
require 'csv'

##create a JSON file for storing events
## if file exists
## load file into json, save it into calender
## if it does not create a new calender
file_name = 'calender_events.json'
if File.file?(file_name)
  file = File.read(file_name)
  calender = JSON.parse(file)
else
  calender = Hash.new([])
end

def list_events(events, calender)
  date_to_show = events
  day, month, year = date_to_show.split("/")
  if day == "00" and month != "00" and year != "00"
    #show monthly events=
    #get all values that meet the regexp **/mm/yy
    #list down all of those values with their dates
    all_dates = calender.keys
    counter = 1
    for date in all_dates
      c_day, c_month, c_year = date.split("/")
      if c_month == month and c_year == year
        puts "#{counter}. #{date}: "
        for value in calender[date]
          puts "      #{value}"
        end
      end
      counter += 1
    end
  end
  if day != "00" and month != "00" and year != "00"
    puts "all events on date #{date_to_show}:"
    counter = 1
    for value in calender[date_to_show]
      puts "#{counter}.  #{value}"
      counter += 1
    end
  end
end

def delete_event(events, calender)
  date_to_update = events
  day, month, year = date_to_update.split("/")
  puts "Listing meetings, enter meeting id to delete"
  calender[date_to_update].each_with_index do |event, index|
    puts "#{index + 1}. #{event}"
  end
  x = gets.chomp.to_i
  calender[date_to_update].delete_at(x - 1)
  File.open("calender_events.json","w") do |f|
    f.write(calender.to_json)
  end
  puts "meeting deleted"
end

def update_event(events, calender)
  date_to_update = events
  day, month, year = date_to_update.split("/")
  puts "Listing meetings, enter meeting id to update"
  calender[date_to_update].each_with_index do |event, index|
    puts "#{index + 1}. #{event}"
  end
  x = gets.chomp.to_i
  puts "enter new description: "
  new_description = gets.chomp
  calender[date_to_update][x - 1] = new_description

  File.open("calender_events.json","w") do |f|
    f.write(calender.to_json)
  end

  puts "meeting updated!"
end

def add_events(events, calender)

    data = events.split()
    date = data[0]
    meeting_description = data[1..-1].join(" ")
    current = calender[date]
    if current
      current << meeting_description
    else
      current = [meeting_description]
    end

# TODO: robocop
    calender[date] = current
    puts "event being added ..."
    File.open("calender_events.json","w") do |f|
    f.write(calender.to_json)
    end
    puts "Event Added!"

end
def days_with_events(calender, current_month)
  days = Array.new
  if calender
    calender.each do |key, value|
      day, month, year = key.split("/")
      if month.to_s == current_month.to_s
        days << day
      end
    end
  end
  days
end

def print_calender(calender)
  today = Time.now

  total_days = Date.new(today.year, today.month, -1).day
  starting_day = Date.new(today.year, today.month, 1)
  starting_day_name = starting_day.strftime("%A")
  current_month_name = Date::MONTHNAMES[today.month]
  # print header
  puts "      #{current_month_name}   #{today.year}"
  #make these into constants
  days_of_the_week = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
  for day in days_of_the_week
    print day + " "
  end
  puts "\n"

  ##find days with events
  event_days = days_with_events(calender, today.month)
  #print days
  first_day = starting_day_name[0,3]
  starting_index = days_of_the_week.index(first_day)
  intial_padding = "    " * starting_index
  print intial_padding

  for day in 1..total_days
    if day == today.day
      x = day.to_s.rjust(3, " ")
      print "#{x}*"
    elsif event_days.include?(day.to_s)
      x = day.to_s.rjust(3, " ")
      print "#{x}@"

    else
      print day.to_s.rjust(3, " ")
      print " "
    end
    starting_index += 1
    if starting_index == 7
      starting_index = 0
      initial_padding = ""
      puts "\n"
    end
  end
  puts "\n"
end

options = {}

OptionParser.new do |opts|
  opts.on("-v", "--verbose", "Show extra information") do
    options[:verbose] = true
  end

  opts.on("-a=s", String, "USAGE: ruby calender_app.rb -a dd/mm/yy event description") do |event|
    options[:add] = event
  end

  ## list events and then show options and then delete
  opts.on("-d=s", String, "USAGE: ruby calender_app.rb -d dd/mm/yy") do |event|
    options[:delete] = event
  end

  ## list events and then show options and then update --> get a different description
  ## for listing by default list all today's events, otherwise include -d flag for date
  opts.on("-u=s", String, "USAGE: ruby calender_app.rb -u dd/mm/yy") do |event|
    options[:update] = event
  end

  opts.on("-l=s", String, "USAGE: ruby calender_app.rb -l 00/mm/yy (for month) and calender_app.rb -l dd/mm/yy (for month)") do |event|
    options[:list] = event
  end

  ## by default prints today's events (if type option then month's events);
  ### otherwise specify a date with -d
  opts.on("-p", "--print", "USAGE: ruby calender_app.rb -p ") do
    options[:print] = true
    puts "Calender: Today is marked with an * and days with events are marked with an @"
  end

  opts.on("-f=s", String, "USAGE: ruby calender_app.rb -f filename") do |event|
    options[:filename] = event
  end


end.parse!

if options[:print]
  print_calender(calender)
end

if options[:add]
  puts "calender #{calender}"
  add_events(options[:add], calender)
end

if options[:update]
  update_event(options[:update], calender)
end

if options[:delete]
  delete_event(options[:delete], calender)
end

if options[:list]
  list_events(options[:list], calender)
end

if options[:filename]
  file_name = options[:filename]
  file_contents = CSV.read("events.csv")
  print "file"
  puts file_contents
  for day_events in file_contents


    date = day_events[0]
    meetings = day_events[1..-1]

    if calender[date]
      current_meetings = calender[date]
      current_meetings << meetings
      calender[date] = current_meetings
    else
      calender[date] = meetings
    end
    end
    File.open("calender_events.json","w") do |f|
      f.write(calender.to_json)
    end
    puts "Events in the file added!"

end


# https://www.rubyguides.com/2018/12/ruby-argv/

# 1. print month (calender style)
# 2. add event
# 3. remove event
# 4. update event
# 5. print all events of the Month
# 6. Print all events of the Day
# 7. Load events from a CSV file
# 8. set all arguments as required
# 9. use a sign to show events with busy days
# 10. write function for JSON update

## figure out how to get arguments
## Event class?
## Month class ??
## update event
## print all events of the month
## print all events of the day

### all flag events
# if event add
# if event update
# if event delete
# if Print
#### if print events of the month
#### if print events of the day
#### if load csv
### data store to maintain memory of calendar events
