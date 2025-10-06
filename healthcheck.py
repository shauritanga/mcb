#!/usr/bin/env python3
"""
Health check script for MCB Data Integration System
"""

import sys
import asyncio
import asyncpg
import redis
import json
import time
from pathlib import Path

async def check_postgresql():
    """Check PostgreSQL connection"""
    try:
        conn = await asyncpg.connect(
            host='postgres-primary',
            port=5432,
            database='bot_db',
            user='bot_user',
            password='postgres'  # This should come from env
        )
        await conn.execute('SELECT 1')
        await conn.close()
        return True, "PostgreSQL OK"
    except Exception as e:
        return False, f"PostgreSQL Error: {e}"

def check_redis():
    """Check Redis connection"""
    try:
        r = redis.Redis(host='redis', port=6379, decode_responses=True)
        r.ping()
        return True, "Redis OK"
    except Exception as e:
        return False, f"Redis Error: {e}"

def check_application_status():
    """Check application-specific status"""
    try:
        # Check if log file exists and is being written to
        log_file = Path('logs/mcb_integration.log')
        if log_file.exists():
            # Check if log file was modified in the last 5 minutes
            last_modified = log_file.stat().st_mtime
            if time.time() - last_modified < 300:  # 5 minutes
                return True, "Application logging active"
            else:
                return False, "Application logging stale"
        else:
            return False, "Log file not found"
    except Exception as e:
        return False, f"Application check error: {e}"

async def main():
    """Main health check function"""
    checks = []
    
    # Check PostgreSQL
    pg_ok, pg_msg = await check_postgresql()
    checks.append(("PostgreSQL", pg_ok, pg_msg))
    
    # Check Redis
    redis_ok, redis_msg = check_redis()
    checks.append(("Redis", redis_ok, redis_msg))
    
    # Check Application
    app_ok, app_msg = check_application_status()
    checks.append(("Application", app_ok, app_msg))
    
    # Determine overall health
    all_ok = all(check[1] for check in checks)
    
    # Print results
    health_status = {
        "status": "healthy" if all_ok else "unhealthy",
        "timestamp": time.time(),
        "checks": {
            check[0]: {"status": "ok" if check[1] else "error", "message": check[2]}
            for check in checks
        }
    }
    
    print(json.dumps(health_status, indent=2))
    
    # Exit with appropriate code
    sys.exit(0 if all_ok else 1)

if __name__ == "__main__":
    asyncio.run(main())
