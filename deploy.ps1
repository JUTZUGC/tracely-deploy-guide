# Tracely 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://doc.tracely-ai.com
# 更新日期：2026-10-29
# 类型：docker
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

foreach ($cmd in @('git', 'docker')) {
  if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) { throw "需要先安装 $cmd" }
}
docker compose version | Out-Null
if ($LASTEXITCODE -ne 0) { throw '需要 Docker Compose v2（docker compose 子命令）' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

git clone https://github.com/jwuthri-cloud/Tracely-ai.git
Set-Location Tracely-ai
docker compose --profile demo up -d --build --wait
Write-Host "已启动：http://127.0.0.1:3001 （后端 8000）"

Write-Host ''
$url = 'http://127.0.0.1:3001'
Write-Host "等待服务启动：$url"
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
  try {
    Invoke-WebRequest -UseBasicParsing -Uri $url -TimeoutSec 3 | Out-Null
    $ready = $true
    break
  } catch {
    Start-Sleep -Seconds 2
  }
}
if (-not $ready) { throw "60 秒内未探测到 $url，请手动打开确认或查看日志" }
Write-Host '服务已就绪'
Write-Host '部署完成：打开 http://127.0.0.1:3001 查看演示数据；生产使用前先改 .env 与鉴权，再接 SDK 或 OTLP'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://doc.tracely-ai.com'
