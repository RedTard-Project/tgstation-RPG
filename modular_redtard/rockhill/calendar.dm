GLOBAL_LIST_EMPTY(rockhill_calendar_events)
GLOBAL_LIST_INIT(rockhill_time_tips, rockhill_time_tips())
GLOBAL_LIST_EMPTY(rockhill_scomms)
GLOBAL_VAR_INIT(rockhill_date_offset, 0)
GLOBAL_VAR_INIT(rockhill_date_overridden, FALSE)
GLOBAL_LIST_INIT(rockhill_month_names, list("Psyrise", "Eora", "Dendor", "Astrata", "Xylix", "Malum", "Syonfall", "Pestra", "Necra", "Noc", "Abyssor", "Ravox"))
GLOBAL_LIST_INIT(rockhill_seasons, list("Spring", "Summer", "Autumn", "Winter"))
GLOBAL_LIST_INIT(rockhill_season_phases, list("Early", "Mid", "Late"))

/proc/rockhill_time_tips()
	return world.file2list(ROCKHILL_TIME_TIPS_FILE) - ""

/datum/rockhill_calendar_event
	var/id
	var/recur_month
	var/recur_day
	var/duration_days = 1
	var/title
	var/desc
	var/reminder
	var/list/reminders
	var/color_tag = ROCKHILL_CALENDAR_DEFAULT_COLOR

/datum/rockhill_calendar_event/proc/load_from_list(list/entry)
	if(!islist(entry))
		return FALSE
	id = entry["id"]
	recur_month = text2num("[entry["recur_month"]]")
	recur_day = text2num("[entry["recur_day"]]")
	if(entry["duration_days"])
		duration_days = max(1, text2num("[entry["duration_days"]]"))
	title = entry["title"]
	desc = entry["desc"]
	reminder = entry["reminder"]
	if(islist(entry["reminders"]))
		reminders = entry["reminders"]
	if(entry["color_tag"])
		color_tag = entry["color_tag"]
	return id && title && recur_month >= 1 && recur_month <= ROCKHILL_CALENDAR_MONTHS && recur_day >= 1 && recur_day + duration_days - 1 <= ROCKHILL_CALENDAR_DAYS_IN_MONTH

/datum/rockhill_calendar_event/proc/covers_day(month, day)
	return month == recur_month && day >= recur_day && day < recur_day + duration_days

/datum/rockhill_calendar_event/proc/day_index(month, day)
	return covers_day(month, day) ? day - recur_day + 1 : 0

/datum/rockhill_calendar_event/proc/reminder_for_day(month, day)
	var/index = day_index(month, day)
	if(!index)
		return null
	return LAZYACCESS(reminders, index) || reminder

/datum/rockhill_calendar_event/proc/to_ui_list()
	return list(
		"id" = id,
		"calendar_system" = ROCKHILL_CALENDAR_SYSTEM,
		"month" = recur_month,
		"day" = recur_day,
		"duration_days" = duration_days,
		"title" = title,
		"desc" = desc,
		"color_tag" = color_tag,
	)

/proc/rockhill_load_calendar_events()
	GLOB.rockhill_calendar_events.Cut()
	var/list/parsed = fexists(ROCKHILL_CALENDAR_EVENTS_FILE) ? safe_json_decode(file2text(ROCKHILL_CALENDAR_EVENTS_FILE)) : null
	if(!islist(parsed))
		log_world("Rockhill calendar: no events in [ROCKHILL_CALENDAR_EVENTS_FILE]")
		return
	var/list/seen = list()
	for(var/list/entry in parsed)
		var/datum/rockhill_calendar_event/event = new
		if(!event.load_from_list(entry) || (event.id in seen))
			log_world("Rockhill calendar: skipped event [json_encode(entry)]")
			qdel(event)
			continue
		seen += event.id
		GLOB.rockhill_calendar_events += event

/proc/rockhill_date_parts(day_number = GLOB.rockhill_days_passed)
	var/round_number = text2num(GLOB.round_id) || 0
	var/days_since_epoch = round_number * ROCKHILL_CALENDAR_DAYS_IN_WEEK + max(day_number, 1) - 1 + GLOB.rockhill_date_offset
	var/day_of_year = MODULUS(days_since_epoch, ROCKHILL_CALENDAR_DAYS_IN_YEAR) + 1
	var/month = floor((day_of_year - 1) / ROCKHILL_CALENDAR_DAYS_IN_MONTH) + 1
	var/day = MODULUS(day_of_year - 1, ROCKHILL_CALENDAR_DAYS_IN_MONTH) + 1
	return list(day, month, ROCKHILL_CALENDAR_EPOCH_YEAR)

