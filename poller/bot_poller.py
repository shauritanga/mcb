import ibm_db
import psycopg2
import json
import time
import os
import logging
from datetime import datetime
import sys
from typing import Optional, Dict, Any, List


# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler('poller.log')
    ]
)
logger = logging.getLogger('bot_poller')


# Connection retry function
def connect_with_retry(connection_func, max_retries=10, initial_delay=5):
    """Retry connection with exponential backoff"""
    for attempt in range(max_retries):
        try:
            return connection_func()
        except Exception as e:
            if attempt == max_retries - 1:
                logger.error(f"Failed to connect after {max_retries} attempts: {e}")
                sys.exit(1)

            delay = initial_delay * (2**attempt)
            logger.warning(f"Connection attempt {attempt + 1} failed: {e}")
            logger.info(f"Retrying in {delay} seconds...")
            time.sleep(delay)


# DB2 connection with retry
def connect_db2():
    DB2_CONN_STR = f"DATABASE={os.getenv('DB2_DBNAME')};HOSTNAME={os.getenv('DB2_HOST')};PORT={os.getenv('DB2_PORT')};PROTOCOL=TCPIP;UID={os.getenv('DB2_USER')};PWD={os.getenv('DB2_PASSWORD')};"
    logger.info(f"Connecting to DB2 at {os.getenv('DB2_HOST')}:{os.getenv('DB2_PORT')}")
    return ibm_db.connect(DB2_CONN_STR, "", "")


# PostgreSQL connection with retry
def connect_postgres():
    logger.info(f"Connecting to PostgreSQL at {os.getenv('PG_HOST')}:{os.getenv('PG_PORT')}")
    conn = psycopg2.connect(
        dbname=os.getenv("PG_DBNAME"),
        user=os.getenv("PG_USER"),
        password=os.getenv("PG_PASSWORD"),
        host=os.getenv("PG_HOST"),
        port=os.getenv("PG_PORT"),
    )
    return conn


print("Connecting to databases...")
db2_conn = connect_with_retry(connect_db2)
print("DB2 connection established!")

pg_conn = connect_with_retry(connect_postgres)
if pg_conn is None:
    logger.error("Failed to establish PostgreSQL connection")
    sys.exit(1)

pg_cursor = pg_conn.cursor()
print("PostgreSQL connection established!")

# Create PostgreSQL tables for the two main tables only
pg_cursor.execute(
    """
CREATE TABLE IF NOT EXISTS bot_personal_data_individuals (
    reportingDate TIMESTAMP,
    customerIdentificationNumber VARCHAR(50),
    firstName VARCHAR(100),
    middleNames VARCHAR(100),
    surname VARCHAR(100),
    gender VARCHAR(50),
    dateOfBirth VARCHAR(12),
    maritalStatus VARCHAR(50),
    numberOfDependants INTEGER,
    disabilityStatus VARCHAR(50),
    disabilityType VARCHAR(50),
    citizenship VARCHAR(50),
    nationality VARCHAR(50),
    residence VARCHAR(50),
    residenceStatus VARCHAR(50),
    employmentStatus VARCHAR(50),
    occupation VARCHAR(50),
    employerName VARCHAR(100),
    employerAddress VARCHAR(200),
    sectorEmployer VARCHAR(50),
    incomeRange VARCHAR(50),
    educationLevel VARCHAR(50),
    identificationType VARCHAR(50),
    identificationNumber VARCHAR(50),
    issuingCountry VARCHAR(50),
    issuingAuthority VARCHAR(100),
    issueDate VARCHAR(12),
    expiryDate VARCHAR(12),
    mobileNumber VARCHAR(50),
    altMobileNumber VARCHAR(50),
    emailAddress VARCHAR(100),
    altEmailAddress VARCHAR(100),
    postalAddress VARCHAR(200),
    physicalAddress VARCHAR(200),
    region VARCHAR(50),
    district VARCHAR(50),
    ward VARCHAR(50),
    street VARCHAR(100),
    houseNumber VARCHAR(50),
    postalCode VARCHAR(50),
    country VARCHAR(50),
    gpsCoordinates VARCHAR(50),
    nextOfKinName VARCHAR(100),
    nextOfKinRelationship VARCHAR(50),
    nextOfKinMobileNumber VARCHAR(50),
    nextOfKinEmailAddress VARCHAR(100),
    nextOfKinAddress VARCHAR(200),
    nextOfKinRegion VARCHAR(50),
    nextOfKinDistrict VARCHAR(50),
    nextOfKinWard VARCHAR(50),
    nextOfKinStreet VARCHAR(100),
    nextOfKinHouseNumber VARCHAR(50),
    nextOfKinPostalCode VARCHAR(50),
    nextOfKinCountry VARCHAR(50),
    nextOfKinGpsCoordinates VARCHAR(50),
    kycStatus VARCHAR(50),
    kycDate VARCHAR(12),
    kycExpiryDate VARCHAR(12),
    riskRating VARCHAR(50),
    riskRatingDate VARCHAR(12),
    pepStatus VARCHAR(50),
    pepClassification VARCHAR(50),
    pepPosition VARCHAR(100),
    pepCountry VARCHAR(50),
    pepRelationship VARCHAR(50),
    sanctionsStatus BOOLEAN,
    sanctionsList VARCHAR(100),
    sanctionsDate VARCHAR(12),
    sanctionsCountry VARCHAR(50),
    village VARCHAR(50)
);
"""
)
pg_cursor.execute(
    """
CREATE TABLE IF NOT EXISTS bot_asset_owned_or_acquired (
    reportingDate TIMESTAMP,
    assetCategory VARCHAR(50),
    assetType VARCHAR(50),
    acquisitionDate TIMESTAMP,
    currency VARCHAR(50),
    orgCostValue NUMERIC,
    usdCostValue NUMERIC,
    tzsCostValue NUMERIC,
    allowanceProbableLoss NUMERIC,
    botProvision NUMERIC
);
"""
)

