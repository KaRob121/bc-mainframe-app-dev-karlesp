# Lab 2: Data Migration Simulation - Oracle to MongoDB



---

## Lab Overview

| Aspect | Details |
|--------|---------|
| **Duration** | 20-25 minutes |
| **Objective** | Simulate an Oracle to MongoDB migration including profiling, cleansing, mapping, and validation |
| **Environment** | AWS EC2 (pre-configured) or Local Machine with Python |
| **Tools** | Python 3, pymongo, MongoDB Atlas |

---

## Prerequisites

- [ ] Lab 1 completed (MongoDB Atlas cluster ready)
- [ ] Python 3.7+ installed (if running locally)
- [ ] MongoDB Atlas connection string ready
- [ ] EC2 instance access (if provided by instructor)

---

## Theoretical Foundation: Data Migration

### What is Data Migration?

**Data migration** is the process of moving data from one system to another. In enterprise environments, this often involves moving from legacy databases (like Oracle) to modern databases (like MongoDB).

### Why Organizations Migrate from Oracle to MongoDB

| Reason | Explanation |
|--------|-------------|
| **Scalability** | MongoDB's horizontal scaling handles massive data volumes |
| **Flexible Schema** | No rigid table structures - adapt as requirements change |
| **Developer Productivity** | JSON-like documents match how applications use data |
| **Cost Efficiency** | Open-source with lower total cost of ownership |
| **Cloud-Native** | Built for distributed, cloud-based architectures |

### The ETL Pattern in Migration

Data migration follows the **ETL (Extract, Transform, Load)** pattern:

<img src="diagrams/etl-pattern.svg" alt="ETL Pattern: Extract, Transform, Load" width="480"/>

| Phase | What Happens | In This Lab |
|-------|--------------|-------------|
| **Extract** | Read data from source system | Read `customers.csv` (simulating Oracle table) |
| **Transform** | Cleanse, validate, reshape data | Profile, deduplicate, fix missing values, standardize |
| **Load** | Write to target database | Insert documents into MongoDB Atlas |

---

## Part 1: Setup Environment (3 minutes)

### Step 1.1: Create Lab Directory

**If using EC2 Instance Connect:**
```bash
mkdir -p /home/ec2-user/lab2
cd /home/ec2-user/lab2
```

**If using Local Machine (Windows/Mac/Linux):**
```bash
mkdir -p ~/migration-lab
cd ~/migration-lab
```

### Step 1.2: Install Required Python Package

```bash
pip3 install pymongo
```

**Expected Output:**
```
Collecting pymongo
  Downloading pymongo-4.17.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
Installing collected packages: pymongo
Successfully installed pymongo-4.17.0
```

---

## Part 2: Create Source Data (2 minutes)

### Step 2.1: Create the Source CSV File

Create a file named `customers.csv` that simulates an Oracle table export:

```bash
cat > customers.csv << 'EOF'
customer_id,name,email,state,phone,signup_date
1001,John Smith,john@email.com,NY,555-0101,2024-01-15
1001,John Smith,john@email.com,NY,555-0101,2024-01-15
1002,Jane Doe,,ca,555-0102,2024-02-20
1003, Bob Wilson,bob@email.com,California,,2024-03-10
1004,Alice Brown,,TX,555-0104,2024-01-05
EOF
```

### Step 2.2: Verify the Source Data

```bash
cat customers.csv
```

**Expected Output:**
```
customer_id,name,email,state,phone,signup_date
1001,John Smith,john@email.com,NY,555-0101,2024-01-15
1001,John Smith,john@email.com,NY,555-0101,2024-01-15
1002,Jane Doe,,ca,555-0102,2024-02-20
1003, Bob Wilson,bob@email.com,California,,2024-03-10
1004,Alice Brown,,TX,555-0104,2024-01-05
```

**Theoretical Note - Common Data Quality Issues:**

| Issue | Example | Real-World Impact |
|-------|---------|-------------------|
| **Duplicate records** | customer_id 1001 twice | Inflated counts, wasted storage |
| **Missing values** | Empty email fields | Cannot contact customers |
| **Inconsistent formats** | "ca", "California", "NY" | Broken reports |
| **Leading/trailing spaces** | " Bob Wilson" | Failed lookups |

