#!/usr/bin/env python3
"""
Metrics Collector for MCB Data Integration
Prometheus metrics collection and health monitoring
"""

import time
import logging
from typing import Dict, Any, Optional
from prometheus_client import Counter, Histogram, Gauge, Info, start_http_server
from dataclasses import dataclass
from datetime import datetime

logger = logging.getLogger(__name__)

@dataclass
class EndpointMetrics:
    """Metrics for a specific endpoint"""
    records_processed: int = 0
    records_failed: int = 0
    last_success_timestamp: float = 0
    last_error_timestamp: float = 0
    connection_failures: int = 0
    processing_time_total: float = 0
    last_processing_time: float = 0

class MCBMetricsCollector:
    """Prometheus metrics collector for MCB integration"""
    
    def __init__(self, port: int = 8000):
        self.port = port
        self.endpoint_metrics: Dict[str, EndpointMetrics] = {}
        
        # Initialize Prometheus metrics
        self._init_prometheus_metrics()
        
        # Start metrics server
        self._start_metrics_server()
    
    def _init_prometheus_metrics(self):
        """Initialize Prometheus metrics"""
        
        # Application info
        self.app_info = Info('mcb_integration_info', 'MCB Integration application info')
        self.app_info.info({
            'version': '1.0.0',
            'build_date': datetime.now().isoformat(),
            'environment': 'production'
        })
        
        # System metrics
        self.active_pollers = Gauge('mcb_active_pollers', 'Number of active endpoint pollers')
        self.total_endpoints = Gauge('mcb_total_endpoints', 'Total number of configured endpoints')
        
        # Processing metrics
        self.records_processed_total = Counter(
            'mcb_records_processed_total',
            'Total number of records processed',
            ['endpoint_id', 'table_name']
        )
        
        self.records_failed_total = Counter(
            'mcb_records_failed_total',
            'Total number of records that failed processing',
            ['endpoint_id', 'table_name', 'error_type']
        )
        
        self.processing_duration = Histogram(
            'mcb_processing_duration_seconds',
            'Time spent processing records',
            ['endpoint_id', 'table_name'],
            buckets=[0.1, 0.5, 1.0, 2.5, 5.0, 10.0, 30.0, 60.0, 120.0]
        )
        
        # Connection metrics
        self.connection_attempts_total = Counter(
            'mcb_connection_attempts_total',
            'Total number of connection attempts',
            ['endpoint_id', 'db_type']
        )
        
        self.connection_failures_total = Counter(
            'mcb_connection_failures_total',
            'Total number of connection failures',
            ['endpoint_id', 'db_type', 'error_type']
        )
        
        self.connection_duration = Histogram(
            'mcb_connection_duration_seconds',
            'Time spent establishing connections',
            ['endpoint_id', 'db_type'],
            buckets=[0.01, 0.05, 0.1, 0.5, 1.0, 2.0, 5.0]
        )
        
        # Data quality metrics
        self.validation_errors_total = Counter(
            'mcb_validation_errors_total',
            'Total number of data validation errors',
            ['endpoint_id', 'table_name', 'validation_type']
        )
        
        self.transformation_errors_total = Counter(
            'mcb_transformation_errors_total',
            'Total number of data transformation errors',
            ['endpoint_id', 'table_name', 'transformation_type']
        )
        
        # Endpoint status metrics
        self.endpoint_last_success_timestamp = Gauge(
            'mcb_endpoint_last_success_timestamp',
            'Timestamp of last successful poll for endpoint',
            ['endpoint_id']
        )
        
        self.endpoint_status = Gauge(
            'mcb_endpoint_status',
            'Current status of endpoint (1=healthy, 0=unhealthy)',
            ['endpoint_id']
        )
        
        # Queue metrics
        self.processing_queue_size = Gauge(
            'mcb_processing_queue_size',
            'Number of items in processing queue'
        )
        
        # BOT submission metrics
        self.bot_submissions_total = Counter(
            'mcb_bot_submissions_total',
            'Total number of BOT submissions',
            ['status']
        )
        
        self.bot_submission_duration = Histogram(
            'mcb_bot_submission_duration_seconds',
            'Time spent on BOT submissions',
            buckets=[1.0, 5.0, 10.0, 30.0, 60.0, 120.0, 300.0]
        )
        
        # Network metrics
        self.network_latency = Histogram(
            'mcb_network_latency_seconds',
            'Network latency to endpoints',
            ['endpoint_id'],
            buckets=[0.01, 0.05, 0.1, 0.5, 1.0, 2.0, 5.0, 10.0]
        )
        
        # Error metrics
        self.errors_total = Counter(
            'mcb_integration_errors_total',
            'Total number of integration errors',
            ['component', 'error_type']
        )
    
    def _start_metrics_server(self):
        """Start Prometheus metrics HTTP server"""
        try:
            start_http_server(self.port)
            logger.info(f"Metrics server started on port {self.port}")
        except Exception as e:
            logger.error(f"Failed to start metrics server: {e}")
    
    def record_processing_success(self, endpoint_id: str, table_name: str, 
                                record_count: int, duration: float):
        """Record successful processing metrics"""
        self.records_processed_total.labels(
            endpoint_id=endpoint_id, 
            table_name=table_name
        ).inc(record_count)
        
        self.processing_duration.labels(
            endpoint_id=endpoint_id,
            table_name=table_name
        ).observe(duration)
        
        self.endpoint_last_success_timestamp.labels(
            endpoint_id=endpoint_id
        ).set(time.time())
        
        self.endpoint_status.labels(endpoint_id=endpoint_id).set(1)
        
        # Update internal metrics
        if endpoint_id not in self.endpoint_metrics:
            self.endpoint_metrics[endpoint_id] = EndpointMetrics()
        
        metrics = self.endpoint_metrics[endpoint_id]
        metrics.records_processed += record_count
        metrics.last_success_timestamp = time.time()
        metrics.processing_time_total += duration
        metrics.last_processing_time = duration
    
    def record_processing_failure(self, endpoint_id: str, table_name: str,
                                error_type: str, record_count: int = 1):
        """Record processing failure metrics"""
        self.records_failed_total.labels(
            endpoint_id=endpoint_id,
            table_name=table_name,
            error_type=error_type
        ).inc(record_count)
        
        self.endpoint_status.labels(endpoint_id=endpoint_id).set(0)
        
        # Update internal metrics
        if endpoint_id not in self.endpoint_metrics:
            self.endpoint_metrics[endpoint_id] = EndpointMetrics()
        
        metrics = self.endpoint_metrics[endpoint_id]
        metrics.records_failed += record_count
        metrics.last_error_timestamp = time.time()
    
    def record_connection_attempt(self, endpoint_id: str, db_type: str, 
                                success: bool, duration: float, error_type: str = None):
        """Record connection attempt metrics"""
        self.connection_attempts_total.labels(
            endpoint_id=endpoint_id,
            db_type=db_type
        ).inc()
        
        self.connection_duration.labels(
            endpoint_id=endpoint_id,
            db_type=db_type
        ).observe(duration)
        
        if not success:
            self.connection_failures_total.labels(
                endpoint_id=endpoint_id,
                db_type=db_type,
                error_type=error_type or 'unknown'
            ).inc()
            
            # Update internal metrics
            if endpoint_id not in self.endpoint_metrics:
                self.endpoint_metrics[endpoint_id] = EndpointMetrics()
            
            self.endpoint_metrics[endpoint_id].connection_failures += 1
    
    def record_validation_error(self, endpoint_id: str, table_name: str, 
                              validation_type: str):
        """Record data validation error"""
        self.validation_errors_total.labels(
            endpoint_id=endpoint_id,
            table_name=table_name,
            validation_type=validation_type
        ).inc()
    
    def record_transformation_error(self, endpoint_id: str, table_name: str,
                                  transformation_type: str):
        """Record data transformation error"""
        self.transformation_errors_total.labels(
            endpoint_id=endpoint_id,
            table_name=table_name,
            transformation_type=transformation_type
        ).inc()
    
    def record_bot_submission(self, success: bool, duration: float):
        """Record BOT submission metrics"""
        status = 'success' if success else 'failure'
        self.bot_submissions_total.labels(status=status).inc()
        self.bot_submission_duration.observe(duration)
    
    def record_network_latency(self, endpoint_id: str, latency: float):
        """Record network latency"""
        self.network_latency.labels(endpoint_id=endpoint_id).observe(latency)
    
    def record_error(self, component: str, error_type: str):
        """Record general error"""
        self.errors_total.labels(
            component=component,
            error_type=error_type
        ).inc()
    
    def update_system_metrics(self, active_pollers: int, total_endpoints: int,
                            queue_size: int = 0):
        """Update system-level metrics"""
        self.active_pollers.set(active_pollers)
        self.total_endpoints.set(total_endpoints)
        self.processing_queue_size.set(queue_size)
    
    def get_endpoint_metrics(self, endpoint_id: str) -> Optional[EndpointMetrics]:
        """Get metrics for specific endpoint"""
        return self.endpoint_metrics.get(endpoint_id)
    
    def get_health_status(self) -> Dict[str, Any]:
        """Get overall health status"""
        now = time.time()
        healthy_endpoints = 0
        total_endpoints = len(self.endpoint_metrics)
        
        for endpoint_id, metrics in self.endpoint_metrics.items():
            # Consider endpoint healthy if last success was within 10 minutes
            if now - metrics.last_success_timestamp < 600:
                healthy_endpoints += 1
        
        health_percentage = (healthy_endpoints / total_endpoints * 100) if total_endpoints > 0 else 0
        
        return {
            'status': 'healthy' if health_percentage >= 80 else 'degraded' if health_percentage >= 50 else 'unhealthy',
            'healthy_endpoints': healthy_endpoints,
            'total_endpoints': total_endpoints,
            'health_percentage': health_percentage,
            'timestamp': now
        }
    
    def get_summary_metrics(self) -> Dict[str, Any]:
        """Get summary metrics for all endpoints"""
        total_processed = sum(m.records_processed for m in self.endpoint_metrics.values())
        total_failed = sum(m.records_failed for m in self.endpoint_metrics.values())
        total_connection_failures = sum(m.connection_failures for m in self.endpoint_metrics.values())
        
        return {
            'total_records_processed': total_processed,
            'total_records_failed': total_failed,
            'total_connection_failures': total_connection_failures,
            'success_rate': (total_processed / (total_processed + total_failed) * 100) if (total_processed + total_failed) > 0 else 0,
            'endpoints': {
                endpoint_id: {
                    'records_processed': metrics.records_processed,
                    'records_failed': metrics.records_failed,
                    'connection_failures': metrics.connection_failures,
                    'last_success': metrics.last_success_timestamp,
                    'last_processing_time': metrics.last_processing_time
                }
                for endpoint_id, metrics in self.endpoint_metrics.items()
            }
        }
