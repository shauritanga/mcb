#!/usr/bin/env python3
"""
Health Check API for MCB Data Integration
FastAPI endpoints for health monitoring and status
"""

import asyncio
import time
import logging
from typing import Dict, Any, Optional
from fastapi import FastAPI, HTTPException, BackgroundTasks
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from datetime import datetime

from monitoring.metrics_collector import MCBMetricsCollector

logger = logging.getLogger(__name__)

class HealthResponse(BaseModel):
    """Health check response model"""
    status: str
    timestamp: float
    checks: Dict[str, Dict[str, Any]]
    summary: Optional[Dict[str, Any]] = None

class EndpointStatusResponse(BaseModel):
    """Endpoint status response model"""
    endpoint_id: str
    status: str
    last_success: float
    metrics: Dict[str, Any]

class SystemStatusResponse(BaseModel):
    """System status response model"""
    status: str
    active_pollers: int
    total_endpoints: int
    health_percentage: float
    metrics: Dict[str, Any]
    timestamp: float

class HealthAPI:
    """Health check API for MCB integration"""
    
    def __init__(self, metrics_collector: MCBMetricsCollector, 
                 integration_engine=None):
        self.app = FastAPI(
            title="MCB Data Integration Health API",
            description="Health monitoring and status API for MCB BOT integration",
            version="1.0.0"
        )
        self.metrics_collector = metrics_collector
        self.integration_engine = integration_engine
        
        # Setup routes
        self._setup_routes()
    
    def _setup_routes(self):
        """Setup API routes"""
        
        @self.app.get("/health", response_model=HealthResponse)
        async def health_check():
            """Comprehensive health check"""
            try:
                checks = {}
                
                # Check database connectivity
                db_status = await self._check_database()
                checks["database"] = db_status
                
                # Check Redis connectivity
                redis_status = await self._check_redis()
                checks["redis"] = redis_status
                
                # Check application status
                app_status = await self._check_application()
                checks["application"] = app_status
                
                # Check endpoint health
                endpoint_status = await self._check_endpoints()
                checks["endpoints"] = endpoint_status
                
                # Determine overall status
                all_healthy = all(
                    check.get("status") == "healthy" 
                    for check in checks.values()
                )
                
                overall_status = "healthy" if all_healthy else "unhealthy"
                
                # Get summary metrics
                summary = self.metrics_collector.get_summary_metrics()
                
                return HealthResponse(
                    status=overall_status,
                    timestamp=time.time(),
                    checks=checks,
                    summary=summary
                )
                
            except Exception as e:
                logger.error(f"Health check error: {e}")
                raise HTTPException(status_code=500, detail=str(e))
        
        @self.app.get("/health/simple")
        async def simple_health_check():
            """Simple health check for load balancer"""
            try:
                # Basic application health
                app_status = await self._check_application()
                
                if app_status.get("status") == "healthy":
                    return {"status": "ok", "timestamp": time.time()}
                else:
                    return JSONResponse(
                        status_code=503,
                        content={"status": "unhealthy", "timestamp": time.time()}
                    )
                    
            except Exception as e:
                logger.error(f"Simple health check error: {e}")
                return JSONResponse(
                    status_code=503,
                    content={"status": "error", "error": str(e), "timestamp": time.time()}
                )
        
        @self.app.get("/status", response_model=SystemStatusResponse)
        async def system_status():
            """Get detailed system status"""
            try:
                if not self.integration_engine:
                    raise HTTPException(status_code=503, detail="Integration engine not available")
                
                engine_status = self.integration_engine.get_system_status()
                health_status = self.metrics_collector.get_health_status()
                summary_metrics = self.metrics_collector.get_summary_metrics()
                
                return SystemStatusResponse(
                    status=health_status["status"],
                    active_pollers=engine_status["active_pollers"],
                    total_endpoints=engine_status["total_endpoints"],
                    health_percentage=health_status["health_percentage"],
                    metrics=summary_metrics,
                    timestamp=time.time()
                )
                
            except Exception as e:
                logger.error(f"System status error: {e}")
                raise HTTPException(status_code=500, detail=str(e))
        
        @self.app.get("/endpoints/{endpoint_id}/status", response_model=EndpointStatusResponse)
        async def endpoint_status(endpoint_id: str):
            """Get status for specific endpoint"""
            try:
                metrics = self.metrics_collector.get_endpoint_metrics(endpoint_id)
                
                if not metrics:
                    raise HTTPException(status_code=404, detail=f"Endpoint {endpoint_id} not found")
                
                # Determine endpoint status
                now = time.time()
                last_success_age = now - metrics.last_success_timestamp
                
                if last_success_age < 300:  # 5 minutes
                    status = "healthy"
                elif last_success_age < 600:  # 10 minutes
                    status = "warning"
                else:
                    status = "unhealthy"
                
                return EndpointStatusResponse(
                    endpoint_id=endpoint_id,
                    status=status,
                    last_success=metrics.last_success_timestamp,
                    metrics={
                        "records_processed": metrics.records_processed,
                        "records_failed": metrics.records_failed,
                        "connection_failures": metrics.connection_failures,
                        "last_processing_time": metrics.last_processing_time,
                        "processing_time_total": metrics.processing_time_total
                    }
                )
                
            except HTTPException:
                raise
            except Exception as e:
                logger.error(f"Endpoint status error: {e}")
                raise HTTPException(status_code=500, detail=str(e))
        
        @self.app.get("/metrics/summary")
        async def metrics_summary():
            """Get metrics summary"""
            try:
                return self.metrics_collector.get_summary_metrics()
            except Exception as e:
                logger.error(f"Metrics summary error: {e}")
                raise HTTPException(status_code=500, detail=str(e))
        
        @self.app.post("/admin/restart-endpoint/{endpoint_id}")
        async def restart_endpoint(endpoint_id: str, background_tasks: BackgroundTasks):
            """Restart specific endpoint (admin operation)"""
            try:
                if not self.integration_engine:
                    raise HTTPException(status_code=503, detail="Integration engine not available")
                
                # Add background task to restart endpoint
                background_tasks.add_task(self._restart_endpoint, endpoint_id)
                
                return {"message": f"Restart initiated for endpoint {endpoint_id}"}
                
            except Exception as e:
                logger.error(f"Restart endpoint error: {e}")
                raise HTTPException(status_code=500, detail=str(e))
        
        @self.app.get("/admin/logs/{lines}")
        async def get_recent_logs(lines: int = 100):
            """Get recent log entries"""
            try:
                if lines > 1000:
                    lines = 1000  # Limit to prevent abuse
                
                # Read recent log entries
                log_entries = await self._get_recent_logs(lines)
                
                return {
                    "lines": lines,
                    "entries": log_entries,
                    "timestamp": time.time()
                }
                
            except Exception as e:
                logger.error(f"Get logs error: {e}")
                raise HTTPException(status_code=500, detail=str(e))
    
    async def _check_database(self) -> Dict[str, Any]:
        """Check PostgreSQL database connectivity"""
        try:
            import asyncpg
            
            conn = await asyncpg.connect(
                host='postgres-primary',
                port=5432,
                database='bot_db',
                user='bot_user',
                password='postgres'  # Should come from env
            )
            
            # Test query
            result = await conn.fetchval('SELECT 1')
            await conn.close()
            
            if result == 1:
                return {"status": "healthy", "message": "Database connection OK"}
            else:
                return {"status": "unhealthy", "message": "Database query failed"}
                
        except Exception as e:
            return {"status": "unhealthy", "message": f"Database error: {e}"}
    
    async def _check_redis(self) -> Dict[str, Any]:
        """Check Redis connectivity"""
        try:
            import redis.asyncio as redis
            
            r = redis.Redis(host='redis', port=6379, decode_responses=True)
            await r.ping()
            await r.close()
            
            return {"status": "healthy", "message": "Redis connection OK"}
            
        except Exception as e:
            return {"status": "unhealthy", "message": f"Redis error: {e}"}
    
    async def _check_application(self) -> Dict[str, Any]:
        """Check application health"""
        try:
            if not self.integration_engine:
                return {"status": "unhealthy", "message": "Integration engine not initialized"}
            
            # Check if engine is running
            engine_status = self.integration_engine.get_system_status()
            
            if engine_status["active_pollers"] > 0:
                return {"status": "healthy", "message": "Application running normally"}
            else:
                return {"status": "warning", "message": "No active pollers"}
                
        except Exception as e:
            return {"status": "unhealthy", "message": f"Application error: {e}"}
    
    async def _check_endpoints(self) -> Dict[str, Any]:
        """Check endpoint health"""
        try:
            health_status = self.metrics_collector.get_health_status()
            
            return {
                "status": health_status["status"],
                "message": f"{health_status['healthy_endpoints']}/{health_status['total_endpoints']} endpoints healthy",
                "health_percentage": health_status["health_percentage"]
            }
            
        except Exception as e:
            return {"status": "unhealthy", "message": f"Endpoint check error: {e}"}
    
    async def _restart_endpoint(self, endpoint_id: str):
        """Restart specific endpoint (background task)"""
        try:
            if self.integration_engine:
                await self.integration_engine.restart_endpoint(endpoint_id)
                logger.info(f"Restarted endpoint: {endpoint_id}")
        except Exception as e:
            logger.error(f"Error restarting endpoint {endpoint_id}: {e}")
    
    async def _get_recent_logs(self, lines: int) -> list:
        """Get recent log entries"""
        try:
            import aiofiles
            
            log_entries = []
            
            async with aiofiles.open('logs/mcb_integration.log', 'r') as f:
                content = await f.read()
                log_lines = content.strip().split('\n')
                
                # Get last N lines
                recent_lines = log_lines[-lines:] if len(log_lines) > lines else log_lines
                
                for line in recent_lines:
                    if line.strip():
                        log_entries.append(line)
            
            return log_entries
            
        except Exception as e:
            logger.error(f"Error reading logs: {e}")
            return [f"Error reading logs: {e}"]
    
    def get_app(self) -> FastAPI:
        """Get FastAPI application"""
        return self.app