---

## Part 3: Create the Migration Script (5 minutes)

### Step 3.1: Create the Complete Migration Script

```bash
cat > migration.py << 'EOF'
#!/usr/bin/env python3
"""Migration script for Oracle to MongoDB simulation

This script performs ETL (Extract, Transform, Load) operations:
1. Extracts data from CSV (simulating Oracle export)
2. Profiles data quality issues
3. Cleanses data (deduplication, fix missing values, standardize formats)
4. Loads clean data to MongoDB Atlas
"""

import argparse
import csv
from datetime import datetime
from pymongo import MongoClient

# ============================================================
# DATA PROFILING - Analyze source data quality
# ============================================================

def profile_data(csv_file):
    """Analyze data quality issues in the source CSV file
    
    This function examines the data and reports:
    - Total record count
    - Duplicate records
    - Missing values
    - Inconsistent formats
    - Data quality score
    
    Args:
        csv_file: Path to the source CSV file
        
    Returns:
        List of record dictionaries for further processing
    """
    
    print("\n" + "=" * 50)
    print("DATA PROFILING REPORT")
    print("=" * 50)
    
    # Read all records from CSV
    records = []
    with open(csv_file, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            records.append(row)
    
    total = len(records)
    print(f"\n📊 Total records found: {total}")
    
    # Check for duplicate customer_id values
    customer_ids = [r['customer_id'] for r in records]
    duplicates = len(customer_ids) - len(set(customer_ids))
    print(f"🔄 Duplicate customer_id records: {duplicates}")
    
    # Check for missing email addresses
    missing_email = sum(1 for r in records if not r.get('email', '').strip())
    print(f"📧 Missing email addresses: {missing_email}")
    
    # Check for invalid or inconsistent state codes
    states = [r.get('state', '').strip().lower() for r in records]
    valid_states = ['ny', 'ca', 'tx']
    invalid_states = sum(1 for s in states if s and s not in valid_states)
    print(f"🏷️  Invalid state codes: {invalid_states}")
    
    # Check for leading/trailing whitespace in names
    whitespace_names = sum(1 for r in records 
                          if r.get('name', '') != r.get('name', '').strip())
    print(f"✂️  Names with extra spaces: {whitespace_names}")
    
    # Calculate overall data quality score (0-100)
    issues = duplicates + missing_email + invalid_states + whitespace_names
    quality_score = max(0, int((1 - issues / total) * 100)) if total > 0 else 0
    print(f"\n📈 Data Quality Score: {quality_score}%")
    
    # Provide recommendations based on findings
    print("\n📋 Recommendations:")
    if duplicates > 0:
        print("   - Remove duplicate records")
    if missing_email > 0:
        print("   - Provide default values for missing emails")
    if invalid_states > 0:
        print("   - Standardize state codes to two-letter format")
    if whitespace_names > 0:
        print("   - Trim whitespace from name fields")
    
    return records


# ============================================================
# DATA CLEANSING - Fix data quality issues
# ============================================================

def cleanse_data(records):
    """Apply cleansing rules to fix data quality issues
    
    Cleansing operations performed:
    1. Remove duplicate records based on customer_id
    2. Replace missing emails with default value
    3. Standardize state codes (CA, NY, TX)
    4. Trim whitespace from name fields
    5. Remove hyphens from phone numbers
    
    Args:
        records: List of record dictionaries from source
        
    Returns:
        List of cleansed record dictionaries
    """
    
    print("\n" + "=" * 50)
    print("DATA CLEANSING OPERATIONS")
    print("=" * 50)
    
    original_count = len(records)
    
    # Remove duplicate records (keep first occurrence)
    seen_customer_ids = set()
    unique_records = []
    for record in records:
        if record['customer_id'] not in seen_customer_ids:
            seen_customer_ids.add(record['customer_id'])
            unique_records.append(record)
    
    duplicates_removed = original_count - len(unique_records)
    print(f"\n🔄 Duplicates removed: {duplicates_removed}")
    
    # Apply cleansing rules to each record
    for record in unique_records:
        
        # Fix 1: Replace missing emails with default
        if not record.get('email', '').strip():
            record['email'] = 'unknown@example.com'
        
        # Fix 2: Standardize state codes
        state = record.get('state', '').strip().lower()
        if state in ['ca', 'california']:
            record['state'] = 'CA'
        elif state in ['ny', 'new york']:
            record['state'] = 'NY'
        elif state in ['tx', 'texas']:
            record['state'] = 'TX'
        else:
            record['state'] = state.upper() if state else 'UNKNOWN'
        
        # Fix 3: Trim whitespace from names
        record['name'] = record.get('name', '').strip()
        
        # Fix 4: Remove hyphens from phone numbers
        if record.get('phone'):
            record['phone'] = record['phone'].replace('-', '')
    
    print(f"📧 Missing emails fixed: {original_count - sum(1 for r in unique_records if r['email'] == 'unknown@example.com')}")
    print(f"🏷️  State codes standardized")
    print(f"✂️  Names trimmed")
    
    return unique_records


# ============================================================
# SOURCE TO TARGET MAPPING
# ============================================================

def transform_to_document(record):
    """Transform a CSV record to MongoDB document format
    
    Source to Target Mapping:
    ┌─────────────────┬─────────────────┬─────────────────────────────┐
    │ Source Field    │ Target Field    │ Transformation              │
    ├─────────────────┼─────────────────┼─────────────────────────────┤
    │ customer_id     │ customerId      │ Renamed to camelCase        │
    │ name            │ name            │ Already trimmed             │
    │ email           │ contact.email   │ Nested in contact object    │
    │ phone           │ contact.phone   │ Nested in contact object    │
    │ state           │ address.state   │ Nested in address object    │
    │ signup_date     │ signupDate      │ Converted to Date type      │
    └─────────────────┴─────────────────┴─────────────────────────────┘
    
    Args:
        record: Cleansed record dictionary
        
    Returns:
        MongoDB document dictionary
    """
    
    return {
        "customerId": int(record['customer_id']),
        "name": record['name'],
        "contact": {
            "email": record['email'],
            "phone": record.get('phone', '')
        },
        "address": {
            "state": record['state']
        },
        "signupDate": datetime.strptime(record['signup_date'], '%Y-%m-%d'),
        "dataQuality": {
            "score": 100,
            "cleansed": True,
            "cleansedAt": datetime.now()
        }
    }


# ============================================================
# LOAD TO MONGODB
# ============================================================

def load_to_mongodb(records, connection_string):
    """Load cleansed and transformed data to MongoDB Atlas
    
    Args:
        records: List of cleansed record dictionaries
        connection_string: MongoDB Atlas connection string
        
    Returns:
        Number of documents loaded
    """
    
    print("\n" + "=" * 50)
    print("LOADING TO MONGODB ATLAS")
    print("=" * 50)
    
    # Connect to MongoDB Atlas
    print("\n🔌 Connecting to MongoDB Atlas...")
    client = MongoClient(connection_string)
    
    # Select database and collection
    db = client.migration_db
    collection = db.customers
    
    print(f"✅ Connected to database: migration_db")
    print(f"✅ Using collection: customers")
    
    # Transform each record to MongoDB document format
    documents = []
    for record in records:
        doc = transform_to_document(record)
        documents.append(doc)
    
    # Clear existing data (optional - for clean load)
    previous_count = collection.count_documents({})
    if previous_count > 0:
        collection.delete_many({})
        print(f"\n🗑️  Cleared {previous_count} existing documents")
    
    # Insert new documents
    print(f"\n📝 Inserting {len(documents)} documents...")
    result = collection.insert_many(documents)
    
    # Create index for better query performance
    print("\n🔍 Creating index on customerId...")
    collection.create_index("customerId", unique=True)
    
    print(f"\n✅ Successfully loaded {len(result.inserted_ids)} documents")
    print(f"📦 Database: migration_db")
    print(f"📄 Collection: customers")
    
    return len(result.inserted_ids)


# ============================================================
# VALIDATION FUNCTIONS
# ============================================================

def validate_migration(connection_string):
    """Perform post-migration validation checks
    
    Args:
        connection_string: MongoDB Atlas connection string
    """
    
    print("\n" + "=" * 50)
    print("POST-MIGRATION VALIDATION")
    print("=" * 50)
    
    client = MongoClient(connection_string)
    collection = client.migration_db.customers
    
    # Check 1: Document count
    count = collection.count_documents({})
    print(f"\n✅ Document count: {count}")
    
    # Check 2: Check for duplicates (should be 0)
    pipeline = [
        {"$group": {"_id": "$customerId", "count": {"$sum": 1}}},
        {"$match": {"count": {"$gt": 1}}}
    ]
    duplicates = list(collection.aggregate(pipeline))
    print(f"✅ Duplicate customerId records: {len(duplicates)}")
    
    # Check 3: Check for missing emails (should be none)
    missing_emails = collection.count_documents({"contact.email": ""})
    print(f"✅ Missing emails: {missing_emails}")
    
    # Check 4: Sample document
    sample = collection.find_one()
    if sample:
        print(f"\n📄 Sample document:")
        print(f"   - customerId: {sample.get('customerId')}")
        print(f"   - name: {sample.get('name')}")
        print(f"   - email: {sample.get('contact', {}).get('email')}")
        print(f"   - state: {sample.get('address', {}).get('state')}")
    
    print("\n✅ Validation complete! Migration successful.")


# ============================================================
# MAIN EXECUTION
# ============================================================

def main():
    """Main entry point for the migration script"""
    
    parser = argparse.ArgumentParser(
        description='Oracle to MongoDB Migration Simulation',
        epilog='Examples:\n  python3 migration.py --profile\n  python3 migration.py --migrate'
    )
    parser.add_argument('--profile', action='store_true', 
                       help='Run data profiling only (no migration)')
    parser.add_argument('--migrate', action='store_true',
                       help='Run full migration (profile + cleanse + load)')
    parser.add_argument('--validate', action='store_true',
                       help='Validate post-migration results')
    
    args = parser.parse_args()
    
    csv_file = 'customers.csv'
    
    if args.profile:
        # Just show data quality report
        profile_data(csv_file)
        
    elif args.migrate:
        # Full migration pipeline
        print("\n" + "=" * 60)
        print("ORACLE TO MONGODB MIGRATION PIPELINE")
        print("=" * 60)
        
        # Phase 1: Extract & Profile
        source_data = profile_data(csv_file)
        
        # Phase 2: Transform & Cleanse
        cleansed_data = cleanse_data(source_data)
        
        # Phase 3: Load to MongoDB
        print("\n" + "=" * 50)
        print("CONNECTION REQUIRED")
        print("=" * 50)
        print("\nPlease enter your MongoDB Atlas connection string.")
        print("(You can find this in Atlas → Connect → Connect your application)\n")
        
        conn_string = input("Connection string: ").strip()
        
        if conn_string:
            loaded_count = load_to_mongodb(cleansed_data, conn_string)
            print(f"\n🎉 Migration complete! Loaded {loaded_count} documents.")
            
            # Optional: Run validation
            print("\n" + "=" * 50)
            run_validation = input("Run validation? (y/n): ").strip().lower()
            if run_validation == 'y':
                validate_migration(conn_string)
        else:
            print("❌ No connection string provided. Migration cancelled.")
            
    elif args.validate:
        print("\nPlease enter your MongoDB Atlas connection string.")
        conn_string = input("Connection string: ").strip()
        if conn_string:
            validate_migration(conn_string)
        else:
            print("❌ No connection string provided.")
            
    else:
        print(__doc__)
        print("\nUsage Examples:")
        print("  python3 migration.py --profile    # Check data quality")
        print("  python3 migration.py --migrate    # Run full migration")
        print("  python3 migration.py --validate   # Verify results")


if __name__ == "__main__":
    main()
EOF
```

