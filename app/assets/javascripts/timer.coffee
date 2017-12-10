# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ALERT_WARNING_MODAL_ID = 'alert-modal'

ROOT_DOCUMENT_CLASS               = 'rune-document'
WORLD_LIST_ITEM_TEMPLATE_ID       = 'world-list-item-template'
WORLD_TIMER_ITEM_TEMPLATE_ID      = 'world-timer-item-template'
SPEC_WORLD_TIMER_ITEM_TEMPLATE_ID = 'spec-world-timer-item-template'

WORLD_TIMER_LIST_ID    = 'world-timer-list'
WORLD_LIST_MAX_COLUMNS = 4
WORLD_LIST_IDS         = [
    'world-list-1', 'world-list-2', 'world-list-3', 'world-list-4'
]
WORLD_LIST_INSTANCE_CLASS = 'world-list'
WORLDS_LIST_OVERLAY_ID    = 'world-list-overlay'

WORLD_LIST_ONE_ROCK_CLASS  = 'world-list-item-one-rock'
WORLD_LIST_TWO_ROCKS_CLASS = 'world-list-item-two-rocks'

WORLD_TIMER_ITEM_REFRESH_CLASS = 'timer-item-refresh'
WORLD_TIMER_ITEM_REMOVE_CLASS  = 'timer-item-remove'

WORLD_LIST = [
    [1, false], [8, false], [16, false], [26, false], [35, false],
    [81, false], [82, false], [83, false], [84, false], [85, false],
    [93, false], [94, false], [2, true], [3, true], [4, true], [5, true],
    [6, true], [7, true], [9, true], [10, true], [11, true], [12, true],
    [13, true], [14, true], [15, true], [17, true], [18, true], [19, true],
    [20, true], [21, true], [22, true], [23, true], [24, true], [27, true],
    [28, true], [29, true], [30, true], [31, true], [32, true], [33, true],
    [34, true], [36, true], [38, true], [39, true], [40, true], [41, true],
    [42, true], [43, true], [44, true], [46, true], [47, true], [48, true],
    [49, true], [50, true], [51, true], [52, true], [53, true], [54, true],
    [55, true], [56, true], [57, true], [58, true], [59, true], [60, true],
    [61, true], [62, true], [65, true], [66, true], [67, true], [68, true],
    [69, true], [70, true], [73, true], [74, true], [75, true], [76, true],
    [77, true], [78, true], [86, true], [87, true], [88, true], [89, true],
    [90, true], [91, true]
]

###
WORLD_LIST = [
    [301, false], [302, true], [303, true], [304, true], [305, true],
    [306, true], [308, false], [309, true], [310, true], [311, true],
    [312, true], [313, true], [314, true], [316, false], [317, true],
    [318, true], [319, true], [320, true], [321, true], [322, true],
    [325, true], [326, false], [327, true], [328, true], [329, true],
    [330, true], [333, true], [334, true], [335, false], [336, true],
    [337, true], [338, true], [341, true], [342, true], [343, true],
    [344, true], [345, true], [346, true], [349, true], [350, true],
    [351, true], [352, true], [353, true], [354, true], [357, true],
    [358, true], [359, true], [360, true], [361, true], [362, true],
    [365, true], [366, true], [367, true], [368, true], [369, true],
    [370, true], [373, true], [374, true], [375, true], [376, true],
    [377, true], [378, true], [381, false], [382, false], [383, false],
    [384, false], [385, false], [386, true], [393, false], [394, false]
]
###

MEMBERS_GLYPHICON_CLASS  = "glyphicon glyphicon-star"
MEMBERS_LIST_ITEM_CLASS  = "world-list-item-member"

NONMEMBERS_GLYPHICON_CLASS  = "glyphicon glyphicon-star-empty"
NONMEMBERS_LIST_ITEM_CLASS  = "world-list-item-nonmember"

