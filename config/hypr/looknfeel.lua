-- blackshield:begin
-- AMD draws a black-box hardware cursor without a software cursor.
-- Keys match Omarchy's default cursor table so a later hl.config does not drop them.
hl.env("XCURSOR_THEME", "Blackshield")
hl.env("HYPRCURSOR_THEME", "Blackshield")

-- Idle plate. Children spawned by Hyprland must resolve omarchy-screensaver
-- here, or the stock logo script wins.
local screensaver_bin = (os.getenv("HOME") or "") .. "/.config/omarchy/bin"
local path = os.getenv("PATH") or ""
if screensaver_bin ~= "/.config/omarchy/bin" and not path:find(screensaver_bin, 1, true) then
  hl.env("PATH", screensaver_bin .. ":" .. path)
end

hl.config({
  cursor = {
    -- 1 = force software cursor. Auto puts the plane back on AMD.
    no_hardware_cursors = 1,
    use_cpu_buffer = 1,
    hide_on_key_press = true,
  },
})
-- blackshield:end