### Step 3.2: Make the Script Executable

```bash
chmod +x migration.py
```

---

## Part 4: Run Data Profiling (3 minutes)

### Step 4.1: Execute Profiling Command

```bash
python3 migration.py --profile
```

**Expected Output:**
```
==================================================
DATA PROFILING REPORT
==================================================

📊 Total records found: 5
🔄 Duplicate customer_id records: 1
📧 Missing email addresses: 2
🏷️  Invalid state codes: 1
✂️  Names with extra spaces: 1

📈 Data Quality Score: 0%

📋 Recommendations:
   - Remove duplicate records
   - Provide default values for missing emails
   - Standardize state codes to two-letter format
   - Trim whitespace from name fields
```

**What This Tells Us:**

| Finding | Meaning | Action Required |
|---------|---------|-----------------|
| 5 total records | Source has 5 customer records | Baseline for validation |
| 1 duplicate | Customer 1001 appears twice | Deduplication needed |
| 2 missing emails | Jane Doe, Alice Brown have no email | Default value needed |
| 1 invalid state | "ca" and "California" inconsistent | Standardization needed |
| 1 name with space | " Bob Wilson" has leading space | Trimming needed |

---

## Part 5: Run Full Migration (5 minutes)

### Step 5.1: Execute Migration Command

