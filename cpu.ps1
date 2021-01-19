
New-Item -Path "C:\temp\" -Name "CPU_log.txt" -ItemType "file"


$tetik = New-JobTrigger -At "19/01/2021 16:17:28" -RepetitionInterval (New-TimeSpan -Minutes 1) -RepeatIndefinitely $true


Register-ScheduledJob -Name 'cpuLogJob' -Trigger $tetik -ScriptBlock {
  $cekirdek_sayisi = (Get-WMIObject Win32_ComputerSystem).NumberOfLogicalProcessors

  
  $tarih_saat = Get-Date -Format "MM/dd/yyyy HH:mm"
  $tarih_saat

  $kirkdan_cok_processler = (Get-Counter '\Process(*)\% Processor Time' -ErrorAction SilentlyContinue).
  CounterSamples | Where-Object {
  ($_.InstanceName -ne '_total') -and
  ($_.InstanceName -ne 'idle') -and
  ((($_.CookedValue)/$cekirdek_sayisi) -gt 40)}
  
  $process_listesi = $kirkdan_cok_processler.InstanceName
  foreach ($i in $process_listesi){
    $i = $tarih_saat + ' ' + $i
    $i | Add-Content C:\temp\CPU_log.txt
  }

  $satir_sayisi = (Get-Content C:\temp\CPU_log.txt | Measure-Object –Line).Lines

  .
  if ($satir_sayisi -ge 5000){
    $satir_array = Get-Content C:\temp\CPU_log.txt
    $yarisi_atilmis_log = $satir_array[-2500..-1]
    $yarisi_atilmis_log > C:\temp\CPU_log.txt
 