# Create a table to track when data was last pulled from DB2
pg_cursor.execute(
    """
CREATE TABLE IF NOT EXISTS poller_tracking (
    id SERIAL PRIMARY KEY,
    last_poll_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    poll_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
"""
)

pg_conn.commit()


# Simplified validation functions for the two main tables


def validate_personal_individual(payload):
    # Simplified validation - just check if customeridentificationnumber exists
    if not payload.get("customeridentificationnumber"):
        print(f"Invalid Personal Data Individuals: Missing customeridentificationnumber")
        return False
    return True


def validate_asset_owned_or_acquired(payload):
    # Simplified validation - just check if assetcategory exists
    if not payload.get("assetcategory"):
        print(f"Invalid Asset Owned or Acquired: Missing assetcategory")
        return False
    return True


# Helper function to safely convert to float
def safe_float(value):
    if value is None:
        return 0.0
    try:
        return float(value)
    except (ValueError, TypeError):
        return 0.0


# Helper function to safely convert to int
def safe_int(value):
    if value is None:
        return 0
    try:
        return int(value)
    except (ValueError, TypeError):
        return 0


# Helper function to convert DDMMYYYYHHMM format to timestamp
def convert_ddmmyyyyhhmm_to_timestamp(date_str):
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


# Polling and transformation for Personal Data Individuals
def poll_and_transform_personal_individuals(last_timestamp):
    if db2_conn is None:
        logger.error("DB2 connection is None")
        return []
        
    # Query records from DB2 that were created after the last poll timestamp
    # Use a direct comparison without the TIMESTAMP function
    query = "SELECT * FROM CBS_SCHEMA.PERSONAL_DATA_INDIVIDUALS WHERE CREATEDDATE > ?"
    stmt = ibm_db.prepare(db2_conn, query)
    
    if stmt is False:
        logger.error("Failed to prepare statement for PERSONAL_DATA_INDIVIDUALS")
        return []
    
    # Properly handle the statement object
    if stmt and stmt is not True and stmt is not False:
        ibm_db.bind_param(stmt, 1, last_timestamp)
        result = ibm_db.execute(stmt)
        
        if result is False:
            logger.error("Failed to execute query for PERSONAL_DATA_INDIVIDUALS")
            return []
        
        rows = []
        while True:
            try:
                # Try to fetch row - ibm_db.fetch_row returns True on success, False on end of data
                fetch_result = ibm_db.fetch_row(stmt)
                if fetch_result is False:
                    break  # No more rows
                    
                # Safely get results with error handling
                def safe_result(col_name):
                    try:
                        return ibm_db.result(stmt, col_name)
                    except Exception:
                        return None

                row = {
                    "customerIdentificationNumber": safe_result("CUSTOMERIDENTIFICATIONNUMBER"),
                    "firstName": safe_result("FIRSTNAME"),
                    "middleNames": safe_result("MIDDLENAMES"),
                    "surname": safe_result("SURNAME"),
                    "gender": safe_result("GENDER"),
                    "dateOfBirth": safe_result("DATEOFBIRTH"),
                    "maritalStatus": safe_result("MARITALSTATUS"),
                    "numberOfDependants": safe_result("NUMBEROFDEPENDANTS"),
                    "disabilityStatus": safe_result("DISABILITYSTATUS"),
                    "disabilityType": safe_result("DISABILITYTYPE"),
                    "citizenship": safe_result("CITIZENSHIP"),
                    "nationality": safe_result("NATIONALITY"),
                    "residence": safe_result("RESIDENCE"),
                    "residenceStatus": safe_result("RESIDENCESTATUS"),
                    "employmentStatus": safe_result("EMPLOYMENTSTATUS"),
                    "occupation": safe_result("OCCUPATION"),
                    "employerName": safe_result("EMPLOYERNAME"),
                    "employerAddress": safe_result("EMPLOYERADDRESS"),
                    "sectorEmployer": safe_result("SECTOREMPLOYER"),
                    "incomeRange": safe_result("INCOMERANGE"),
                    "educationLevel": safe_result("EDUCATIONLEVEL"),
                    "identificationType": safe_result("IDENTIFICATIONTYPE"),
                    "identificationNumber": safe_result("IDENTIFICATIONNUMBER"),
                    "issuingCountry": safe_result("ISSUINGCOUNTRY"),
                    "issuingAuthority": safe_result("ISSUINGAUTHORITY"),
                    "issueDate": safe_result("ISSUEDATE"),
                    "expiryDate": safe_result("EXPIRYDATE"),
                    "mobileNumber": safe_result("MOBILENUMBER"),
                    "altMobileNumber": safe_result("ALTMOBILENUMBER"),
                    "emailAddress": safe_result("EMAILADDRESS"),
                    "altEmailAddress": safe_result("ALTEMAILADDRESS"),
                    "postalAddress": safe_result("POSTALADDRESS"),
                    "physicalAddress": safe_result("PHYSICALADDRESS"),
                    "region": safe_result("REGION"),
                    "district": safe_result("DISTRICT"),
                    "ward": safe_result("WARD"),
                    "street": safe_result("STREET"),
                    "houseNumber": safe_result("HOUSENUMBER"),
                    "postalCode": safe_result("POSTALCODE"),
                    "country": safe_result("COUNTRY"),
                    "gpsCoordinates": safe_result("GPSCOORDINATES"),
                    "nextOfKinName": safe_result("NEXTOFKINNAME"),
                    "nextOfKinRelationship": safe_result("NEXTOFKINRELATIONSHIP"),
                    "nextOfKinMobileNumber": safe_result("NEXTOFKINMOBILENUMBER"),
                    "nextOfKinEmailAddress": safe_result("NEXTOFKINEMAILADDRESS"),
                    "nextOfKinAddress": safe_result("NEXTOFKINADDRESS"),
                    "nextOfKinRegion": safe_result("NEXTOFKINREGION"),
                    "nextOfKinDistrict": safe_result("NEXTOFKINDISTRICT"),
                    "nextOfKinWard": safe_result("NEXTOFKINWARD"),
                    "nextOfKinStreet": safe_result("NEXTOFKINSTREET"),
                    "nextOfKinHouseNumber": safe_result("NEXTOFKINHOUSENUMBER"),
                    "nextOfKinPostalCode": safe_result("NEXTOFKINPOSTALCODE"),
                    "nextOfKinCountry": safe_result("NEXTOFKINCOUNTRY"),
                    "nextOfKinGpsCoordinates": safe_result("NEXTOFKINGPSCOORDINATES"),
                    "kycStatus": safe_result("KYCSTATUS"),
                    "kycDate": safe_result("KYCDATE"),
                    "kycExpiryDate": safe_result("KYCEXPIRYDATE"),
                    "riskRating": safe_result("RISKRATING"),
                    "riskRatingDate": safe_result("RISKRATINGDATE"),
                    "pepStatus": safe_result("PEPSTATUS"),
                    "pepClassification": safe_result("PEPCLASSIFICATION"),
                    "pepPosition": safe_result("PEPPOSITION"),
                    "pepCountry": safe_result("PEPCOUNTRY"),
                    "pepRelationship": safe_result("PEPRELATIONSHIP"),
                    "sanctionsStatus": safe_result("SANCTIONSSTATUS"),
                    "sanctionsList": safe_result("SANCTIONSLIST"),
                    "sanctionsDate": safe_result("SANCTIONSDATE"),
                    "sanctionsCountry": safe_result("SANCTIONSCOUNTRY"),
                    "village": safe_result("VILLAGE"),
                }
                # Simplified enriched data without lookups
                enriched = {
                    "reportingdate": datetime.now(),
                    "customeridentificationnumber": row["customerIdentificationNumber"],
                    "firstname": row["firstName"],
                    "middlenames": row["middleNames"],
                    "surname": row["surname"],
                    "gender": row["gender"],
                    "dateofbirth": convert_ddmmyyyyhhmm_to_timestamp(row["dateOfBirth"]),
                    "maritalstatus": row["maritalStatus"],
                    "numberofdependants": row["numberOfDependants"],
                    "disabilitystatus": row["disabilityStatus"],
                    "disabilitytype": row["disabilityType"],
                    "citizenship": row["citizenship"],
                    "nationality": row["nationality"],
                    "residence": row["residence"],
                    "residencestatus": row["residenceStatus"],
                    "employmentstatus": row["employmentStatus"],
                    "occupation": row["occupation"],
                    "employername": row["employerName"],
                    "employeraddress": row["employerAddress"],
                    "sectoremployer": row["sectorEmployer"],
                    "incomerange": row["incomeRange"],
                    "educationlevel": row["educationLevel"],
                    "identificationtype": row["identificationType"],
                    "identificationnumber": row["identificationNumber"],
                    "issuingcountry": row["issuingCountry"],
                    "issuingauthority": row["issuingAuthority"],
                    "issuedate": convert_ddmmyyyyhhmm_to_timestamp(row["issueDate"]),
                    "expirydate": convert_ddmmyyyyhhmm_to_timestamp(row["expiryDate"]),
                    "mobilenumber": row["mobileNumber"],
                    "altmobilenumber": row["altMobileNumber"],
                    "emailaddress": row["emailAddress"],
                    "altemailaddress": row["altEmailAddress"],
                    "postaladdress": row["postalAddress"],
                    "physicaladdress": row["physicalAddress"],
                    "region": row["region"],
                    "district": row["district"],
                    "ward": row["ward"],
                    "street": row["street"],
                    "housenumber": row["houseNumber"],
                    "postalcode": row["postalCode"],
                    "country": row["country"],
                    "gpscoordinates": row["gpsCoordinates"],
                    "nextofkinname": row["nextOfKinName"],
                    "nextofkinrelationship": row["nextOfKinRelationship"],
                    "nextofkinmobilenumber": row["nextOfKinMobileNumber"],
                    "nextofkinemailaddress": row["nextOfKinEmailAddress"],
                    "nextofkinaddress": row["nextOfKinAddress"],
                    "nextofkinregion": row["nextOfKinRegion"],
                    "nextofkindistrict": row["nextOfKinDistrict"],
                    "nextofkinward": row["nextOfKinWard"],
                    "nextofkinstreet": row["nextOfKinStreet"],
                    "nextofkinhousenumber": row["nextOfKinHouseNumber"],
                    "nextofkinpostalcode": row["nextOfKinPostalCode"],
                    "nextofkincountry": row["nextOfKinCountry"],
                    "nextofkingpscoordinates": row["nextOfKinGpsCoordinates"],
                    "kycstatus": row["kycStatus"],
                    "kycdate": convert_ddmmyyyyhhmm_to_timestamp(row["kycDate"]),
                    "kycexpirydate": convert_ddmmyyyyhhmm_to_timestamp(row["kycExpiryDate"]),
                    "riskrating": row["riskRating"],
                    "riskratingdate": convert_ddmmyyyyhhmm_to_timestamp(row["riskRatingDate"]),
                    "pepstatus": row["pepStatus"],
                    "pepclassification": row["pepClassification"],
                    "pepposition": row["pepPosition"],
                    "pepcountry": row["pepCountry"],
                    "peprelationship": row["pepRelationship"],
                    "sanctionsstatus": (
                        row["sanctionsStatus"] == "Y" if row["sanctionsStatus"] else False
                    ),
                    "sanctionslist": row["sanctionsList"],
                    "sanctionsdate": convert_ddmmyyyyhhmm_to_timestamp(row["sanctionsDate"]),
                    "sanctionscountry": row["sanctionsCountry"],
                    "village": row["village"],
                }
                if validate_personal_individual(enriched):
                    rows.append(enriched)
                else:
                    print(f"Skipped invalid Personal Data Individuals row: {json.dumps(row)}")
            except Exception as e:
                logger.error(f"Error processing PERSONAL_DATA_INDIVIDUALS row: {e}")
                break
        return rows
    return []


