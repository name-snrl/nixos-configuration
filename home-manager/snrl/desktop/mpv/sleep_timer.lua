local timeout_list = { 0, 5, 10, 15, 20, 25, 30, 40, 50, 60, 90 }

local function info(msg)
  mp.msg.info(msg)
  mp.osd_message(msg, 3)
end

local function human_readable(sec)
  local minutes = math.floor(sec / 60)
  local remaining_sec = math.floor(sec % 60)

  if sec == 0 then
    return 'off'
  elseif sec < 60 then
    return string.format('%s sec', sec)
  elseif remaining_sec == 0 then
    return string.format('%s min', minutes)
  else
    return string.format('%s:%s min', minutes, remaining_sec)
  end
end

local current_timeout = 0
local last_call_time = 0
local first_changeable_call = true
local timer

local function sleep_timer(mode)
  local call_time = mp.get_time()
  local delay = call_time - last_call_time

  -- update state
  last_call_time = call_time
  current_timeout = mp.get_next_timeout() or 0

  -- if more than 3 seconds have elapsed since the last call,
  -- just print the current timeout
  if delay > 3 then
    if current_timeout == 0 then
      info(human_readable(current_timeout))
    else
      info(human_readable(current_timeout) .. ' left')
    end
    first_changeable_call = true
    return
  end

  -- set a new timeout, but first we need to destroy the old one.
  if timer then
    timer:kill()
  end

  -- calculate new one
  local seconds_timeout_list = {}
  for i, t_min in ipairs(timeout_list) do
    seconds_timeout_list[i] = t_min * 60
  end

  local left = 1
  local right = #seconds_timeout_list

  while right - left > 1 do
    local mid = math.floor((left + right) / 2)
    if seconds_timeout_list[mid] > current_timeout then
      right = mid
    else
      left = mid
    end
  end

  if mode == 'next' and first_changeable_call then
    current_timeout = seconds_timeout_list[right]
  elseif mode == 'prev' and current_timeout == seconds_timeout_list[1] then
    current_timeout = seconds_timeout_list[#seconds_timeout_list]
  elseif mode == 'next' then
    current_timeout = seconds_timeout_list[right + 1]
    if not current_timeout then
      current_timeout = seconds_timeout_list[1]
    end
  elseif mode == 'prev' then
    current_timeout = seconds_timeout_list[left]
  end

  first_changeable_call = false

  info('timeout ' .. human_readable(current_timeout))

  if current_timeout == 0 then
    return
  end

  timer = mp.add_timeout(current_timeout, function()
    mp.command 'quit-watch-later'
  end)
end

mp.add_key_binding('t', function()
  sleep_timer 'next'
end)
mp.add_key_binding('T', function()
  sleep_timer 'prev'
end)
