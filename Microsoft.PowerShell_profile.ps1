$Shell = $Host.UI.RawUI
$size = $Shell.WindowSize
$size.width=70
$size.height=25
$Shell.WindowSize = $size
$size = $Shell.BufferSize
$size.width=70
$size.height=300
$Shell.BufferSize = $size

function startProfile{
	start notepad++ $profile
}
new-item alias:profile -value startProfile

function notepadplusplus{
	start notepad++ $args
}
new-item alias:npp -value notepadplusplus
