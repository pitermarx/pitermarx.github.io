$img = (gci *.jpg -R)
$k = $ENV:TINY_PNG_KEY
$img |  % {
    $n = $_.Name
    Write-Host "Compressing $n"
    $f = $_.FullName
    $rJson = curl --user api:$k --data-binary "@$f" -i https://api.tinify.com/shrink
    $r = $rJson[9] | ConvertFrom-Json
    $ratio = $r.output.ratio

    Write-Host "Ratio is $ratio"
    if ($ratio -lt 0.8) {
        rm $f
        iwr $r.output.url -O $f
    }
}