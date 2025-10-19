# startup.ps1 - Start your development environment

cd C:\Users\Woyengidinipre\cloud-engineering-portfolio\project-01-three-tier-app

Write-Host "🚀 Starting development environment..." -ForegroundColor Cyan

docker-compose up -d
Start-Sleep -Seconds 20

Write-Host "
✅ Checking status..." -ForegroundColor Green
docker-compose ps

Write-Host "
🔍 Testing health endpoint..." -ForegroundColor Cyan
$health = curl http://localhost:3000/health 2>
if ($health -match "healthy") {
    Write-Host "✅ Backend is healthy!" -ForegroundColor Green
    Write-Host "
📍 Your application is ready:" -ForegroundColor Cyan
    Write-Host "   Frontend: http://localhost:3001" -ForegroundColor Yellow
    Write-Host "   Backend:  http://localhost:3000" -ForegroundColor Yellow
    Write-Host "   API Docs: http://localhost:3000/api/users" -ForegroundColor Yellow
} else {
    Write-Host "⚠️  Backend not responding yet. Wait a moment and try again." -ForegroundColor Yellow
}