ADD_TIMER_FORM_ID          = 'add-timer-form'
WORLD_NUMBER_INPUT_ID      = 'world-number-input'
ROCK_NUMBER_INPUT_LIST_ID  = 'rock-number-input-list'

WORLD_TIMER_LIST_ITEM_CLASS = 'world-timer'
WORLD_NUMBER_DIV_CLASS      = 'world-number'

START_TIMER_ID = 'start-timer'

SECONDS_UNTIL_ORE_RESPAWN = 12 * 60

# Map where the key is the world number and the value is
# the array of ore numbers it is currently tracking
world_tracker_map = {}

# Generates a tag suitable for usage in the world list from an array of [world_number, is_members_world]
generate_tag_from_world = (world_info) ->
    tag = $("##{WORLD_LIST_ITEM_TEMPLATE_ID}").clone()
    tag.attr('id', '')
    tag.show()
    
    world_number     = world_info[0]
    is_members_world = world_info[1]
    
    if is_members_world
        tag.addClass(MEMBERS_LIST_ITEM_CLASS)
        tag.children().first().addClass(MEMBERS_GLYPHICON_CLASS)
    else
        tag.addClass(NONMEMBERS_LIST_ITEM_CLASS)
        tag.children().first().addClass(NONMEMBERS_GLYPHICON_CLASS)
    
    world_number_node = document.createElement('b')
    $(world_number_node).text(world_number.toString())
    tag.append(world_number_node)
    
    tag

# Distributes the items in the world_list evenly between num_columns number of arrays and returns those arrays
distribute_world_list = (world_list, num_columns) ->
    world_list = world_list.sort((a, b) -> return a[0] - b[0])
    max_column_length = world_list.length // num_columns
    
    if world_list.length % num_columns != 0
        ++max_column_length
        
    columns_list = []
    for i in [0...num_columns] by 1
        columns_list[i] = []
        for j in [0...max_column_length] by 1 when world_list.length != 0
            world = world_list.shift()
            columns_list[i].push(world)
            
    columns_list

# Populates the world list from lists of distributed worlds
populate_world_list = (distributed_worlds) ->
    minimum_length = Math.min(distributed_worlds.length, WORLD_LIST_IDS.length)
    
    for i in [0...minimum_length] by 1
        world_list = distributed_worlds[i]
        world_list_div = $("##{WORLD_LIST_IDS[i]}")
        
        world_list_tags = (generate_tag_from_world world for world in world_list)
        world_list_div.append(world_list_tags)
    
    return

# Removes all entries from the elements with the given ids
clear_world_lists = (world_list_ids) ->
    for list_id in world_list_ids
        list_element = $("##{list_id}")
        list_element.empty()
        
    return

update_world_list = () ->
    world_lists = $(".#{WORLD_LIST_INSTANCE_CLASS}")
    
    for world_list in world_lists
        world_list = $(world_list).children()
        for world_item in world_list
            world_item = $(world_item)
            world_number = parseInt(world_item.children().last().text())
            rock_trackers = world_tracker_map[world_number]
            
            # Remove all classes
            world_item.removeClass("#{WORLD_LIST_ONE_ROCK_CLASS} #{WORLD_LIST_TWO_ROCKS_CLASS}")
            
            # Add potential classes
            if rock_trackers && rock_trackers.length == 1
                world_item.addClass("#{WORLD_LIST_ONE_ROCK_CLASS}")
            else if rock_trackers && rock_trackers.length == 2
                world_item.addClass("#{WORLD_LIST_TWO_ROCKS_CLASS}")
                
    
    return

# Updates the text of display to reflect the corresponding time left in minutes
start_countdown = (seconds, display) ->
    timer = seconds
    minutes = undefined
    seconds = undefined
    
    interval_event = setInterval(() ->
        minutes = parseInt(timer / 60)
        seconds = parseInt(timer % 60)
        
        minutes = if minutes < 10 then "0#{minutes}" else minutes
        seconds = if seconds < 10 then "0#{seconds}" else seconds
        
        display.text("#{minutes}:#{seconds}")
        
        if (--timer < 0)
            clearInterval(interval_event)
    , 1000)
    
    interval_event

