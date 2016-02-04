# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
create_option_for_Sensor = ->
    sensor = ["SW Sensor" ,"Temperature Sensor" ,"Luminosity Sensor" ,"Sound Sensor" , "Gas Sensor", "Switch Sensor", "Pressure Sensor"]
    for i in [0...sensor.length]
        $('#device').append( $("<option></option>").attr("value",sensor[i]).text(sensor[i]))
delete_all_options =  ->
    $('#device')
        .empty()
create_option_for_Actuator = ->
    actuator = ["Switch Actuator", "Led Actuator" , "IR Actuator"]
    for i in [0...actuator.length]
        $('#device').append( $("<option></option>").attr("value",actuator[i]).text(actuator[i]))

    
$ ->
  $('#device_type').change (e) ->
     if  $( "#device_type" ).val() == "Sensor"
        delete_all_options()
        create_option_for_Sensor() 
     else
        delete_all_options() 
        create_option_for_Actuator() 
  $('#device_type').ready (e) ->
      create_option_for_Actuator()