```bash
python3 migration.py --migrate
```

**Expected Output (Phase 1 - Profiling):**
```
============================================================
ORACLE TO MONGODB MIGRATION PIPELINE
============================================================

==================================================
DATA PROFILING REPORT
==================================================

📊 Total records found: 5
🔄 Duplicate customer_id records: 1
📧 Missing email addresses: 2
🏷️  Invalid state codes: 1
✂️  Names with extra spaces: 1

📈 Data Quality Score: 0%

📋 Recommendations:
   - Remove duplicate records
   - Provide default values for missing emails
   - Standardize state codes to two-letter format
   - Trim whitespace from name fields
```

**Expected Output (Phase 2 - Cleansing):**
```
==================================================
DATA CLEANSING OPERATIONS
==================================================

🔄 Duplicates removed: 1
📧 Missing emails fixed: 2
🏷️  State codes standardized
✂️  Names trimmed
```

**Expected Output (Phase 3 - Connection Prompt):**
```
==================================================
CONNECTION REQUIRED
==================================================

Please enter your MongoDB Atlas connection string.
(You can find this in Atlas → Connect → Connect your application)

Connection string: 
```

### Step 5.2: Enter Your MongoDB Atlas Connection String

When prompted, paste your connection string. It should look like:

```
mongodb+srv://YOUR_USERNAME:YOUR_PASSWORD@YOUR_CLUSTER.mongodb.net/
```