# Polling and transformation for Asset Owned or Acquired
def poll_and_transform_asset_owned_or_acquired(last_timestamp):
    if db2_conn is None:
        logger.error("DB2 connection is None")
        return []
        
    # Query records from DB2 that were created after the last poll timestamp
    query = "SELECT * FROM CBS_SCHEMA.ASSET_OWNED_OR_ACQUIRED WHERE CREATEDDATE > ?"
    logger.info(f"Executing query: {query} with timestamp: {last_timestamp}")
    stmt = ibm_db.prepare(db2_conn, query)
    
    if stmt is False:
        logger.error("Failed to prepare statement for ASSET_OWNED_OR_ACQUIRED")
        return []
    
    # Properly handle the statement object
    if stmt and stmt is not True and stmt is not False:
        ibm_db.bind_param(stmt, 1, last_timestamp)
        result = ibm_db.execute(stmt)
        logger.info(f"Query execution result: {result}")
        
        if result is False:
            logger.error("Failed to execute query for ASSET_OWNED_OR_ACQUIRED")
            return []
        
        rows = []
        while True:
            try:
                # Try to fetch row - ibm_db.fetch_row returns True on success, False on end of data
                fetch_result = ibm_db.fetch_row(stmt)
                logger.info(f"Fetch row result: {fetch_result}")
                if fetch_result is False:
                    break  # No more rows
                
                # Helper function to safely convert to float
                def safe_float(value):
                    if value is None:
                        return 0.0
                    try:
                        return float(value)
                    except (ValueError, TypeError):
                        return 0.0

                # Safely get results with error handling
                def safe_result(col_name):
                    try:
                        return ibm_db.result(stmt, col_name)
                    except Exception:
                        return None

                row = {
                    "assetCategory": safe_result("ASSETCATEGORY"),
                    "assetType": safe_result("ASSETTYPE"),
                    "acquisitionDate": safe_result("ACQUISITIONDATE"),
                    "currency": safe_result("CURRENCY"),
                    "orgCostValue": safe_float(safe_result("ORGCOSTVALUE")),
                    "usdCostValue": safe_float(safe_result("USDCOSTVALUE")),
                    "tzsCostValue": safe_float(safe_result("TZSCOSTVALUE")),
                    "allowanceProbableLoss": safe_float(
                        safe_result("ALLOWANCEPROBABLELOSS")
                    ),
                    "botProvision": safe_float(safe_result("BOTPROVISION")),
                }
                logger.info(f"Processing row: {row}")
                # Complete enriched data with all fields
                enriched = {
                    "reportingdate": datetime.now(),
                    "assetcategory": row["assetCategory"],
                    "assettype": row["assetType"],
                    "acquisitiondate": convert_ddmmyyyyhhmm_to_timestamp(row["acquisitionDate"]),
                    "currency": row["currency"],
                    "orgcostvalue": row["orgCostValue"],
                    "usdcostvalue": row["usdCostValue"],
                    "tzscostvalue": row["tzsCostValue"],
                    "allowanceprobableloss": row["allowanceProbableLoss"],
                    "botprovision": row["botProvision"],
                }
                if validate_asset_owned_or_acquired(enriched):
                    rows.append(enriched)
                    logger.info(f"Added valid row to results: {enriched}")
                else:
                    logger.info(f"Skipped invalid row: {json.dumps(row)}")
            except Exception as e:
                logger.error(f"Error processing ASSET_OWNED_OR_ACQUIRED row: {e}")
                break
        logger.info(f"Total rows found: {len(rows)}")
        return rows
    return []


