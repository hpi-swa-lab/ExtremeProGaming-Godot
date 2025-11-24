extends Node

# --- State Management ---
enum State {IDLE, RECORDING, REPLAYING}
var current_state: int = State.IDLE

# --- Recording Data ---
var input_history: Array = []
var recording_start_time: float = 0.0

# --- Replay Data ---
var replay_index: int = 0
var replay_time: float = 0.0

# --- Input Mappings (Assuming these are NOT set up in Project Settings) ---
# We use KEY_CODE constants for the controls (Ctrl + R/B)
const TOGGLE_RECORD_KEY = KEY_R
const START_REPLAY_KEY = KEY_B
const MODIFIER_KEY = KEY_CTRL


# Called when an input event has not been handled by other controls
func _unhandled_input(event):
	# Check for the control keys only when IDLE or RECORDING
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		
		# Check if the Ctrl key is held down
		var ctrl_pressed = Input.is_key_pressed(MODIFIER_KEY)
		
		if ctrl_pressed and event.keycode == TOGGLE_RECORD_KEY:
			_toggle_recording()
		
		elif current_state == State.IDLE and ctrl_pressed and event.keycode == START_REPLAY_KEY:
			_start_replay()

	# If in RECORDING state, capture all relevant mouse events
	if current_state == State.RECORDING:
		if event is InputEventMouseButton or event is InputEventMouseMotion:
			_record_event(event)

# --- State Control Functions ---

func _toggle_recording():
	if current_state == State.IDLE:
		_start_recording()
	elif current_state == State.RECORDING:
		_stop_recording()
		
func _start_recording():
	current_state = State.RECORDING
	input_history.clear()
	# Get the current time in seconds to use as the zero reference point
	recording_start_time = Time.get_ticks_msec() / 1000.0
	print("\n--- RECORDING STARTED ---")
	print("Timestamp 0.0s")

func _stop_recording():
	current_state = State.IDLE
	print("--- RECORDING STOPPED ---")
	print("Total events recorded: ", input_history.size())

func _start_replay():
	if input_history.is_empty():
		print("ERROR: No input history to replay.")
		return
		
	current_state = State.REPLAYING
	replay_index = 0
	replay_time = 0.0
	print("\n--- REPLAY STARTED ---")
	print("Playing back ", input_history.size(), " events.")


# --- Recording Logic ---

func _record_event(event: InputEvent):
	# Calculate the time elapsed since the recording started
	var current_time: float = Time.get_ticks_msec() / 1000.0
	var relative_time: float = current_time - recording_start_time
	
	# Create a dictionary to store the event data
	# We manually extract properties instead of using as_text_dict() for reliability
	var event_record: Dictionary = {
		"time": relative_time,
		"type": event.get_class() # Store the class name
	}
	
	# Manually extract properties based on the specific event type
	if event is InputEventMouseButton:
		event_record.button_index = event.button_index
		event_record.pressed = event.pressed
		event_record.position = event.position
		event_record.global_position = event.global_position # <-- FIX: Now recording global position
	
	elif event is InputEventMouseMotion:
		event_record.position = event.position
		event_record.relative = event.relative
		event_record.global_position = event.global_position # <-- FIX: Now recording global position
	
	input_history.append(event_record)
	
	# Log what was saved
	print("SAVED: [", "%.4f" % relative_time, "s] ", event.get_class(), " @ ", event.get_position())

# --- Replay Logic ---

func _process(delta):
	if current_state != State.REPLAYING:
		return

	replay_time += delta

	# Loop through all recorded events that should have occurred by replay_time
	while replay_index < input_history.size():
		var event_record: Dictionary = input_history[replay_index]
		var event_time: float = event_record.time

		# If the current replay time has reached or passed the event's recorded time
		if replay_time >= event_time:
			
			var event_class: String = event_record.type
			var event_to_inject = null
			
			if event_class == "InputEventMouseButton":
				var new_event = InputEventMouseButton.new()
				# Read properties directly from event_record
				new_event.button_index = event_record.button_index
				new_event.pressed = event_record.pressed
				new_event.position = event_record.position
				new_event.global_position = event_record.global_position # <-- FIX: Now setting global position
				event_to_inject = new_event
			
			elif event_class == "InputEventMouseMotion":
				var new_event = InputEventMouseMotion.new()
				# Read properties directly from event_record
				new_event.position = event_record.position
				new_event.relative = event_record.relative
				new_event.global_position = event_record.global_position # <-- FIX: Now setting global position
				event_to_inject = new_event
			
			# --- Injection (The Core Replay Action) ---
			if event_to_inject != null:
				# Use the injection method requested:
				Input.parse_input_event(event_to_inject)
				
				# Log the playback action
				print("PLAYBACK: [", "%.4f" % replay_time, "s] ", event_to_inject.get_class(), " injected.")
			
			# Move to the next event
			replay_index += 1
		else:
			# The next event is in the future, wait for the next frame
			break

	# Check for replay end
	if replay_index >= input_history.size():
		current_state = State.IDLE
		print("--- REPLAY FINISHED ---")