/proc/rockhill_date_short(day_number = GLOB.rockhill_days_passed)
	var/list/parts = rockhill_date_parts(day_number)
	return "[parts[1]] [GLOB.rockhill_month_names[parts[2]]] [parts[3]] AP"

/proc/rockhill_date_full(day_number = GLOB.rockhill_days_passed)
	var/list/parts = rockhill_date_parts(day_number)
	var/round_number = text2num(GLOB.round_id) || 0
	var/cycle = floor(round_number / (ROCKHILL_CALENDAR_YEARS_PER_CYCLE * ROCKHILL_CALENDAR_WEEKS_IN_YEAR)) + 1
	return "[rockhill_date_short(day_number)] (Month [parts[2]] [rockhill_season_phase(parts[2])] [rockhill_season(parts[2])]), Cycle [cycle]"

/proc/rockhill_season(month)
	return GLOB.rockhill_seasons[ceil(month / 3)]

/proc/rockhill_season_phase(month)
	return GLOB.rockhill_season_phases[MODULUS(month - 1, 3) + 1]

/proc/rockhill_events_for_month(month)
	. = list()
	for(var/datum/rockhill_calendar_event/event as anything in GLOB.rockhill_calendar_events)
		if(event.recur_month == month)
			. += event

/proc/rockhill_events_today()
	var/list/parts = rockhill_date_parts()
	. = list()
	for(var/datum/rockhill_calendar_event/event as anything in GLOB.rockhill_calendar_events)
		if(event.covers_day(parts[2], parts[1]))
			. += event

/proc/rockhill_event_ordinal(index)
	if(index >= 1 && index <= length(GLOB.rockhill_event_ordinals))
		return GLOB.rockhill_event_ordinals[index]
	var/suffix = "th"
	var/last_two = MODULUS(index, 100)
	if(last_two < 11 || last_two > 13)
		switch(MODULUS(index, 10))
			if(1)
				suffix = "st"
			if(2)
				suffix = "nd"
			if(3)
				suffix = "rd"
	return "[index][suffix]"

GLOBAL_LIST_INIT(rockhill_event_ordinals, list("first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth"))

/proc/rockhill_announce_new_dawn()
	var/list/parts = rockhill_date_parts()
	for(var/datum/rockhill_calendar_event/event as anything in rockhill_events_today())
		var/line = "The [rockhill_event_ordinal(event.day_index(parts[2], parts[1]))] dae of [event.title]."
		var/reminder_line = event.reminder_for_day(parts[2], parts[1])
		if(reminder_line)
			line = "[line] [reminder_line]"
		for(var/obj/structure/roguemachine/scomm/scom as anything in GLOB.rockhill_scomms)
			scom.say(line)

/obj/structure/roguemachine/scomm/Initialize(mapload)
	. = ..()
	GLOB.rockhill_scomms += src

/obj/structure/roguemachine/scomm/Destroy()
	GLOB.rockhill_scomms -= src
	return ..()

/datum/rockhill_calendar_ui
	var/view_month
	var/view_year
	var/wrap_count = 0

/datum/rockhill_calendar_ui/New()
	var/list/parts = rockhill_date_parts()
	view_month = parts[2]
	view_year = parts[3]

/datum/rockhill_calendar_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Calendar", "Calendar")
		ui.open()

/datum/rockhill_calendar_ui/ui_state(mob/user)
	return GLOB.always_state