# Function to insert into PostgreSQL with batch processing
def insert_to_pg(table, data):
    if not data or pg_conn is None or pg_cursor is None:
        return
        
    columns = ", ".join(data[0].keys())
    placeholders = ", ".join(["%s" for _ in data[0]])
    insert_query = f"INSERT INTO {table} ({columns}) VALUES ({placeholders})"
    
    # Process in batches of 100 for better performance
    batch_size = 100
    total_inserted = 0
    
    try:
        # Don't change autocommit mode, just use explicit transactions
        for i in range(0, len(data), batch_size):
            batch = data[i:i+batch_size]
            batch_values = [tuple(row.values()) for row in batch]
            
            try:
                pg_cursor.executemany(insert_query, batch_values)
                total_inserted += len(batch)
                logger.info(f"Batch inserted {len(batch)} rows into {table}")
            except Exception as e:
                logger.error(f"Batch insert error for {table}: {e}")
                
                # Fall back to individual inserts if batch fails
                for row in batch:
                    try:
                        pg_cursor.execute(insert_query, tuple(row.values()))
                        total_inserted += 1
                    except Exception as row_error:
                        logger.error(f"Row insert error for {table}: {row_error}")
        
        # Commit the transaction
        pg_conn.commit()
        logger.info(f"Successfully inserted {total_inserted} rows into {table}")
        
    except Exception as e:
        logger.error(f"Transaction error for {table}: {e}")
        pg_conn.rollback()
    finally:
        pass  # Don't change autocommit mode


