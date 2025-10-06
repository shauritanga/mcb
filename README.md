# MCB Real-Time Data Integration System

A production-ready, scalable real-time data integration system for Mauritius Commercial Bank (MCB) that extracts data from IBM DB2 core banking systems and replicates it to PostgreSQL for Bank of Tanzania (BOT) regulatory reporting.

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   IBM DB2       │    │  Data Integration │    │   PostgreSQL    │
│ Core Banking    │───▶│     Engine        │───▶│   BOT Database  │
│   Systems       │    │                  │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                              │
                              ▼
                       ┌──────────────────┐
                       │   Monitoring &   │
                       │   Health Checks  │
                       └──────────────────┘
```

## 🚀 Key Features

- **Real-time Data Streaming**: Timestamp-based incremental sync with 5-30 second polling intervals
- **Scalable Architecture**: Supports 90+ banking endpoints with async/concurrent processing
- **Production Ready**: Docker containerization with monitoring, health checks, and alerting
- **Data Transformation**: Comprehensive data validation, transformation, and error handling
- **High Availability**: PostgreSQL replication, Redis clustering, and automatic failover
- **Monitoring**: Prometheus metrics, Grafana dashboards, and comprehensive alerting

## 📋 System Requirements

### Minimum Requirements
- **CPU**: 4 cores
- **RAM**: 8 GB
- **Storage**: 100 GB SSD
- **Network**: 1 Gbps

### Recommended for 90+ Endpoints
- **CPU**: 8-16 cores
- **RAM**: 16-32 GB
- **Storage**: 500 GB SSD with high IOPS
- **Network**: 10 Gbps

## 🛠️ Installation & Setup

### 1. Prerequisites

```bash
# Install Docker and Docker Compose
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 2. Environment Configuration

```bash
# Copy environment template
cp .env.example .env

# Edit environment variables
nano .env
```

Required environment variables:
```bash
# PostgreSQL Configuration
PG_BOT_PASSWORD=your_secure_password
PG_REPLICATION_PASSWORD=your_replication_password

# Monitoring
GRAFANA_PASSWORD=your_grafana_password
RABBITMQ_PASSWORD=your_rabbitmq_password

# Optional: Cloud backup
AWS_ACCESS_KEY=your_aws_key
AWS_SECRET_KEY=your_aws_secret
```

### 3. Configuration Setup

```bash
# Generate additional endpoints (optional)
python scripts/generate_endpoints.py

# Validate configuration
python -c "from config.endpoint_manager import EndpointConfigManager; print('✓ Config valid' if EndpointConfigManager().load_configuration() else '✗ Config invalid')"
```

### 4. Production Deployment

```bash
# Build and start all services
docker-compose -f docker-compose.production.yml up -d

# Check service health
docker-compose -f docker-compose.production.yml ps

# View logs
docker-compose -f docker-compose.production.yml logs -f mcb-integration-app
```

## 📊 Monitoring & Health Checks

### Health Check Endpoints

- **Simple Health**: `http://localhost/health/simple`
- **Detailed Health**: `http://localhost/health`
- **System Status**: `http://localhost/status`
- **Endpoint Status**: `http://localhost/endpoints/{endpoint_id}/status`

### Monitoring Dashboards

- **Grafana**: `http://localhost:3000` (admin/your_grafana_password)
- **Prometheus**: `http://localhost:9090`
- **Kibana**: `http://localhost:5601`
- **RabbitMQ**: `http://localhost:15672`

### Key Metrics

- **Records Processing Rate**: Records processed per second by endpoint
- **Error Rates**: Failed records and connection failures
- **Processing Duration**: 95th percentile processing times
- **System Health**: Endpoint availability and connection status

## 🔧 Configuration

### Endpoint Configuration

Endpoints are configured in `config/endpoints.yaml`:

```yaml
endpoints:
  - id: "hq_dar_es_salaam"
    name: "MCB Headquarters - Dar es Salaam"
    db_type: "db2"
    connection:
      host: "db2-hq.mcb.co.tz"
      port: 50000
      database: "cbs_db"
      user: "db2inst1"
      password: "${DB2_HQ_PASSWORD}"
    tables:
      - "PERSONAL_DATA_INDIVIDUALS"
      - "ASSET_OWNED_OR_ACQUIRED"
    poll_interval: 15
    batch_size: 2000
    priority: "critical"
    enabled: true
```

### Supported Database Types

