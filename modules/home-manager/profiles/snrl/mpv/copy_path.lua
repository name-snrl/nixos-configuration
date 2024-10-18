local function info(msg)
  mp.msg.info(msg)
  mp.osd_message(msg, 3)
end

local function copy_url(with_timecode)
  local url = mp.get_property 'path'
  if with_timecode then
    local timecode = tostring(math.floor(mp.get_property_number 'time-pos'))
    url = url .. '&t=' .. timecode .. 's'
  end

  local res = mp.command_native {
    name = 'subprocess',
    args = { 'wl-copy', '-n', url },
    capture_stdout = true,
    capture_stderr = true,
  }

  if res.status ~= 0 then
    info 'Failed to copy'
    mp.msg.error('stdout:\n', res.stdout)
    mp.msg.error('stderr:\n', res.stderr)
  else
    info 'Successfully copied'
  end
end

mp.add_key_binding('y', 'copy_url', function()
  copy_url(false)
end)
mp.add_key_binding('Y', 'copy_url_with_timecode', function()
  copy_url(true)
end)