# Function to update poller tracking
def update_poller_tracking():
    try:
        pg_cursor.execute(
            "INSERT INTO poller_tracking DEFAULT VALUES"
        )
        if pg_conn is not None:
            pg_conn.commit()
        logger.info("Updated poller tracking with current timestamp")
    except Exception as e:
        logger.error(f"Error updating poller tracking: {e}")


# Function to get the last poll timestamp
def get_last_poll_timestamp():
    try:
        # Get the last poll timestamp
        pg_cursor.execute(
            "SELECT COALESCE(MAX(last_poll_timestamp), '1900-01-01 00:00:00.000000') FROM poller_tracking"
        )
        result = pg_cursor.fetchone()
        
        if result and result[0]:
            # Format the timestamp for DB2 (DB2 uses a specific format for timestamp literals)
            # DB2 format: 'YYYY-MM-DD-HH.MM.SS.FFFFFF'
            db2_timestamp = result[0].strftime('%Y-%m-%d-%H.%M.%S.%f')
            return db2_timestamp
        else:
            # Return a default timestamp if no previous polls
            return "1900-01-01-00.00.00.000000"
    except Exception as e:
        logger.error(f"Error getting last poll timestamp: {e}")
        # Return a default timestamp if error
        return "1900-01-01-00.00.00.000000"