# Display the standard info modal with the given message
show_info_modal = (message) ->
    alert_modal = $("##{ALERT_WARNING_MODAL_ID}")
    warning_div = alert_modal.find('.alert')
    
    message_node = document.createTextNode(message)
    
    warning_div_nodes = warning_div.contents()
    if warning_div_nodes.length > 1
        warning_div_nodes.slice(2).remove()
    
    warning_div.append(message_node)
    alert_modal.modal('show')
    
    return

hide_world_list_overlay = () ->
    $("##{WORLDS_LIST_OVERLAY_ID}").hide()
    
    return
    
show_world_list_overlay = () ->
    $("##{WORLDS_LIST_OVERLAY_ID}").show()
    
    return

# Click event for world list items, populates timer form
world_list_item_click_event = (world_node) ->
    world_id = $(world_node.target).contents().last().text()
    
    # Set the world id
    $("##{WORLD_NUMBER_INPUT_ID}").val(world_id)
    
    # Trigger the change event so the form can update its fields
    $("##{WORLD_NUMBER_INPUT_ID}").trigger('paste')
    
    return

# Click event for the start timer button, adds a timer to the timer list
start_timer_click_event = (form_node) ->
    tag = $("##{WORLD_TIMER_ITEM_TEMPLATE_ID}").clone()
    
    form_root = $(form_node.target).closest("##{ADD_TIMER_FORM_ID}")
    
    # Add world number to tag
    world_number = $("##{WORLD_NUMBER_INPUT_ID}").val()
    
    if world_number.length == 0
        show_info_modal("Enter a world number before starting the timer!")
        return
    
    world_number_tag = document.createTextNode(world_number)
    world_number_div = $(tag.children().first().children().get(1))
    world_number_div.children().append(world_number_tag)

    # Add rock number to global rock tracking list
    world_number_int = parseInt(world_number)
    rock_list = $("##{ROCK_NUMBER_INPUT_LIST_ID}").children()
    rock_number_tags = $(rock_list.filter(".active"))
    
    if rock_number_tags.length == 0
        show_info_modal("Select at least one rock to track with this timer!")
        return
    
    if !world_tracker_map[world_number_int]
        world_tracker_map[world_number_int] = []
    rock_tracker = world_tracker_map[world_number_int]
    
    # Only the rocks that this timer is tracking!!!
    tracking_rocks = ($(rock_number_tag).children().first().val() for rock_number_tag in rock_number_tags)
    Array.prototype.push.apply(rock_tracker, tracking_rocks)
    
    # Activate corresponding rock boxes for timer
    rock_tags = tag.find('.btn-group').first().children()
    for tracking_rock in tracking_rocks
        tracking_rock_index = tracking_rock - 1
        rock_tag = $(rock_tags.get(tracking_rock_index))
        rock_tag.addClass('active')
    
    # Add tag to list
    timer_list = $("##{WORLD_TIMER_LIST_ID}")
    timer_list.append(tag)
    tag.slideDown('fast')
    
    # Start timer
    timer_node = tag.find(".#{WORLD_TIMER_LIST_ITEM_CLASS}")
    timer_id = start_countdown(SECONDS_UNTIL_ORE_RESPAWN, timer_node)
    
    # TODO: This should probably be change eventually
    tag.attr('id', timer_id)
    
    # Revert world input
    $("##{WORLD_NUMBER_INPUT_ID}").val('')
    
    # Trigger event for current world number change
    $("##{WORLD_NUMBER_INPUT_ID}").trigger('paste')
    
    # Update color of world list cells
    update_world_list()
    
    return

