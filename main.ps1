param (
  [Parameter(Mandatory = $true)]
  [string]$input_file
)

function IsValidNumber() {
  param ($str)

  return $str -match "^\d+(,\d{3})*\.(\d{1,2})"
}

function ExtractAmmount {
  param ($line)

  if ([string]::IsNullOrEmpty($line)) {
    return [string]::Empty
  }

  $items = $line.Split(" ")

  if ($items.Count -lt 2) {
    return [string]::Empty
  }

  if ($items[$items.Count - 2].EndsWith("Total")) {
    return [string]::Empty
  }

  $sum_str = $items[$items.Count - 1];

  if ($sum_str.StartsWith("(") -and $sum_str.EndsWith(")")) {
    $just_number = $sum_str.Substring(1, $sum_str.Length - 2);
    if (IsValidNumber($just_number)) {
      return $sum_str
    }
  }

  if (IsValidNumber($sum_str)) {
    return $sum_str
  }

  return [string]::Empty
}


Get-Content $input_file | ForEach-Object {

  $amount = ExtractAmmount($_)
  if (![string]::IsNullOrEmpty($amount)) {
    Write-Output "$_`t$amount"
  }

}