# Main polling loop - optimized for the two required tables
poll_interval = 30  # Poll every 30 seconds
max_batch_size = 1000  # Limit batch size for better performance

logger.info(
    "Starting optimized poller for PERSONAL_DATA_INDIVIDUALS and ASSET_OWNED_OR_ACQUIRED..."
)

# Track metrics for monitoring
poll_metrics = {
    "successful_polls": 0,
    "failed_polls": 0,
    "records_processed": {
        "personal_data_individuals": 0,
        "asset_owned_or_acquired": 0
    }
}

while True:
    try:
        logger.info("Polling cycle started")
        
        # Get the last poll timestamp
        last_timestamp = get_last_poll_timestamp()
        logger.info(f"Last poll timestamp: {last_timestamp}")
        
        # Test DB2 connection before polling
        if db2_conn is not None:
            test_query = "SELECT 1 FROM SYSIBM.SYSDUMMY1"
            test_stmt = ibm_db.prepare(db2_conn, test_query)
            if test_stmt is False:
                logger.error("Failed to prepare DB2 test statement")
            elif test_stmt is not True and test_stmt is not False:
                test_result = ibm_db.execute(test_stmt)
                if test_result is False:
                    logger.error("DB2 connection test failed, reconnecting...")
                    ibm_db.close(db2_conn)
                    db2_conn = connect_with_retry(connect_db2)
        else:
            logger.error("DB2 connection is None, reconnecting...")
            db2_conn = connect_with_retry(connect_db2)
        
        # Test PostgreSQL connection before inserting
        try:
            if pg_cursor is not None:
                pg_cursor.execute("SELECT 1")
            else:
                logger.error("PostgreSQL cursor is None, reconnecting...")
                pg_conn = connect_with_retry(connect_postgres)
                if pg_conn is not None:
                    pg_cursor = pg_conn.cursor()
        except Exception:
            logger.error("PostgreSQL connection lost, reconnecting...")
            if pg_conn is not None:
                try:
                    pg_cursor.close()
                    pg_conn.close()
                except:
                    pass
            pg_conn = connect_with_retry(connect_postgres)
            if pg_conn is not None:
                pg_cursor = pg_conn.cursor()

        # Poll the two required tables with transaction support
        personal_individuals_rows = poll_and_transform_personal_individuals(last_timestamp)
        if personal_individuals_rows:
            logger.info(f"Found {len(personal_individuals_rows)} new personal_data_individuals records")
            insert_to_pg("bot_personal_data_individuals", personal_individuals_rows)
            poll_metrics["records_processed"]["personal_data_individuals"] += len(personal_individuals_rows)

        asset_owned_rows = poll_and_transform_asset_owned_or_acquired(last_timestamp)
        if asset_owned_rows:
            logger.info(f"Found {len(asset_owned_rows)} new asset_owned_or_acquired records")
            insert_to_pg("bot_asset_owned_or_acquired", asset_owned_rows)
            poll_metrics["records_processed"]["asset_owned_or_acquired"] += len(asset_owned_rows)

        # Update poller tracking if we found new data
        if personal_individuals_rows or asset_owned_rows:
            update_poller_tracking()
            logger.info("Data found and processed, updated poller tracking")
        else:
            logger.info("No new data found")
        
        poll_metrics["successful_polls"] += 1
        
        # Log metrics every 10 successful polls
        if poll_metrics["successful_polls"] % 10 == 0:
            logger.info(f"Polling metrics: {json.dumps(poll_metrics)}")
            
        time.sleep(poll_interval)
    except Exception as e:
        poll_metrics["failed_polls"] += 1
        logger.error(f"Polling error: {e}", exc_info=True)
        
        # Attempt to reconnect to both databases if there's an error
        try:
            if db2_conn is not None:
                ibm_db.close(db2_conn)
            db2_conn = connect_with_retry(connect_db2)
            
            if pg_cursor is not None:
                pg_cursor.close()
            if pg_conn is not None:
                pg_conn.close()
            pg_conn = connect_with_retry(connect_postgres)
            if pg_conn is not None:
                pg_cursor = pg_conn.cursor()
            
            logger.info("Successfully reconnected to databases after error")
        except Exception as reconnect_error:
            logger.error(f"Failed to reconnect: {reconnect_error}", exc_info=True)
            
        time.sleep(poll_interval * 2)  # Wait longer after an error

# Close connections (handled on shutdown)
try:
    if db2_conn is not None:
        ibm_db.close(db2_conn)
    if pg_cursor is not None:
        pg_cursor.close()
    if pg_conn is not None:
        pg_conn.close()
except Exception as e:
    logger.error(f"Error closing connections: {e}")