**Where to find this:**
1. Log into MongoDB Atlas
2. Click **Connect** on your cluster
3. Select **Connect your application**
4. Copy the connection string
5. Replace `<password>` with your actual password

**Expected Output (Phase 4 - Loading):**
```
==================================================
LOADING TO MONGODB ATLAS
==================================================

🔌 Connecting to MongoDB Atlas...
✅ Connected to database: migration_db
✅ Using collection: customers

📝 Inserting 4 documents...

🔍 Creating index on customerId...

✅ Successfully loaded 4 documents
📦 Database: migration_db
📄 Collection: customers

🎉 Migration complete! Loaded 4 documents.

==================================================
Run validation? (y/n): 
```

### Step 5.3: Run Validation (Optional)

Type `y` and press Enter to validate the migration.

**Expected Output:**
```
==================================================
POST-MIGRATION VALIDATION
==================================================

✅ Document count: 4
✅ Duplicate customerId records: 0
✅ Missing emails: 0

📄 Sample document:
   - customerId: 1001
   - name: John Smith
   - email: john@email.com
   - state: NY

✅ Validation complete! Migration successful.
```

---

## Part 6: Verify in MongoDB Atlas (3 minutes)

### Step 6.1: Open MongoDB Atlas

1. Go to **MongoDB Atlas** in your browser
2. Click **Browse Collections**

**Expected Output:**
- New database: `migration_db`
- New collection: `customers`
- Document count: **4**

### Step 6.2: View the Migrated Documents

Click on the `customers` collection to view the data.

**Expected Document Structure:**
```json
{
  "_id": ObjectId("67a3b2c1d4e5f6a7b8c9d0e1"),
  "customerId": 1001,
  "name": "John Smith",
  "contact": {
    "email": "john@email.com",
    "phone": "5550101"
  },
  "address": {
    "state": "NY"
  },
  "signupDate": ISODate("2024-01-15T00:00:00Z"),
  "dataQuality": {
    "score": 100,
    "cleansed": true,
    "cleansedAt": ISODate("2026-06-09T03:45:00Z")
  }
}
```