# Click event for the cancel button, removes the timer item from the list
remove_timer_click_event = (timer_node) ->
    list_item_node = $(timer_node.target).closest('li')
    list_item_node.slideUp('fast', () -> $(this).remove())
    
    world_number = parseInt(list_item_node.find(".#{WORLD_NUMBER_DIV_CLASS}").contents().last().text())
    active_rocks_list = world_tracker_map[world_number]
    
    rocks_label_list = list_item_node.find('.btn-group').first().children()
    active_rocks_label_list = rocks_label_list.filter('.active')
    
    for active_rock_label in active_rocks_label_list
        active_rock_number = $(active_rock_label).children().first().val()
        rock_number_position = active_rocks_list.indexOf(active_rock_number)
        if rock_number_position != -1
            active_rocks_list.splice(rock_number_position, 1)
    
    # Trigger event for current world number change
    $("##{WORLD_NUMBER_INPUT_ID}").trigger('paste')
    
    # Update color of world list cells
    update_world_list()
    
    return

# Click event for the refresh button, refreshes a timer item
refresh_timer_click_event = (timer_node) ->
    timer_element = $(timer_node.target).closest('li')
    
    # Stop previous timer event
    old_timer_id = parseInt(timer_element.attr('id'))
    clearInterval(old_timer_id)
    
    timers_list = timer_element.parent().children()
    timer_element.insertAfter(timers_list.last())
    
    # Start timer
    timer_node_element = timer_element.find(".#{WORLD_TIMER_LIST_ITEM_CLASS}")
    new_timer_id = start_countdown(SECONDS_UNTIL_ORE_RESPAWN, timer_node_element)
    
    # TODO: This should probably be change eventually
    timer_element.attr('id', new_timer_id)
    
    return

# Change event for the world input, updates the availables rocks to track
world_input_change_event = (input_node) ->
    world_input_node = $(input_node.target)
    world_number = parseInt(world_input_node.val()) || -1
    
    current_tracked_ores = world_tracker_map[world_number] || []
    
    rock_input_list = $("##{ROCK_NUMBER_INPUT_LIST_ID}").children()
    # Set rock input back to default configuration
    rock_input_list.show()
    rock_input_list.removeClass('active')
    
    # Go through and remove options corresponding to currently tracked rocks
    for rock_number in current_tracked_ores
        rock_index = rock_number - 1
        rock_input = $(rock_input_list[rock_index])
        rock_input.hide()
    
    return

# Run after page is loaded
$(document).ready(() -> 
    distributed_worlds = distribute_world_list(WORLD_LIST, WORLD_LIST_MAX_COLUMNS)
    populate_world_list(distributed_worlds)
    
    # Set events
    $(document).on('mousedown', ".#{WORLD_LIST_INSTANCE_CLASS}", world_list_item_click_event)
    $(document).on('click', "##{START_TIMER_ID}", start_timer_click_event)
    $(document).on('click', ".#{WORLD_TIMER_ITEM_REMOVE_CLASS}", remove_timer_click_event)
    $(document).on('click', ".#{WORLD_TIMER_ITEM_REFRESH_CLASS}", refresh_timer_click_event)
    $(document).on('keyup paste', "##{WORLD_NUMBER_INPUT_ID}", world_input_change_event)
    
    # Try to fetch an update world list from runescape
    ###
    $.ajax({
        url: '/worlds',
        type: 'GET',
        dataType: 'json',
        timeout: 2000,
        success: (result) ->
            WORLD_LIST = result
            
            clear_world_lists(WORLD_LIST_IDS)
            distributed_worlds = distribute_world_list(WORLD_LIST, WORLD_LIST_MAX_COLUMNS)
            populate_world_list(distributed_worlds)
            
            hide_world_list_overlay()
        error: () ->
            hide_world_list_overlay()
            
            show_info_modal("Failed to fetch updated world list, reverting to last good world list")
    });
    ###

    return
)
