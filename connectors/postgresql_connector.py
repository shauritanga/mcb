#!/usr/bin/env python3
"""
PostgreSQL Connector for MCB Data Integration
Handles connections to PostgreSQL target database
"""

import asyncpg
import logging
import asyncio
import json
from typing import Dict, List, Any, Optional
from datetime import datetime

from core.data_integration_engine import DataLoader, DataRecord

logger = logging.getLogger(__name__)

class PostgreSQLLoader(DataLoader):
    """PostgreSQL data loader for BOT consolidated database"""
    
    def __init__(self, connection_params: Dict[str, Any]):
        self.connection_params = connection_params
        self.connection_pool = None
        self.table_schemas = self._get_table_schemas()
    
    async def initialize(self):
        """Initialize connection pool"""
        try:
            self.connection_pool = await asyncpg.create_pool(
                host=self.connection_params['host'],
                port=self.connection_params['port'],
                database=self.connection_params['database'],
                user=self.connection_params['user'],
                password=self.connection_params['password'],
                min_size=5,
                max_size=20,
                command_timeout=30
            )
            
            # Create tables if they don't exist
            await self._create_tables()
            
            logger.info("PostgreSQL connection pool initialized")
            
        except Exception as e:
            logger.error(f"Failed to initialize PostgreSQL connection pool: {e}")
            raise
    
    async def close(self):
        """Close connection pool"""
        if self.connection_pool:
            await self.connection_pool.close()
            logger.info("PostgreSQL connection pool closed")
    
    def _convert_ddmmyyyyhhmm_to_timestamp(self, date_str: Optional[str]) -> Optional[datetime]:
        """Convert DDMMYYYYHHMM format to datetime object"""
        if not date_str or len(date_str) != 12:
            return None
        try:
            # Parse DDMMYYYYHHMM format
            day = int(date_str[0:2])
            month = int(date_str[2:4])
            year = int(date_str[4:8])
            hour = int(date_str[8:10])
            minute = int(date_str[10:12])
            return datetime(year, month, day, hour, minute)
        except (ValueError, TypeError):
            return None
    
    def _get_table_schemas(self) -> Dict[str, str]:
        """Define table schemas for BOT reporting"""
        return {
            "bot_personal_data_individuals": """
                CREATE TABLE IF NOT EXISTS bot_personal_data_individuals (
                    id SERIAL PRIMARY KEY,
                    endpoint_id VARCHAR(100) NOT NULL,
                    reporting_date TIMESTAMP NOT NULL,
                    customer_identification_number VARCHAR(50),
                    first_name VARCHAR(100),
                    middle_names VARCHAR(100),
                    surname VARCHAR(100),
                    gender VARCHAR(50),
                    date_of_birth VARCHAR(12),
                    marital_status VARCHAR(50),
                    number_of_dependants INTEGER,
                    disability_status VARCHAR(50),
                    disability_type VARCHAR(50),
                    citizenship VARCHAR(50),
                    nationality VARCHAR(50),
                    residence VARCHAR(50),
                    residence_status VARCHAR(50),
                    employment_status VARCHAR(50),
                    occupation VARCHAR(50),
                    employer_name VARCHAR(100),
                    employer_address VARCHAR(200),
                    sector_employer VARCHAR(50),
                    income_range VARCHAR(50),
                    education_level VARCHAR(50),
                    identification_type VARCHAR(50),
                    identification_number VARCHAR(50),
                    issuing_country VARCHAR(50),
                    issuing_authority VARCHAR(100),
                    issue_date VARCHAR(12),
                    expiry_date VARCHAR(12),
                    mobile_number VARCHAR(50),
                    alt_mobile_number VARCHAR(50),
                    email_address VARCHAR(100),
                    alt_email_address VARCHAR(100),
                    postal_address VARCHAR(200),
                    physical_address VARCHAR(200),
                    region VARCHAR(50),
                    district VARCHAR(50),
                    ward VARCHAR(50),
                    street VARCHAR(100),
                    house_number VARCHAR(50),
                    postal_code VARCHAR(50),
                    country VARCHAR(50),
                    gps_coordinates VARCHAR(50),
                    next_of_kin_name VARCHAR(100),
                    next_of_kin_relationship VARCHAR(50),
                    next_of_kin_mobile_number VARCHAR(50),
                    next_of_kin_email_address VARCHAR(100),
                    next_of_kin_address VARCHAR(200),
                    next_of_kin_region VARCHAR(50),
                    next_of_kin_district VARCHAR(50),
                    next_of_kin_ward VARCHAR(50),
                    next_of_kin_street VARCHAR(100),
                    next_of_kin_house_number VARCHAR(50),
                    next_of_kin_postal_code VARCHAR(50),
                    next_of_kin_country VARCHAR(50),
                    next_of_kin_gps_coordinates VARCHAR(50),
                    kyc_status VARCHAR(50),
                    kyc_date VARCHAR(12),
                    kyc_expiry_date VARCHAR(12),
                    risk_rating VARCHAR(50),
                    risk_rating_date VARCHAR(12),
                    pep_status VARCHAR(50),
                    pep_classification VARCHAR(50),
                    pep_position VARCHAR(100),
                    pep_country VARCHAR(50),
                    pep_relationship VARCHAR(50),
                    sanctions_status BOOLEAN,
                    sanctions_list VARCHAR(100),
                    sanctions_date VARCHAR(12),
                    sanctions_country VARCHAR(50),
                    village VARCHAR(50),
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    source_timestamp VARCHAR(12),
                    UNIQUE(endpoint_id, customer_identification_number, reporting_date)
                );
                
                CREATE INDEX IF NOT EXISTS idx_personal_data_reporting_date 
                ON bot_personal_data_individuals(reporting_date);
                
                CREATE INDEX IF NOT EXISTS idx_personal_data_endpoint 
                ON bot_personal_data_individuals(endpoint_id);
            """,
            
            "bot_asset_owned_or_acquired": """
                CREATE TABLE IF NOT EXISTS bot_asset_owned_or_acquired (
                    id SERIAL PRIMARY KEY,
                    endpoint_id VARCHAR(100) NOT NULL,
                    reporting_date TIMESTAMP NOT NULL,
                    asset_category VARCHAR(10),
                    asset_type VARCHAR(50),
                    acquisition_date TIMESTAMP,
                    currency VARCHAR(50),
                    org_cost_value DECIMAL(15,2),
                    usd_cost_value DECIMAL(15,2),
                    tzs_cost_value DECIMAL(15,2),
                    allowance_probable_loss DECIMAL(15,2),
                    bot_provision DECIMAL(15,2),
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    source_timestamp VARCHAR(12),
                    UNIQUE(endpoint_id, asset_category, reporting_date)
                );
                
                CREATE INDEX IF NOT EXISTS idx_asset_reporting_date 
                ON bot_asset_owned_or_acquired(reporting_date);
                
                CREATE INDEX IF NOT EXISTS idx_asset_endpoint 
                ON bot_asset_owned_or_acquired(endpoint_id);
            """,
            
            "bot_polling_timestamps": """
                CREATE TABLE IF NOT EXISTS bot_polling_timestamps (
                    endpoint_id VARCHAR(100) NOT NULL,
                    table_name VARCHAR(100) NOT NULL,
                    last_timestamp VARCHAR(12) NOT NULL,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    PRIMARY KEY(endpoint_id, table_name)
                );
            """,
            
            "bot_processing_log": """
                CREATE TABLE IF NOT EXISTS bot_processing_log (
                    id SERIAL PRIMARY KEY,
                    endpoint_id VARCHAR(100) NOT NULL,
                    table_name VARCHAR(100) NOT NULL,
                    records_processed INTEGER DEFAULT 0,
                    records_failed INTEGER DEFAULT 0,
                    processing_time_ms INTEGER DEFAULT 0,
                    error_message TEXT,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
                
                CREATE INDEX IF NOT EXISTS idx_processing_log_endpoint 
                ON bot_processing_log(endpoint_id, created_at);
            """
        }
    
    async def _create_tables(self):
        """Create all required tables"""
        async with self.connection_pool.acquire() as conn:
            for table_name, schema_sql in self.table_schemas.items():
                try:
                    await conn.execute(schema_sql)
                    logger.info(f"Created/verified table: {table_name}")
                except Exception as e:
                    logger.error(f"Error creating table {table_name}: {e}")
                    raise
    
    async def load(self, records: List[DataRecord]) -> bool:
        """Load data records to PostgreSQL"""
        if not records:
            return True
        
        try:
            async with self.connection_pool.acquire() as conn:
                async with conn.transaction():
                    success_count = 0
                    
                    for record in records:
                        try:
                            if record.table_name == "PERSONAL_DATA_INDIVIDUALS":
                                await self._insert_personal_data(conn, record)
                            elif record.table_name == "ASSET_OWNED_OR_ACQUIRED":
                                await self._insert_asset_data(conn, record)
                            else:
                                logger.warning(f"Unknown table: {record.table_name}")
                                continue
                            
                            success_count += 1
                            
                        except Exception as e:
                            logger.error(f"Error inserting record {record.record_id}: {e}")
                            # Continue with other records
                    
                    # Log processing results
                    await self._log_processing(
                        conn, 
                        records[0].endpoint_id, 
                        records[0].table_name,
                        success_count,
                        len(records) - success_count
                    )
                    
                    logger.info(f"Successfully loaded {success_count}/{len(records)} records")
                    return success_count > 0
                    
        except Exception as e:
            logger.error(f"Error loading records to PostgreSQL: {e}")
            return False
    
    async def _insert_personal_data(self, conn, record: DataRecord):
        """Insert personal data record"""
        data = record.data
        
        # Convert reportingDate from DDMMYYYYHHMM to TIMESTAMP
        reporting_date = self._convert_ddmmyyyyhhmm_to_timestamp(data.get('reportingDate', ''))
        
        query = """
            INSERT INTO bot_personal_data_individuals (
                endpoint_id, reporting_date, customer_identification_number, first_name,
                middle_names, surname, gender, date_of_birth, marital_status,
                number_of_dependants, disability_status, disability_type, citizenship,
                nationality, residence, residence_status, employment_status, occupation,
                employer_name, employer_address, sector_employer, income_range,
                education_level, identification_type, identification_number,
                issuing_country, issuing_authority, issue_date, expiry_date,
                mobile_number, alt_mobile_number, email_address, alt_email_address,
                postal_address, physical_address, region, district, ward, street,
                house_number, postal_code, country, gps_coordinates, next_of_kin_name,
                next_of_kin_relationship, next_of_kin_mobile_number, next_of_kin_email_address,
                next_of_kin_address, next_of_kin_region, next_of_kin_district,
                next_of_kin_ward, next_of_kin_street, next_of_kin_house_number,
                next_of_kin_postal_code, next_of_kin_country, next_of_kin_gps_coordinates,
                kyc_status, kyc_date, kyc_expiry_date, risk_rating, risk_rating_date,
                pep_status, pep_classification, pep_position, pep_country,
                pep_relationship, sanctions_status, sanctions_list, sanctions_date,
                sanctions_country, village, source_timestamp
            ) VALUES (
                $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,
                $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30,
                $31, $32, $33, $34, $35, $36, $37, $38, $39, $40, $41, $42, $43, $44,
                $45, $46, $47, $48, $49, $50, $51, $52, $53, $54, $55, $56, $57, $58,
                $59, $60, $61, $62, $63, $64, $65, $66, $67, $68, $69
            )
            ON CONFLICT (endpoint_id, customer_identification_number, reporting_date)
            DO UPDATE SET
                updated_at = CURRENT_TIMESTAMP,
                first_name = EXCLUDED.first_name,
                middle_names = EXCLUDED.middle_names,
                surname = EXCLUDED.surname
        """
        
        await conn.execute(query,
            record.endpoint_id, reporting_date, data.get('customerIdentificationNumber'),
            data.get('firstName'), data.get('middleNames'), data.get('surname'),
            data.get('gender'), data.get('dateOfBirth'), data.get('maritalStatus'),
            data.get('numberOfDependants'), data.get('disabilityStatus'), data.get('disabilityType'),
            data.get('citizenship'), data.get('nationality'), data.get('residence'),
            data.get('residenceStatus'), data.get('employmentStatus'), data.get('occupation'),
            data.get('employerName'), data.get('employerAddress'), data.get('sectorEmployer'),
            data.get('incomeRange'), data.get('educationLevel'), data.get('identificationType'),
            data.get('identificationNumber'), data.get('issuingCountry'), data.get('issuingAuthority'),
            data.get('issueDate'), data.get('expiryDate'), data.get('mobileNumber'),
            data.get('altMobileNumber'), data.get('emailAddress'), data.get('altEmailAddress'),
            data.get('postalAddress'), data.get('physicalAddress'), data.get('region'),
            data.get('district'), data.get('ward'), data.get('street'), data.get('houseNumber'),
            data.get('postalCode'), data.get('country'), data.get('gpsCoordinates'),
            data.get('nextOfKinName'), data.get('nextOfKinRelationship'), data.get('nextOfKinMobileNumber'),
            data.get('nextOfKinEmailAddress'), data.get('nextOfKinAddress'), data.get('nextOfKinRegion'),
            data.get('nextOfKinDistrict'), data.get('nextOfKinWard'), data.get('nextOfKinStreet'),
            data.get('nextOfKinHouseNumber'), data.get('nextOfKinPostalCode'), data.get('nextOfKinCountry'),
            data.get('nextOfKinGpsCoordinates'), data.get('kycStatus'), data.get('kycDate'),
            data.get('kycExpiryDate'), data.get('riskRating'), data.get('riskRatingDate'),
            data.get('pepStatus'), data.get('pepClassification'), data.get('pepPosition'),
            data.get('pepCountry'), data.get('pepRelationship'), data.get('sanctionsStatus'),
            data.get('sanctionsList'), data.get('sanctionsDate'), data.get('sanctionsCountry'),
            data.get('village'), record.source_timestamp
        )
    
    async def _insert_asset_data(self, conn, record: DataRecord):
        """Insert asset data record"""
        data = record.data
        
        # Convert reportingDate and acquisitionDate from DDMMYYYYHHMM to TIMESTAMP
        reporting_date = self._convert_ddmmyyyyhhmm_to_timestamp(data.get('reportingDate', ''))
        acquisition_date = self._convert_ddmmyyyyhhmm_to_timestamp(data.get('acquisitionDate', ''))
        
        query = """
            INSERT INTO bot_asset_owned_or_acquired (
                endpoint_id, reporting_date, asset_category, asset_type, acquisition_date,
                currency, org_cost_value, usd_cost_value, tzs_cost_value, allowance_probable_loss,
                bot_provision, source_timestamp
            ) VALUES (
                $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12
            )
            ON CONFLICT (endpoint_id, asset_category, reporting_date)
            DO UPDATE SET
                updated_at = CURRENT_TIMESTAMP,
                org_cost_value = EXCLUDED.org_cost_value
        """
        
        await conn.execute(query,
            record.endpoint_id, reporting_date, data.get('assetCategory'),
            data.get('assetType'), acquisition_date, data.get('currency'),
            data.get('orgCostValue'), data.get('usdCostValue'), data.get('tzsCostValue'),
            data.get('allowanceProbableLoss'), data.get('botProvision'),
            record.source_timestamp
        )
    
    async def _log_processing(self, conn, endpoint_id: str, table_name: str, 
                            success_count: int, failed_count: int):
        """Log processing results"""
        query = """
            INSERT INTO bot_processing_log (
                endpoint_id, table_name, records_processed, records_failed
            ) VALUES ($1, $2, $3, $4)
        """
        
        await conn.execute(query, endpoint_id, table_name, success_count, failed_count)
    
    async def get_last_timestamp(self, endpoint_id: str, table: str) -> str:
        """Get last processed timestamp for incremental loading"""
        try:
            async with self.connection_pool.acquire() as conn:
                query = """
                    SELECT last_timestamp FROM bot_polling_timestamps
                    WHERE endpoint_id = $1 AND table_name = $2
                """
                
                result = await conn.fetchval(query, endpoint_id, table)
                return result if result else "000000000000"
                
        except Exception as e:
            logger.error(f"Error getting last timestamp for {endpoint_id}.{table}: {e}")
            return "000000000000"
    
    async def update_timestamp(self, endpoint_id: str, table: str, timestamp: str):
        """Update last processed timestamp"""
        try:
            async with self.connection_pool.acquire() as conn:
                query = """
                    INSERT INTO bot_polling_timestamps (endpoint_id, table_name, last_timestamp)
                    VALUES ($1, $2, $3)
                    ON CONFLICT (endpoint_id, table_name)
                    DO UPDATE SET
                        last_timestamp = EXCLUDED.last_timestamp,
                        updated_at = CURRENT_TIMESTAMP
                """
                
                await conn.execute(query, endpoint_id, table, timestamp)
                logger.debug(f"Updated timestamp for {endpoint_id}.{table}: {timestamp}")
                
        except Exception as e:
            logger.error(f"Error updating timestamp for {endpoint_id}.{table}: {e}")
