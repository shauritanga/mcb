#!/usr/bin/env python3
"""
IBM DB2 Connector for MCB Data Integration
Handles connections to DB2 core banking systems
"""

import ibm_db
import logging
import asyncio
import time
from typing import Dict, List, Any, Optional
from contextlib import asynccontextmanager

from core.data_integration_engine import DataSourceConnector, EndpointConfig

logger = logging.getLogger(__name__)

class DB2Connector(DataSourceConnector):
    """Connector for IBM DB2 databases"""
    
    def __init__(self, config: EndpointConfig):
        super().__init__(config)
        self.connection_string = None
        self._prepare_connection_string()
    
    def _prepare_connection_string(self):
        """Prepare DB2 connection string"""
        params = self.config.connection_params
        self.connection_string = (
            f"DATABASE={params['database']};"
            f"HOSTNAME={params['host']};"
            f"PORT={params['port']};"
            f"PROTOCOL=TCPIP;"
            f"UID={params['user']};"
            f"PWD={params['password']};"
        )
    
    async def connect(self) -> bool:
        """Establish connection to DB2"""
        try:
            # Run in thread pool since ibm_db is synchronous
            loop = asyncio.get_event_loop()
            self.connection = await loop.run_in_executor(
                None, 
                lambda: ibm_db.connect(self.connection_string, "", "")
            )
            
            if self.connection:
                self.is_connected = True
                logger.info(f"Connected to DB2 endpoint: {self.config.endpoint_id}")
                return True
            else:
                logger.error(f"Failed to connect to DB2 endpoint: {self.config.endpoint_id}")
                return False
                
        except Exception as e:
            logger.error(f"DB2 connection error for {self.config.endpoint_id}: {e}")
            self.is_connected = False
            return False
    
    async def disconnect(self):
        """Close DB2 connection"""
        try:
            if self.connection and self.is_connected:
                loop = asyncio.get_event_loop()
                await loop.run_in_executor(
                    None,
                    lambda: ibm_db.close(self.connection)
                )
                self.is_connected = False
                logger.info(f"Disconnected from DB2 endpoint: {self.config.endpoint_id}")
        except Exception as e:
            logger.error(f"Error disconnecting from DB2 {self.config.endpoint_id}: {e}")
    
    async def test_connection(self) -> bool:
        """Test if DB2 connection is healthy"""
        try:
            if not self.is_connected or not self.connection:
                return False
            
            # Simple test query
            loop = asyncio.get_event_loop()
            result = await loop.run_in_executor(
                None,
                lambda: ibm_db.exec_immediate(self.connection, "SELECT 1 FROM SYSIBM.SYSDUMMY1")
            )
            
            return result is not False
            
        except Exception as e:
            logger.error(f"DB2 connection test failed for {self.config.endpoint_id}: {e}")
            return False
    
    async def fetch_data(self, table: str, last_timestamp: str) -> List[Dict[str, Any]]:
        """Fetch data from DB2 table since last timestamp"""
        try:
            if not self.is_connected:
                await self.connect()
            
            # Prepare query based on table
            query = self._build_query(table, last_timestamp)
            
            # Execute query in thread pool
            loop = asyncio.get_event_loop()
            stmt = await loop.run_in_executor(
                None,
                lambda: ibm_db.prepare(self.connection, query)
            )
            
            if not stmt:
                logger.error(f"Failed to prepare query for {table}")
                return []
            
            # Bind parameters
            await loop.run_in_executor(
                None,
                lambda: ibm_db.bind_param(stmt, 1, last_timestamp)
            )
            
            # Execute query
            success = await loop.run_in_executor(
                None,
                lambda: ibm_db.execute(stmt)
            )
            
            if not success:
                logger.error(f"Failed to execute query for {table}")
                return []
            
            # Fetch results
            records = []
            while await loop.run_in_executor(None, lambda: ibm_db.fetch_row(stmt)):
                record = await self._fetch_record(stmt, table)
                if record:
                    records.append(record)
            
            logger.info(f"Fetched {len(records)} records from {table} for endpoint {self.config.endpoint_id}")
            return records
            
        except Exception as e:
            logger.error(f"Error fetching data from {table} for {self.config.endpoint_id}: {e}")
            return []
    
    def _build_query(self, table: str, last_timestamp: str) -> str:
        """Build SQL query for specific table"""
        schema = "CBS_SCHEMA"
        
        if table == "PERSONAL_DATA_INDIVIDUALS":
            return f"""
                SELECT 
                    REPORTINGDATE, CUSTOMERIDENTIFICATIONNUMBER, FIRSTNAME, MIDDLENAMES, SURNAME,
                    GENDER, DATEOFBIRTH, MARITALSTATUS, NUMBEROFDEPENDANTS, DISABILITYSTATUS,
                    DISABILITYTYPE, CITIZENSHIP, NATIONALITY, RESIDENCE, RESIDENCESTATUS,
                    EMPLOYMENTSTATUS, OCCUPATION, EMPLOYERNAME, EMPLOYERADDRESS, SECTOREMPLOYER,
                    INCOMERANGE, EDUCATIONLEVEL, IDENTIFICATIONTYPE, IDENTIFICATIONNUMBER,
                    ISSUINGCOUNTRY, ISSUINGAUTHORITY, ISSUEDATE, EXPIRYDATE, MOBILENUMBER,
                    ALTMOBILENUMBER, EMAILADDRESS, ALTEMAILADDRESS, POSTALADDRESS,
                    PHYSICALADDRESS, REGION, DISTRICT, WARD, STREET, HOUSENUMBER,
                    POSTALCODE, COUNTRY, GPSCOORDINATES, NEXTOFKINNAME, NEXTOFKINRELATIONSHIP,
                    NEXTOFKINMOBILENUMBER, NEXTOFKINEMAILADDRESS, NEXTOFKINADDRESS,
                    NEXTOFKINREGION, NEXTOFKINDISTRICT, NEXTOFKINWARD, NEXTOFKINSTREET,
                    NEXTOFKINHOUSENUMBER, NEXTOFKINPOSTALCODE, NEXTOFKINCOUNTRY,
                    NEXTOFKINGPSCOORDINATES, KYCSTATUS, KYCDATE, KYCEXPIRYDATE,
                    RISKRATING, RISKRATINGDATE, PEPSTATUS, PEPCLASSIFICATION,
                    PEPPOSITION, PEPCOUNTRY, PEPRELATIONSHIP, SANCTIONSSTATUS,
                    SANCTIONSLIST, SANCTIONSDATE, SANCTIONSCOUNTRY, VILLAGE
                FROM {schema}.{table}
                WHERE REPORTINGDATE > ?
                ORDER BY REPORTINGDATE
                FETCH FIRST {self.config.batch_size} ROWS ONLY
            """
        
        elif table == "ASSET_OWNED_OR_ACQUIRED":
            return f"""
                SELECT 
                    REPORTINGDATE, ASSETCATEGORY, ASSETTYPE, ACQUISITIONDATE,
                    CURRENCY, ORGCOSTVALUE, USDCOSTVALUE, TZSCOSTVALUE,
                    ALLOWANCEPROBABLELOSS, BOTPROVISION
                FROM {schema}.{table}
                WHERE REPORTINGDATE > ?
                ORDER BY REPORTINGDATE
                FETCH FIRST {self.config.batch_size} ROWS ONLY
            """
        
        else:
            # Generic query for other tables
            return f"""
                SELECT * FROM {schema}.{table}
                WHERE REPORTINGDATE > ?
                ORDER BY REPORTINGDATE
                FETCH FIRST {self.config.batch_size} ROWS ONLY
            """
    
    async def _fetch_record(self, stmt, table: str) -> Optional[Dict[str, Any]]:
        """Fetch a single record from result set"""
        try:
            loop = asyncio.get_event_loop()
            
            if table == "PERSONAL_DATA_INDIVIDUALS":
                record = {
                    "reportingDate": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "REPORTINGDATE")),
                    "customerIdentificationNumber": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "CUSTOMERIDENTIFICATIONNUMBER")),
                    "firstName": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "FIRSTNAME")),
                    "middleNames": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "MIDDLENAMES")),
                    "surname": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "SURNAME")),
                    "gender": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "GENDER")),
                    "dateOfBirth": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "DATEOFBIRTH")),
                    "maritalStatus": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "MARITALSTATUS")),
                    "numberOfDependants": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "NUMBEROFDEPENDANTS")),
                    "disabilityStatus": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "DISABILITYSTATUS")),
                    "disabilityType": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "DISABILITYTYPE")),
                    "citizenship": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "CITIZENSHIP")),
                    "nationality": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "NATIONALITY")),
                    "residence": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "RESIDENCE")),
                    "residenceStatus": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "RESIDENCESTATUS")),
                    "employmentStatus": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "EMPLOYMENTSTATUS")),
                    "occupation": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "OCCUPATION")),
                    "employerName": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "EMPLOYERNAME")),
                    "employerAddress": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "EMPLOYERADDRESS")),
                    "sectorEmployer": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "SECTOREMPLOYER")),
                    "incomeRange": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "INCOMERANGE")),
                    "educationLevel": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "EDUCATIONLEVEL")),
                    "identificationType": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "IDENTIFICATIONTYPE")),
                    "identificationNumber": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "IDENTIFICATIONNUMBER")),
                    "issuingCountry": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "ISSUINGCOUNTRY")),
                    "issuingAuthority": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "ISSUINGAUTHORITY")),
                    "issueDate": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "ISSUEDATE")),
                    "expiryDate": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "EXPIRYDATE")),
                    "mobileNumber": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "MOBILENUMBER")),
                    "altMobileNumber": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "ALTMOBILENUMBER")),
                    "emailAddress": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "EMAILADDRESS")),
                    "altEmailAddress": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "ALTEMAILADDRESS")),
                    "postalAddress": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "POSTALADDRESS")),
                    "physicalAddress": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "PHYSICALADDRESS")),
                    "region": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "REGION")),
                    "district": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "DISTRICT")),
                    "ward": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "WARD")),
                    "street": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "STREET")),
                    "houseNumber": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "HOUSENUMBER")),
                    "postalCode": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "POSTALCODE")),
                    "country": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "COUNTRY")),
                    "gpsCoordinates": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "GPSCOORDINATES")),
                    "nextOfKinName": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "NEXTOFKINNAME")),
                    "nextOfKinRelationship": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "NEXTOFKINRELATIONSHIP")),
                    "nextOfKinMobileNumber": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "NEXTOFKINMOBILENUMBER")),
                    "nextOfKinEmailAddress": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "NEXTOFKINEMAILADDRESS")),
                    "nextOfKinAddress": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "NEXTOFKINADDRESS")),
                    "nextOfKinRegion": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "NEXTOFKINREGION")),
                    "nextOfKinDistrict": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "NEXTOFKINDISTRICT")),
                    "nextOfKinWard": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "NEXTOFKINWARD")),
                    "nextOfKinStreet": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "NEXTOFKINSTREET")),
                    "nextOfKinHouseNumber": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "NEXTOFKINHOUSENUMBER")),
                    "nextOfKinPostalCode": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "NEXTOFKINPOSTALCODE")),
                    "nextOfKinCountry": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "NEXTOFKINCOUNTRY")),
                    "nextOfKinGpsCoordinates": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "NEXTOFKINGPSCOORDINATES")),
                    "kycStatus": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "KYCSTATUS")),
                    "kycDate": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "KYCDATE")),
                    "kycExpiryDate": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "KYCEXPIRYDATE")),
                    "riskRating": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "RISKRATING")),
                    "riskRatingDate": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "RISKRATINGDATE")),
                    "pepStatus": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "PEPSTATUS")),
                    "pepClassification": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "PEPCLASSIFICATION")),
                    "pepPosition": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "PEPPOSITION")),
                    "pepCountry": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "PEPCOUNTRY")),
                    "pepRelationship": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "PEPRELATIONSHIP")),
                    "sanctionsStatus": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "SANCTIONSSTATUS")),
                    "sanctionsList": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "SANCTIONSLIST")),
                    "sanctionsDate": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "SANCTIONSDATE")),
                    "sanctionsCountry": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "SANCTIONSCOUNTRY")),
                    "village": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "VILLAGE"))
                }
            
            elif table == "ASSET_OWNED_OR_ACQUIRED":
                record = {
                    "reportingDate": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "REPORTINGDATE")),
                    "assetCategory": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "ASSETCATEGORY")),
                    "assetType": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "ASSETTYPE")),
                    "acquisitionDate": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "ACQUISITIONDATE")),
                    "currency": await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "CURRENCY")),
                    "orgCostValue": self._safe_float(await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "ORGCOSTVALUE"))),
                    "usdCostValue": self._safe_float(await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "USDCOSTVALUE"))),
                    "tzsCostValue": self._safe_float(await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "TZSCOSTVALUE"))),
                    "allowanceProbableLoss": self._safe_float(await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "ALLOWANCEPROBABLELOSS"))),
                    "botProvision": self._safe_float(await loop.run_in_executor(None, lambda: ibm_db.result(stmt, "BOTPROVISION")))
                }
            
            else:
                # Generic record fetching for other tables
                record = {}
                # This would need to be implemented based on table structure
            
            return record
            
        except Exception as e:
            logger.error(f"Error fetching record from {table}: {e}")
            return None
    
    def _safe_float(self, value) -> float:
        """Safely convert value to float"""
        if value is None:
            return 0.0
        try:
            return float(value)
        except (ValueError, TypeError):
            return 0.0
    
    def _safe_int(self, value) -> int:
        """Safely convert value to int"""
        if value is None:
            return 0
        try:
            return int(value)
        except (ValueError, TypeError):
            return 0
