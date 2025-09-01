function Multiply-WallCostAndStrength {
    param (
        [string]$RootPath = ".\entities\buildings\defense"
    )

    # Get all files under the decorations folder (recursively)
    Get-ChildItem -Path $RootPath -File -Recurse | ForEach-Object {
        $file = $_.FullName
        $content = Get-Content $file

        # Track if we are inside a building_cost block
        $inBuildingCost = $false
        $braceDepth = 0

        for ($i = 0; $i -lt $content.Count; $i++) {
            $line = $content[$i]

            # Multiply carbonium value by 4 if matched
            if ($line -match '^\s*carbonium\s+"(\d+)"') {
                $amount = [int]$Matches[1]
                $newAmount = [math]::Max(0, $amount * 3)
                $content[$i] = $line -replace '"\d+"', "`"$newAmount`""
            }

            # Multiply steel value by 4 if matched
            if ($line -match '^\s*steel\s+"(\d+)"') {
                $amount = [int]$Matches[1]
                $newAmount = [math]::Max(0, $amount * 3)
                $content[$i] = $line -replace '"\d+"', "`"$newAmount`""
            }

            # Multiply max_health value by 4 if matched
            if ($line -match '^\s*max_health\s+"(\d+)"') {
                $amount = [int]$Matches[1]
                $newAmount = [math]::Max(0, $amount * 3)
                $content[$i] = $line -replace '"\d+"', "`"$newAmount`""
            }

            # Multiply health value by 4 if matched
            if ($line -match '^\s*health\s+"(\d+)"') {
                $amount = [int]$Matches[1]
                $newAmount = [math]::Max(0, $amount * 3)
                $content[$i] = $line -replace '"\d+"', "`"$newAmount`""
            }

            # Multiply regeneration value by 4 if matched
            if ($line -match '^\s*regeneration\s+"(\d+)"') {
                $amount = [int]$Matches[1]
                $newAmount = [math]::Max(0, $amount * 3)
                $content[$i] = $line -replace '"\d+"', "`"$newAmount`""
            }
        }

        # Write changes back to file only if modified
        Set-Content -Path $file -Value $content
    }
}

Multiply-WallCostAndStrength