/datum/rockhill_calendar_ui/ui_data(mob/user)
	var/list/parts = rockhill_date_parts()
	var/list/months = list()
	for(var/month in 1 to ROCKHILL_CALENDAR_MONTHS)
		months += list(list(
			"number" = month,
			"name" = GLOB.rockhill_month_names[month],
			"season" = rockhill_season(month),
			"phase" = rockhill_season_phase(month),
		))
	var/list/events = list()
	for(var/datum/rockhill_calendar_event/event as anything in rockhill_events_for_month(view_month))
		events += list(event.to_ui_list())
	return list(
		"today_day" = parts[1],
		"today_month" = parts[2],
		"today_year" = parts[3],
		"today_week" = ceil(parts[1] / ROCKHILL_CALENDAR_DAYS_IN_WEEK),
		"view_month" = view_month,
		"view_year" = view_year,
		"weekday_names" = list("Moon's", "Tiw's", "Wedding's", "Thule's", "Freyja's", "Saturn's", "Sun's"),
		"days_in_month" = ROCKHILL_CALENDAR_DAYS_IN_MONTH,
		"days_in_week" = ROCKHILL_CALENDAR_DAYS_IN_WEEK,
		"months" = months,
		"events" = events,
		"wrap_count" = wrap_count,
	)

/datum/rockhill_calendar_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("prev_month")
			if(view_month <= 1)
				view_month = ROCKHILL_CALENDAR_MONTHS
				wrap_count++
			else
				view_month--
			return TRUE
		if("next_month")
			if(view_month >= ROCKHILL_CALENDAR_MONTHS)
				view_month = 1
				wrap_count++
			else
				view_month++
			return TRUE
		if("jump_month")
			var/target = text2num("[params["month"]]")
			if(target >= 1 && target <= ROCKHILL_CALENDAR_MONTHS)
				view_month = target
				return TRUE
		if("today")
			var/list/parts = rockhill_date_parts()
			view_month = parts[2]
			view_year = parts[3]
			wrap_count = 0
			return TRUE

/datum/rockhill_calendar_ui/ui_close(mob/user)
	qdel(src)

/client/verb/rockhill_view_calendar()
	set category = "IC"
	set name = "View Calendar"
	set desc = "View the Vale Calendar - the month, season, and upcoming feast daes."
	var/datum/rockhill_calendar_ui/calendar = new
	calendar.ui_interact(mob)

ADMIN_VERB(rockhill_set_ic_date, R_ADMIN, "Set IC Date", "Set or clear the IC calendar date override.", ADMIN_CATEGORY_ROGUE)
	var/choice = tgui_alert(user, "What would you like to do?", "IC Date Override", list("Set Custom Date", "Clear Override"))
	if(choice == "Clear Override")
		if(GLOB.rockhill_date_overridden)
			GLOB.rockhill_date_overridden = FALSE
			GLOB.rockhill_date_offset = 0
			message_admins("[key_name_admin(user)] cleared the IC date override. Date is now: [rockhill_date_full()]")
			log_admin("[key_name(user)] cleared the IC date override")
			BLACKBOX_LOG_ADMIN_VERB("Set IC Date - Clear")
		return
	if(choice != "Set Custom Date")
		return
	var/list/months = list()
	for(var/month in 1 to ROCKHILL_CALENDAR_MONTHS)
		months["[month] - [GLOB.rockhill_month_names[month]]"] = month
	var/month_choice = tgui_input_list(user, "Select the month:", "Set IC Date - Month", months)
	if(!month_choice)
		return
	var/target_day = tgui_input_number(user, "Enter the day of the month (1-[ROCKHILL_CALENDAR_DAYS_IN_MONTH]):", "Set IC Date - Day", 1, ROCKHILL_CALENDAR_DAYS_IN_MONTH, 1)
	if(isnull(target_day))
		return
	var/list/today = rockhill_date_parts()
	var/today_of_year = (today[2] - 1) * ROCKHILL_CALENDAR_DAYS_IN_MONTH + today[1]
	var/target_of_year = (months[month_choice] - 1) * ROCKHILL_CALENDAR_DAYS_IN_MONTH + target_day
	GLOB.rockhill_date_offset += target_of_year - today_of_year
	GLOB.rockhill_date_overridden = TRUE
	message_admins("[key_name_admin(user)] set the IC date override. New date: [rockhill_date_full()], time: [rockhill_day_name()] ᛉ [rockhill_timestamp()]")
	log_admin("[key_name(user)] set the IC date override to [target_day]/[months[month_choice]]")
	to_chat(user, span_notice("IC Date set to: [rockhill_date_full()]. This date will advance naturally as days pass."))
	BLACKBOX_LOG_ADMIN_VERB("Set IC Date")
