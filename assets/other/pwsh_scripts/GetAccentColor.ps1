$res = "{0:X}" -f (Get-ItemPropertyValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" "AccentColorMenu")

# Convert ABGR to ARGB
#$a = ($res.Substring(0,2))
$r = ($res.Substring(6,2))
$g = ($res.Substring(4,2))
$b = ($res.Substring(2,2))

# Return the color in Int64 (Which is what Haxe uses)
[Convert]::ToInt64("$r$g$b", 16)