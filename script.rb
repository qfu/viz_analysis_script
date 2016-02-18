require 'csv'
require_relative 'shell'  



def find_index(input,array)
    result =  array.bsearch {|x| x >= input }
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

    viz.each do |entry|
        if entry[0] != entry[1] 
            time_array << entry[0] << entry[1]
            viz_array << entry[4].split('\u0x2236').last << entry[4].split('\u0x2236').last
        end
    end

    factors.each do |factor|
        #time
        holder = Array.new
        index = find_index(factor[0],time_array) 
        holder = get_factor_array(factor)
        while index != nil && holder.length != 0 do 
            ele = holder.pop()
            time_array.insert(index,factor[0])
            viz_array.insert(index,viz_array[index])
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
