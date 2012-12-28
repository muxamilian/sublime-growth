# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# default values
window.default_image = "http://localhost:8080/assets/rails.png"
window.default_formula = "1 - 3.3 * Math.pow(current_value + current_surrounding_value - (current_foreign_value + current_foreign_surrounding_value) - 0.8, 2) - 5 * Math.pow(Math.abs(current_value + current_surrounding_value - (current_foreign_value + current_foreign_surrounding_value)) - 0.6, 3)"

# image object and stuff
image_url = null
image = null
canvas = null
canvas_data = null
interval_id = null
formula = null
iterations = 0
iterations_field = null
interval = 0
interval_field = null
highest_color_value = 255
num_of_channels = 3
playing = false

# context 2d
c = null

# This gets executed when jQuery has finished loading
# $ ->

window.get_png = ->
  canvas.toDataURL("image/png")

window.set_interval = ->
  parsed_number = parseInt interval_field.val()
  if !isNaN(parsed_number) && parsed_number >= 0
    interval = parsed_number
    if playing
      pause()
      play()
    else
      pause()
  else
    alert "Erroneous interval"

window.reset = ->
  if playing
    pause()
    initialize_canvas(default_image, default_formula)
    play()
  else
    pause()
    initialize_canvas(default_image, default_formula)

increment_iterations = ->
  iterations += 1
  iterations_field.html(iterations)

window.initialize_canvas = (url, f) ->
  iterations = 0
  iterations_field = $('#iterations')
  iterations_field.html(iterations)
  interval_field = $('#interval')
  interval_field.val interval
  image_url = url
  formula = f
  canvas = document.getElementById('main-canvas')
  c = canvas.getContext('2d')
  load_image()

window.play = -> 
  clearInterval interval_id
  interval_id = setInterval iterate, interval
  playing = true
window.pause = -> 
  clearInterval interval_id
  playing = false

load_image = ->
  image = new Image()
  image.src = image_url
  image.onload = draw_image

draw_image = -> 
  canvas.width = image.width
  canvas.height = image.height
  c.drawImage image, 0, 0
  # This originally was in "initialize", but I need sequential execution

iterate = ->
  canvas_data = c.getImageData 0, 0, canvas.width, canvas.height
  new_canvas_data = c.createImageData(canvas_data);
  for x in [0...canvas.width]
    for y in [0...canvas.height]
      current_pos = get_pos x, y

      # An array containing the current rgb value. 
      # All values are normalized.
      current_values = [canvas_data.data[current_pos]/highest_color_value,
        canvas_data.data[current_pos+1]/highest_color_value,
        canvas_data.data[current_pos+2]/highest_color_value]

      # Values of surrounding pixels.
      #   #   #
      # (x,y) #
      #   #   #
      # All the surroundig values are added and then normalized.
      # If x or y are invalid, 0.5 is used as default value.
      current_surrounding_values = get_surrounding_values x, y
      current_surrounding_population = (current_surrounding_values.reduce (x,y) -> x+y)/num_of_channels
      current_overall_value = (current_values.reduce (x,y) -> x+y)/num_of_channels

      # Evaluate the formula for red, green and blue pixels.
      for i in [0...num_of_channels]
        current_value = current_values[i]
        current_foreign_value = current_overall_value - current_value
        current_surrounding_value = current_surrounding_values[i]
        current_foreign_surrounding_value = current_surrounding_population - current_surrounding_value
        try
          new_value = eval formula
          new_canvas_data.data[current_pos+i] = Math.max (Math.min new_value*highest_color_value, highest_color_value), 0
        catch error
          alert error
          clearInterval interval_id
          return
      # Makes every pixel opaque.
      new_canvas_data.data[current_pos+num_of_channels] = highest_color_value

  # Restore data into the canvas.
  c.putImageData new_canvas_data, 0, 0
  increment_iterations()

get_pos = (x,y) ->
  ((y * canvas.width) + x) * (num_of_channels + 1)

get_surrounding_values = (x,y) -> 
  value_red = 0
  value_green = 0
  value_blue = 0
  for i in [x-1...x+2]
    for j in [y-1...y+2]
      if i < 0 || j < 0 || i >= canvas.width || j >= canvas.height
        value_red += 0.0
        value_green += 0.0
        value_blue += 0.0
      else if !(x == i && y == j)
        pos = get_pos(i,j)
        value_red += canvas_data.data[pos]/highest_color_value
        value_green += canvas_data.data[pos+1]/highest_color_value
        value_blue +=canvas_data.data[pos+2]/highest_color_value
  # Normalize values.
  [value_red/8, value_green/8, value_blue/8]

