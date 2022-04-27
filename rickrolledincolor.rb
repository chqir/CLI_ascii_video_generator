require 'RMagick'
include Magick

file_names = `find rick\\ roll -type f -regex ".*\.png"`.split(/\n/).sort

class String
  def black;          "\033[30m#{self}\033[0m" end
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end
  def brown;          "\033[33m#{self}\033[0m" end
  def blue;           "\033[34m#{self}\033[0m" end
  def magenta;        "\033[35m#{self}\033[0m" end
  def cyan;           "\033[36m#{self}\033[0m" end
  def gray;           "\033[37m#{self}\033[0m" end
end

c = `tput cols`.to_i
l = `tput lines`.to_i
$bt = ".,-~:;=!*$@"
$emp = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]

def renderframe(img)
  c = `tput cols`.to_i
  l = `tput lines`.to_i
  bt = ".,-~:;=!*$@"
  #creates a new image; resizes it to the terminal height; then creates an array of the values
  c_img = ImageList.new(img)
  c_img = c_img.resize!(c,l)
  img_array = c_img.export_pixels(x=0, y=0, c_img.columns, c_img.rows, "I")
  $o_array = Array.new(c) { Array.new(l)}
  # ".,-~:;=!*$@"

  #take max/min of the array, and create a step value based on that and the brightness
  max = img_array.max
  min = img_array.min
  steps = ((max - min)/bt.length).to_i

  #slices the array to 2 dimensions for easier processing
  img_array = img_array.each_slice(c_img.columns).to_a

  #iterate though array, and if the value is less than min + step(n) then assign it a character
  #this is ass-hat programming and is the worst shit ive ever made
  img_array.each_with_index do |sub_array, i|
    sub_array.each_with_index do |item, j|
      # ".,-~:;=!*$@"
      if img_array[i][j] < (min + steps*1)
        $o_array[i][j] = "."
      elsif img_array[i][j] < (min + steps*2)
        $o_array[i][j] = ","
      elsif img_array[i][j] < (min + steps*3)
        $o_array[i][j] = "-"
      elsif img_array[i][j] < (min + steps*4)
        $o_array[i][j] = "~"
      elsif img_array[i][j] < (min + steps*5)
        $o_array[i][j] = ":"
      elsif img_array[i][j] < (min + steps*6)
        $o_array[i][j] = ";"
      elsif img_array[i][j] < (min + steps*7)
        $o_array[i][j] = "="
      elsif img_array[i][j] < (min + steps*8)
        $o_array[i][j] = "!"
      elsif img_array[i][j] < (min + steps*9)
        $o_array[i][j] = "*"
      elsif img_array[i][j] < (min + steps*10)
        $o_array[i][j] = "$"
      elsif img_array[i][j] < (min + steps*11)
        $o_array[i][j] = "@"
      end
    end
  end

  $o_array.each_with_index do |sub, i|
    if sub != $emp
      sub.each_with_index do |item, j|
        print item
      end
    end
  end
  puts " "  
end

file_names.each do |file|
  renderframe(file)
  sleep 0.01 
end