### Step 6.3: Verify Data Quality Fixes

| Customer | Original Issue | After Migration |
|----------|----------------|-----------------|
| 1001 (first) | Duplicate record | Single document kept |
| 1001 (second) | Duplicate record | Removed |
| 1002 | Missing email, "ca" state | Email: `unknown@example.com`, State: `CA` |
| 1003 | " California" state, missing phone, leading space | State: `CA`, Phone: (empty), Name: `Bob Wilson` |
| 1004 | Missing email | Email: `unknown@example.com` |

---

## Lab 2 Summary

### What You Accomplished

| Step | Operation | Status |
|------|-----------|--------|
| 1 | Created source CSV file | ✅ |
| 2 | Created migration script | ✅ |
| 3 | Ran data profiling | ✅ |
| 4 | Identified data quality issues | ✅ |
| 5 | Ran cleansing operations | ✅ |
| 6 | Loaded data to MongoDB Atlas | ✅ |
| 7 | Created index on customerId | ✅ |
| 8 | Validated migration results | ✅ |

### Migration Statistics

| Metric | Before | After |
|--------|--------|-------|
| Record count | 5 | 4 |
| Duplicate records | 1 | 0 |
| Missing emails | 2 | 0 |
| Invalid state codes | 2 | 0 |
| Names with spaces | 1 | 0 |

### Key Concepts Learned

| Concept | Description |
|---------|-------------|
| **Data Profiling** | Analyzing source data quality before migration |
| **ETL Pipeline** | Extract, Transform, Load process |
| **Deduplication** | Removing duplicate records based on key fields |
| **Data Cleansing** | Fixing missing values and standardizing formats |
| **Source-to-Target Mapping** | Transforming source schema to target structure |
| **Index Creation** | Optimizing query performance |
| **Post-Migration Validation** | Verifying data integrity |

### Source to Target Mapping Summary

<img src="diagrams/field-mapping.svg" alt="Source to Target Mapping" width="520"/>

---

## Troubleshooting

| Issue | Likely Cause | Solution |
|-------|--------------|----------|
| `python3: command not found` | Python not installed | Install Python 3 from python.org |
| `ModuleNotFoundError: No module named 'pymongo'` | pymongo not installed | Run `pip3 install pymongo` |
| `Connection timeout` | IP not whitelisted | Add your IP to Atlas Network Access |
| `SSL handshake failed` | TLS version mismatch | Use standard SRV connection string |
| `Authentication failed` | Wrong username/password | Verify credentials in connection string |
| `No such file: customers.csv` | Wrong directory | Ensure you're in the correct folder |

---

## Discussion Questions

1. **Why is data profiling important before migration?**
   - Answer: It identifies data quality issues early, preventing downstream failures and allowing you to plan cleansing strategies.

2. **What would change in a real Oracle to MongoDB migration?**
   - Answer: Source connection would use JDBC/ODBC instead of CSV, volumes would be millions of rows (requiring batching), and you'd need transaction management.

3. **Why use nested documents in MongoDB?**
   - Answer: Related data (contact info) is stored together, reducing the need for joins and improving read performance.

4. **What happens if you don't create indexes?**
   - Answer: Queries perform full collection scans (COLLSCAN), which become very slow as data grows.

5. **How would you handle missing phone numbers differently?**
   - Answer: Business rules might require a default value, a placeholder, or rejection of the record depending on requirements.

---

## Script Reference

The complete `migration.py` script includes:

| Function | Purpose |
|----------|---------|
| `profile_data()` | Analyzes source data quality issues |
| `cleanse_data()` | Applies cleansing rules to fix issues |
| `transform_to_document()` | Maps CSV fields to MongoDB document structure |
| `load_to_mongodb()` | Loads transformed data to Atlas |
| `validate_migration()` | Performs post-migration validation |
| `main()` | Handles command-line arguments and orchestrates the pipeline |

---

## Lab 2 Complete! ✅
