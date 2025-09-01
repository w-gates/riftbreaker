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

# Multiply-WallCostAndStrength

function Set-LootChanceToZero {
    param (
        [string]$FilePath = 'C:\Program Files (x86)\Steam\steamapps\common\Riftbreaker\mods\Walter2\scripts\blueprint_tables\loot_table.dat'
    )

    $lines = Get-Content $FilePath
    $lootItems = @(
        'LootItem "mods_standard"',
        'LootItem "mods_advanced"',
        'LootItem "mods_superior"'
    )

    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match 'chance\s+"([0-9]*\.[0-9]+)"') {
            # Check if line 2 before matches a lootItem
            if ($i - 2 -ge 0 -and $lootItems -contains $lines[$i - 2].Trim()) {
                $lines[$i] = $lines[$i] -replace 'chance\s+"[0-9]*\.[0-9]+"', 'chance "0.0000"'
            }
        }
    }

    Set-Content -Path "${FilePath}.tmp" -Value $lines
}

# Usage:
Set-LootChanceToZero
