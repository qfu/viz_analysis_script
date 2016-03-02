require 'csv'
require_relative 'shell'  



def find_index_start(input,array)
    result =  array.bsearch {|x| x >= input }
    return array.index(result)
end

def find_index_end(input,array)
    result =  array.bsearch {|x| x <= input }
    return array.index(result)
end

def find_range(start,stop,array)
    result =  array.bsearch {|x| x >= start && x <= stop }
    return array.index(result)
end

def get_factor_array(row)
    #temp = "" 
    temp = Array.new
    for i in 0..row.length
        if i == 4 then
            #temp << row[i].split('\u0x2236').last.to_s << " "
            temp << row[i].split('\u0x2236').last
        end

        if i > 4 then
           # temp << row[i].to_s << " "
            temp << row[i]
        end

    end
    return temp
end

def operate(file)
    return_array = Array.new
    factors = Array.new
    viz = Array.new
    time_array = Array.new
    viz_array = Array.new
    filter_array = Array.new
    CSV.foreach(file) do |row|
        #puts row[4].split('\u0x2236').first
        if row[4].split('\u0x2236').first === 'Factors'
            factors << row 
        else
            viz << row 
        end

    end

    time_array << "Time"
    viz_array << "Viz"
    filter_array << "Factors"
    viz.delete_at(0)
    
    i = 0
    num = 1200 

    while i <= num  do
     time_array << Time.at(i).utc.strftime("%M:%S") #=> "00:00"
     i += 30
    end


=begin
    time_array << "00:00" << "00:30" << "01:00"
    time_array << "01:30" << "02:00" << "02:30"
    time_array << "03:00" << "03:30" << "04:00"
    time_array << "04:30" << "05:00" << "05:30"
    time_array << "06:00" << "06:30" << "07:00"
    time_array << "07:30" << "08:00" << "08:30"
    time_array << "09:00" << "09:30" << "10:00"
    

    time_array << "10:30" << "11:00" << "11:30"
    time_array << "12:00" << "12:30" << "13:00"
    time_array << "13:30" << "14:00" << "14:30"
    time_array << "15:00" << "15:30" << "16:00"
    time_array << "16:30" << "17:00" << "17:30"
    time_array << "18:00" << "18:30" << "19:00"
    time_array << "19:30" << "20:00"  
=end

    viz.each do |entry|
        if entry[0] != entry[1] 
            #time_array << entry[0] << entry[1]
            #viz_array << entry[4].split('\u0x2236').last << entry[4].split('\u0x2236').last
            viz_array.fill(entry[4].split('\u0x2236').last,find_index_start(entry[0],time_array)..find_index_start(entry[1],time_array))
            puts entry[4].split('\u0x2236').last 
            puts find_index_start(entry[0],time_array)
            puts find_index_start(entry[1],time_array)
            puts time_array[find_index_start(entry[0],time_array)]
            puts time_array[find_index_start(entry[1],time_array)]
            puts viz_array[find_index_start(entry[0],time_array)]
            puts viz_array[find_index_start(entry[1],time_array)+10]
        end
    end

    factors.each do |factor|
        #time
        holder = Array.new
        index = find_index_start(factor[0],time_array) 
        holder = get_factor_array(factor)
        while index != nil && holder.length != 0 do 
            ele = holder.pop()
            #time_array.insert(index,time_array[index])
            #viz_array.insert(index,viz_array[index])
            filter_array.insert(index,ele)
        end
        holder.clear
    end

    return_array << time_array << viz_array << filter_array


    return return_array 

end


def iter(target,input)
    input.each do |ele|
        target << ele
    end
    target << []
end



CSV.open("./output.csv", "wb") do |csv|
    ARGV.each do |file|
        iter(csv,operate(file))
    end

    #csv << operate("1038.csv")
    #csv << operate("1039.csv")
    #csv << $time_array
    #csv << $viz_array
    #csv << $filter_array
end