- **IBM DB2**: Primary core banking systems
- **PostgreSQL**: Mobile banking and digital systems
- **MySQL**: ATM networks and branch systems
- **Oracle**: Legacy core banking systems
- **REST API**: External system integrations

## 🧪 Testing

### Unit Tests

```bash
# Run all unit tests
python -m pytest tests/ -v

# Run specific test file
python -m pytest tests/test_data_integration_engine.py -v

# Run with coverage
python -m pytest tests/ --cov=. --cov-report=html
```

### Integration Tests

```bash
# Set up test database
export TEST_PG_HOST=localhost
export TEST_PG_DATABASE=test_bot_db

# Run integration tests
python -m pytest tests/test_integration.py -v -m integration
```

### Performance Tests

```bash
# Load test with 90+ endpoints
python tests/performance/load_test.py --endpoints=90 --duration=300
```

## 📈 Performance Tuning

### Database Optimization

```sql
-- PostgreSQL tuning for high-throughput writes
ALTER SYSTEM SET shared_buffers = '4GB';
ALTER SYSTEM SET effective_cache_size = '12GB';
ALTER SYSTEM SET maintenance_work_mem = '1GB';
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET wal_buffers = '64MB';
ALTER SYSTEM SET default_statistics_target = 100;
```

### Application Tuning

```python
# Adjust concurrency settings in main.py
MAX_CONCURRENT_ENDPOINTS = 30  # Adjust based on system capacity
WORKER_THREADS = 20           # Thread pool size
BATCH_SIZE = 1000            # Records per batch
POLL_INTERVAL = 30           # Seconds between polls
```

## 🔒 Security

### Database Security

- Use strong passwords for all database connections
- Enable SSL/TLS for database connections
- Implement row-level security (RLS) policies
- Regular security audits and updates

### Network Security

- Use VPN or private networks for database connections
- Implement firewall rules to restrict access
- Enable connection encryption
- Monitor for suspicious activity

### Data Privacy

- Anonymize sensitive fields in transformation rules
- Implement data retention policies
- Audit data access and modifications
- Comply with data protection regulations

## 🚨 Troubleshooting

### Common Issues

#### 1. DB2 Connection Failures

```bash
# Check DB2 connectivity
docker exec -it mcb-integration-app python -c "
import ibm_db
try:
    conn = ibm_db.connect('DATABASE=cbs_db;HOSTNAME=db2-host;PORT=50000;PROTOCOL=TCPIP;UID=user;PWD=pass;', '', '')
    print('✓ DB2 connection successful')
    ibm_db.close(conn)
except Exception as e:
    print(f'✗ DB2 connection failed: {e}')
"
```

#### 2. High Memory Usage

```bash
# Monitor memory usage
docker stats mcb-integration-app

# Adjust memory limits in docker-compose.production.yml
deploy:
  resources:
    limits:
      memory: 8G
```

#### 3. Processing Delays

```bash
# Check processing queue
curl http://localhost/metrics/summary | jq '.processing_queue_size'

# Increase concurrent pollers
# Edit main.py: MAX_CONCURRENT_ENDPOINTS = 50
```

### Log Analysis

```bash
# View application logs
docker logs mcb-integration-app -f

# Search for errors
docker logs mcb-integration-app 2>&1 | grep ERROR

# View specific endpoint logs
docker logs mcb-integration-app 2>&1 | grep "endpoint_id=hq_dar_es_salaam"
```

## 📚 API Documentation

### Health Check API

```bash
# Simple health check
curl http://localhost/health/simple

# Detailed health check
curl http://localhost/health

# System status
curl http://localhost/status

# Endpoint-specific status
curl http://localhost/endpoints/hq_dar_es_salaam/status
```

### Admin Operations

```bash
# Restart specific endpoint
curl -X POST http://localhost/admin/restart-endpoint/hq_dar_es_salaam

# Get recent logs
curl http://localhost/admin/logs/100
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:

- **Email**: support@mcb.co.tz
- **Documentation**: [Internal Wiki](https://wiki.mcb.co.tz/data-integration)
- **Issue Tracker**: [GitHub Issues](https://github.com/mcb/data-integration/issues)

## 🔄 Version History

- **v1.0.0** - Initial production release
- **v1.1.0** - Added support for 90+ endpoints
- **v1.2.0** - Enhanced monitoring and alerting
- **v1.3.0** - Performance optimizations and security improvements
