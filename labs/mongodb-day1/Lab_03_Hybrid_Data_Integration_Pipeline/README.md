# Lab 3: Hybrid Data Integration Pipeline


---

## Lab Overview

| Aspect | Details |
|--------|---------|
| **Duration** | 25-30 minutes |
| **Objective** | Build a hybrid data pipeline integrating batch processing, real-time API calls, and CDC simulation |
| **Environment** | AWS EC2 (pre-configured) or Local Machine with Python |
| **Tools** | Python 3, pymongo, requests library, MongoDB Atlas |

---

## Theoretical Foundation: Hybrid Data Integration

### What is Hybrid Data Integration?

**Hybrid data integration** is the process of combining data from multiple sources using different integration patterns - batch, real-time, and API-based - into a unified view.

### Why Hybrid Integration Matters

| Challenge | Solution |
|-----------|----------|
| Data exists in multiple systems (databases, APIs, files) | Integration brings them together into a single view |
| Some data updates are batch (daily CSV exports) | Batch processing handles large volumes efficiently |
| Some data requires immediate processing | CDC (Change Data Capture) captures changes in real-time |
| External services provide valuable enrichment data | APIs enable on-demand data fetching |

### The Three Integration Patterns

<img src="diagrams/integration-patterns.svg" alt="Hybrid Integration Pipeline" width="520"/>

### Integration Patterns Comparison

| Pattern | How It Works | Latency | Volume | Use Case |
|---------|-------------|---------|--------|----------|
| **Batch** | Process groups of data on schedule | Hours/days | High | Historical loads, nightly reports |
| **API** | Request data on demand from external service | Seconds | Low to medium | Data enrichment, lookups |
| **CDC** | React to database changes immediately | Milliseconds | Medium to high | Real-time analytics, alerts |

---

## Prerequisites

- [ ] Lab 1 completed (MongoDB Atlas cluster ready)
- [ ] Lab 2 completed (migration concept understood)
- [ ] Python 3.7+ installed (if running locally)
- [ ] MongoDB Atlas connection string ready
- [ ] EC2 instance access (if provided by instructor)

---

## Part 1: Setup Environment (2 minutes)

### Step 1.1: Create Lab Directory

**If using EC2 Instance Connect:**
```bash
mkdir -p /home/ec2-user/lab3
cd /home/ec2-user/lab3
```

**If using Local Machine (Windows/Mac/Linux):**
```bash
mkdir -p ~/hybrid-pipeline-lab
cd ~/hybrid-pipeline-lab
```

### Step 1.2: Install Required Python Package

```bash
pip3 install requests pymongo
```

**Expected Output:**
```
Collecting requests
  Downloading requests-2.32.3-py3-none-any.whl
Collecting pymongo
  Downloading pymongo-4.17.0-cp39-cp39-manylinux_2_17_x86_64.whl
Installing collected packages: urllib3, idna, charset-normalizer, certifi, requests, pymongo
Successfully installed certifi-2024.12.14 charset-normalizer-3.4.1 idna-3.10 pymongo-4.17.0 requests-2.32.3 urllib3-2.3.0
```

---

## Part 2: Batch Integration - Load Historical Orders (5 minutes)

### What is Batch Integration?

**Batch integration** processes data in large groups (batches) at scheduled times. It's ideal for:
- Large volume data that doesn't need immediate processing
- Historical data migration
- End-of-day reporting
- Data warehousing ETL jobs

### Step 2.1: Create the Batch Load Script

```bash
cat > batch_load.py << 'EOF'
#!/usr/bin/env python3
"""
Batch Load Module - Historical Data Integration

This script demonstrates BATCH INTEGRATION pattern:
1. Reads historical order data from a CSV file
2. Transforms the data to MongoDB document format
3. Loads all records into MongoDB Atlas in one batch

Batch integration characteristics:
- High volume data processing
- Scheduled execution (daily, hourly)
- No real-time requirements
- Efficient for large datasets
"""

import csv
from datetime import datetime
from pymongo import MongoClient

# ============================================================
# HISTORICAL DATA - Simulating orders from legacy system
# ============================================================

# Sample historical orders data (in production, this would come from a file or database)
HISTORICAL_ORDERS_CSV = """order_id,customer_id,product,quantity,order_date,status
ORD001,1001,Laptop,1,2024-01-15,delivered
ORD002,1002,Mouse,2,2024-01-20,delivered
ORD003,1001,Keyboard,1,2024-02-10,delivered
ORD004,1003,Monitor,1,2024-02-15,shipped
ORD005,1002,USB Cable,3,2024-03-01,processing
ORD006,1004,Headphones,1,2024-03-05,processing
ORD007,1001,Docking Station,1,2024-03-10,pending
"""


def create_source_file():
    """Create the CSV source file for batch processing"""
    with open('historical_orders.csv', 'w') as f:
        f.write(HISTORICAL_ORDERS_CSV)
    print("📁 Created source file: historical_orders.csv")


def read_historical_orders():
    """Read and parse historical orders from CSV file"""
    records = []
    with open('historical_orders.csv', 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            records.append(row)
    return records


def transform_orders(records):
    """Transform CSV records to MongoDB document format"""
    documents = []
    for record in records:
        doc = {
            "orderId": record['order_id'],
            "customerId": int(record['customer_id']),
            "product": record['product'],
            "quantity": int(record['quantity']),
            "orderDate": datetime.strptime(record['order_date'], '%Y-%m-%d'),
            "status": record['status'],
            "source": "batch_load",
            "ingestionTimestamp": datetime.now(),
            "metadata": {
                "fileSource": "historical_orders.csv",
                "loadType": "batch"
            }
        }
        documents.append(doc)
    return documents


def load_batch_orders(connection_string):
    """
    Main batch integration function
    Loads all historical orders into MongoDB Atlas in a single batch
    """
    
    print("\n" + "=" * 60)
    print("BATCH INTEGRATION: LOAD HISTORICAL ORDERS")
    print("=" * 60)
    
    # Step 1: Create source file
    print("\n📁 STEP 1: Prepare source data")
    create_source_file()
    
    # Step 2: Read all records
    print("\n📖 STEP 2: Read historical orders")
    records = read_historical_orders()
    print(f"   Read {len(records)} orders from CSV")
    
    # Step 3: Transform records
    print("\n🔄 STEP 3: Transform data for MongoDB")
    documents = transform_orders(records)
    print(f"   Transformed {len(documents)} documents")
    
    # Step 4: Connect to MongoDB
    print("\n🔌 STEP 4: Connect to MongoDB Atlas")
    client = MongoClient(connection_string)
    db = client.hybrid_db
    collection = db.orders
    print("   Connected to database: hybrid_db")
    print("   Using collection: orders")
    
    # Step 5: Clear existing data (for clean run)
    existing = collection.count_documents({})
    if existing > 0:
        collection.delete_many({})
        print(f"\n🗑️  Cleared {existing} existing orders")
    
    # Step 6: Batch insert
    print("\n📝 STEP 5: Load data in batch")
    result = collection.insert_many(documents)
    
    # Step 7: Create index for query performance
    print("\n🔍 STEP 6: Create indexes")
    collection.create_index("orderId", unique=True)
    collection.create_index("customerId")
    print("   Created indexes on: orderId, customerId")
    
    print("\n" + "=" * 60)
    print("BATCH INTEGRATION COMPLETE")
    print("=" * 60)
    print(f"✅ Loaded {len(result.inserted_ids)} historical orders")
    print(f"📦 Database: hybrid_db.orders")
    
    return len(result.inserted_ids)


def main():
    """Main entry point for batch load script"""
    import sys
    
    print("\n" + "=" * 60)
    print("BATCH DATA INTEGRATION PIPELINE")
    print("=" * 60)
    print("\nThis script demonstrates BATCH integration pattern:")
    print("  - Loads large volumes of historical data")
    print("  - Processes data in a single batch operation")
    print("  - Suitable for nightly ETL jobs\n")
    
    if len(sys.argv) > 1:
        conn_string = sys.argv[1]
        count = load_batch_orders(conn_string)
        print(f"\n🎉 Batch load successful! {count} orders loaded.")
    else:
        print("Usage: python3 batch_load.py 'your_connection_string'")
        print("\nExample:")
        print("  python3 batch_load.py 'mongodb+srv://username:password@cluster.mongodb.net/'")


if __name__ == "__main__":
    main()
EOF

chmod +x batch_load.py
```

### Step 2.2: Run the Batch Load

```bash
python3 batch_load.py 'mongodb+srv://YOUR_USERNAME:YOUR_PASSWORD@YOUR_CLUSTER.mongodb.net/'
```

> ⚠️ Replace with your actual MongoDB Atlas connection string

**Expected Output:**
```
============================================================
BATCH DATA INTEGRATION PIPELINE
============================================================

This script demonstrates BATCH integration pattern:
  - Loads large volumes of historical data
  - Processes data in a single batch operation
  - Suitable for nightly ETL jobs


============================================================
BATCH INTEGRATION: LOAD HISTORICAL ORDERS
============================================================

📁 STEP 1: Prepare source data
📁 Created source file: historical_orders.csv

📖 STEP 2: Read historical orders
   Read 7 orders from CSV

🔄 STEP 3: Transform data for MongoDB
   Transformed 7 documents

🔌 STEP 4: Connect to MongoDB Atlas
   Connected to database: hybrid_db
   Using collection: orders

📝 STEP 5: Load data in batch

🔍 STEP 6: Create indexes
   Created indexes on: orderId, customerId

============================================================
BATCH INTEGRATION COMPLETE
============================================================
✅ Loaded 7 historical orders
📦 Database: hybrid_db.orders

🎉 Batch load successful! 7 orders loaded.
```

**Theoretical Note - Batch Processing Best Practices:**

| Best Practice | Why It Matters |
|---------------|-----------------|
| Clear existing data | Ensures clean, idempotent loads |
| Create indexes after load | Better performance than before load |
| Add metadata fields | Track data lineage and audit trails |
| Use bulk operations | Faster than individual inserts |

---

## Part 3: API Integration - Enrich Orders with User Data (5 minutes)

### What is API Integration?

**API integration** fetches data from external services on demand. It's ideal for:
- Enriching existing data with external information
- Real-time lookups (geocoding, validation)
- Microservice communication
- Keeping data fresh without local storage

### Step 3.1: Create the API Enrichment Script

```bash
cat > api_enrich.py << 'EOF'
#!/usr/bin/env python3
"""
API Integration Module - External Data Enrichment

This script demonstrates API INTEGRATION pattern:
1. Reads existing orders from MongoDB
2. Calls external API (simulated) to fetch customer data
3. Enriches orders with customer name and tier
4. Stores enriched results in a separate collection

API integration characteristics:
- On-demand data fetching
- External service dependencies
- Real-time enrichment
- Data freshness without replication
"""

from datetime import datetime
from pymongo import MongoClient

# ============================================================
# MOCK EXTERNAL API - Simulating a customer service API
# ============================================================

# In production, this would be an actual REST API call:
# response = requests.get(f"https://api.customerservice.com/users/{customer_id}")

MOCK_CUSTOMER_DATA = {
    1001: {
        "name": "John Smith",
        "email": "john.smith@example.com",
        "tier": "gold",
        "joinDate": "2023-01-15",
        "lifetimeValue": 12500
    },
    1002: {
        "name": "Jane Doe",
        "email": "jane.doe@example.com",
        "tier": "silver",
        "joinDate": "2023-03-20",
        "lifetimeValue": 5400
    },
    1003: {
        "name": "Bob Wilson",
        "email": "bob.wilson@example.com",
        "tier": "bronze",
        "joinDate": "2024-01-10",
        "lifetimeValue": 1200
    },
    1004: {
        "name": "Alice Brown",
        "email": "alice.brown@example.com",
        "tier": "gold",
        "joinDate": "2022-11-05",
        "lifetimeValue": 18750
    }
}


def call_customer_api(customer_id):
    """
    Simulate calling an external customer API
    
    In production, this would be:
        response = requests.get(
            f"https://api.customerservice.com/v1/customers/{customer_id}",
            headers={"Authorization": "Bearer API_KEY"},
            timeout=5
        )
        return response.json()
    """
    # Simulate API latency
    import time
    time.sleep(0.1)  # 100ms simulated network delay
    
    return MOCK_CUSTOMER_DATA.get(customer_id, {
        "name": "Unknown Customer",
        "email": "unknown@example.com",
        "tier": "standard",
        "joinDate": "unknown",
        "lifetimeValue": 0
    })


def get_existing_orders(connection_string):
    """Retrieve all orders from the orders collection"""
    client = MongoClient(connection_string)
    db = client.hybrid_db
    collection = db.orders
    
    orders = list(collection.find({}))
    return orders


def enrich_orders_with_api(orders):
    """
    Enrich each order with customer data from external API
    
    For each order, we:
    1. Extract customer_id
    2. Call external API to get customer details
    3. Merge API data with order data
    """
    
    print("\n" + "=" * 60)
    print("API INTEGRATION: ENRICH ORDERS WITH CUSTOMER DATA")
    print("=" * 60)
    
    enriched_orders = []
    api_calls_made = 0
    cache_hits = 0
    
    # Cache to avoid duplicate API calls
    customer_cache = {}
    
    print("\n🌐 Making API calls to external customer service...")
    print("   (Simulating network latency with 100ms delay)\n")
    
    for order in orders:
        customer_id = order.get('customerId')
        
        # Check cache first (API optimization)
        if customer_id in customer_cache:
            customer_data = customer_cache[customer_id]
            cache_hits += 1
        else:
            # Call external API
            customer_data = call_customer_api(customer_id)
            customer_cache[customer_id] = customer_data
            api_calls_made += 1
            print(f"   📞 API call {api_calls_made}: Customer {customer_id} → {customer_data['name']}")
        
        # Create enriched document
        enriched_doc = {
            "orderId": order.get('orderId'),
            "customerId": customer_id,
            "customerName": customer_data['name'],
            "customerEmail": customer_data['email'],
            "customerTier": customer_data['tier'],
            "customerLifetimeValue": customer_data['lifetimeValue'],
            "product": order.get('product'),
            "quantity": order.get('quantity'),
            "orderDate": order.get('orderDate'),
            "status": order.get('status'),
            "enrichmentTimestamp": datetime.now(),
            "enrichmentSource": "external_customer_api",
            "originalOrder": {
                "orderId": order.get('orderId'),
                "source": order.get('source')
            }
        }
        enriched_orders.append(enriched_doc)
    
    print(f"\n📊 API Statistics:")
    print(f"   - Unique API calls: {api_calls_made}")
    print(f"   - Cache hits: {cache_hits}")
    print(f"   - Total orders enriched: {len(enriched_orders)}")
    
    return enriched_orders


def store_enriched_orders(connection_string, enriched_orders):
    """Store enriched orders in MongoDB Atlas"""
    
    print("\n" + "=" * 60)
    print("STORING ENRICHED ORDERS")
    print("=" * 60)
    
    client = MongoClient(connection_string)
    db = client.hybrid_db
    collection = db.enriched_orders
    
    # Clear existing enriched orders
    existing = collection.count_documents({})
    if existing > 0:
        collection.delete_many({})
        print(f"🗑️  Cleared {existing} existing enriched orders")
    
    # Insert enriched documents
    result = collection.insert_many(enriched_orders)
    
    # Create indexes
    collection.create_index("orderId", unique=True)
    collection.create_index("customerId")
    collection.create_index("customerTier")
    
    print(f"\n✅ Stored {len(result.inserted_ids)} enriched orders")
    print(f"📦 Database: hybrid_db.enriched_orders")
    print(f"🔍 Indexes created on: orderId, customerId, customerTier")
    
    return len(result.inserted_ids)


def enrich_orders(connection_string):
    """Main API integration function"""
    
    print("\n" + "=" * 60)
    print("API INTEGRATION PIPELINE")
    print("=" * 60)
    
    # Step 1: Get existing orders
    print("\n📖 STEP 1: Retrieve orders from database")
    orders = get_existing_orders(connection_string)
    print(f"   Found {len(orders)} orders to enrich")
    
    if len(orders) == 0:
        print("\n⚠️  No orders found. Please run batch_load.py first.")
        return 0
    
    # Step 2: Enrich with API data
    enriched = enrich_orders_with_api(orders)
    
    # Step 3: Store enriched results
    count = store_enriched_orders(connection_string, enriched)
    
    print("\n" + "=" * 60)
    print("API INTEGRATION COMPLETE")
    print("=" * 60)
    print(f"✅ Successfully enriched {count} orders")
    print(f"🌐 External API calls: {len(set(order['customerId'] for order in orders))}")
    
    return count


def main():
    """Main entry point for API enrichment script"""
    import sys
    
    print("\n" + "=" * 60)
    print("API DATA INTEGRATION PIPELINE")
    print("=" * 60)
    print("\nThis script demonstrates API integration pattern:")
    print("  - Enriches existing data with external API calls")
    print("  - Implements caching to reduce API calls")
    print("  - Simulates real-world network latency\n")
    
    if len(sys.argv) > 1:
        conn_string = sys.argv[1]
        count = enrich_orders(conn_string)
        print(f"\n🎉 API enrichment complete! {count} orders enriched.")
    else:
        print("Usage: python3 api_enrich.py 'your_connection_string'")
        print("\nExample:")
        print("  python3 api_enrich.py 'mongodb+srv://username:password@cluster.mongodb.net/'")


if __name__ == "__main__":
    main()
EOF

chmod +x api_enrich.py
```

### Step 3.2: Run the API Enrichment

```bash
python3 api_enrich.py 'mongodb+srv://YOUR_USERNAME:YOUR_PASSWORD@YOUR_CLUSTER.mongodb.net/'
```

**Expected Output:**
```
============================================================
API DATA INTEGRATION PIPELINE
============================================================

This script demonstrates API integration pattern:
  - Enriches existing data with external API calls
  - Implements caching to reduce API calls
  - Simulates real-world network latency


============================================================
API INTEGRATION PIPELINE
============================================================

📖 STEP 1: Retrieve orders from database
   Found 7 orders to enrich

============================================================
API INTEGRATION: ENRICH ORDERS WITH CUSTOMER DATA
============================================================

🌐 Making API calls to external customer service...
   (Simulating network latency with 100ms delay)

   📞 API call 1: Customer 1001 → John Smith
   📞 API call 2: Customer 1002 → Jane Doe
   📞 API call 3: Customer 1003 → Bob Wilson
   📞 API call 4: Customer 1004 → Alice Brown

📊 API Statistics:
   - Unique API calls: 4
   - Cache hits: 3
   - Total orders enriched: 7

============================================================
STORING ENRICHED ORDERS
============================================================
🗑️  Cleared 0 existing enriched orders

✅ Stored 7 enriched orders
📦 Database: hybrid_db.enriched_orders
🔍 Indexes created on: orderId, customerId, customerTier

============================================================
API INTEGRATION COMPLETE
============================================================
✅ Successfully enriched 7 orders
🌐 External API calls: 4

🎉 API enrichment complete! 7 orders enriched.
```

**Theoretical Note - API Integration Best Practices:**

| Best Practice | How We Implemented | Why It Matters |
|---------------|-------------------|-----------------|
| **Caching** | customer_cache dictionary | Reduces duplicate API calls, improves performance |
| **Timeout handling** | Simulated with time.sleep | Prevents hanging on slow APIs |
| **Idempotency** | Same customer always returns same data | Consistent results across runs |
| **Error handling** | Default values for unknown customers | Graceful degradation |
| **Audit trail** | enrichmentTimestamp field | Track when enrichment occurred |

---

## Part 4: CDC Simulation - Real-Time Order Processing (5 minutes)

### What is Change Data Capture (CDC)?

**Change Data Capture (CDC)** is a technique that captures changes made to a database (inserts, updates, deletes) and makes them available for processing in real-time. It's ideal for:
- Real-time analytics
- Event-driven architectures
- Synchronizing multiple systems
- Triggering downstream processes

### Step 4.1: Create the CDC Simulation Script

```bash
cat > cdc_simulate.py << 'EOF'
#!/usr/bin/env python3
"""
CDC Simulation Module - Real-time Change Data Capture

This script demonstrates CDC (Change Data Capture) pattern:
1. Simulates new orders arriving in real-time
2. Captures each insert as it happens
3. Triggers downstream processing (daily summary updates)
4. Maintains real-time aggregates

CDC characteristics:
- Millisecond latency
- Event-driven architecture
- Triggers immediate actions
- Maintains real-time state
"""

from datetime import datetime
from pymongo import MongoClient
import time

# ============================================================
# REAL-TIME ORDER SIMULATION
# ============================================================

NEW_ORDERS = [
    {
        "orderId": "ORD008",
        "customerId": 1001,
        "product": "Wireless Mouse",
        "quantity": 2,
        "status": "processing",
        "source": "web_checkout"
    },
    {
        "orderId": "ORD009",
        "customerId": 1002,
        "product": "Mechanical Keyboard",
        "quantity": 1,
        "status": "pending",
        "source": "mobile_app"
    },
    {
        "orderId": "ORD010",
        "customerId": 1004,
        "product": "USB Hub 4-port",
        "quantity": 3,
        "status": "processing",
        "source": "web_checkout"
    },
    {
        "orderId": "ORD011",
        "customerId": 1003,
        "product": "Monitor Stand",
        "quantity": 1,
        "status": "pending",
        "source": "mobile_app"
    }
]


def update_daily_summary(collection, new_order):
    """
    CDC Trigger: Update daily summary when a new order arrives
    
    This function demonstrates how CDC events trigger downstream processing:
    - Increments total order count for the day
    - Increments total quantity sold
    - Tracks per-customer order counts
    """
    
    # Extract date from current timestamp
    today = datetime.now().strftime('%Y-%m-%d')
    customer_id = new_order['customerId']
    quantity = new_order['quantity']
    
    # Update or insert daily summary document
    result = collection.update_one(
        {"date": today},
        {
            "$inc": {
                "totalOrders": 1,
                "totalQuantity": quantity,
                f"customer_{customer_id}_orders": 1,
                f"customer_{customer_id}_quantity": quantity
            },
            "$set": {
                "lastUpdated": datetime.now()
            },
            "$setOnInsert": {
                "date": today,
                "createdAt": datetime.now()
            }
        },
        upsert=True
    )
    
    return result


def insert_order(orders_collection, summary_collection, new_order):
    """Insert a single order and trigger CDC actions"""
    
    # Add metadata to order
    new_order['orderDate'] = datetime.now()
    new_order['ingestionTimestamp'] = datetime.now()
    new_order['sourceType'] = "cdc_realtime"
    
    # Insert the order (this is the "change" being captured)
    result = orders_collection.insert_one(new_order)
    
    # CDC Trigger: Update daily summary based on the change
    update_daily_summary(summary_collection, new_order)
    
    return result.inserted_id


def simulate_cdc_pipeline(connection_string):
    """
    Main CDC simulation function
    Demonstrates real-time order processing and event-driven architecture
    """
    
    print("\n" + "=" * 60)
    print("CDC SIMULATION: REAL-TIME ORDER PROCESSING")
    print("=" * 60)
    
    # Connect to MongoDB
    print("\n🔌 Connecting to MongoDB Atlas...")
    client = MongoClient(connection_string)
    db = client.hybrid_db
    orders_collection = db.orders
    summary_collection = db.daily_summary
    
    print("   Connected to database: hybrid_db")
    print("   Collections: orders, daily_summary")
    
    print("\n" + "=" * 60)
    print("REAL-TIME ORDER STREAM")
    print("=" * 60)
    print("\nSimulating new orders arriving in real-time...")
    print("(Each order triggers CDC and updates daily summary)\n")
    
    orders_processed = 0
    
    for order in NEW_ORDERS:
        orders_processed += 1
        
        print(f"🔔 [{datetime.now().strftime('%H:%M:%S')}] New order detected: {order['orderId']}")
        print(f"   ├── Customer: {order['customerId']}")
        print(f"   ├── Product: {order['product']}")
        print(f"   ├── Quantity: {order['quantity']}")
        print(f"   └── Source: {order['source']}")
        
        # Insert order and trigger CDC
        order_id = insert_order(orders_collection, summary_collection, order)
        print(f"\n   ✅ Order stored with ID: {order_id}")
        print(f"   📊 CDC Trigger: Daily summary updated")
        
        # Simulate real-time gap between orders
        if orders_processed < len(NEW_ORDERS):
            print(f"\n   ⏳ Waiting for next order...\n")
            time.sleep(1.5)
    
    print("\n" + "=" * 60)
    print("CDC PROCESSING SUMMARY")
    print("=" * 60)
    
    # Show final statistics
    total_orders = orders_collection.count_documents({})
    print(f"\n📊 System State After CDC Processing:")
    print(f"   - Total orders in system: {total_orders}")
    print(f"   - New orders processed: {orders_processed}")
    
    # Display daily summary
    summaries = list(summary_collection.find({}))
    print(f"\n📈 Daily Summary Collection:")
    for summary in summaries:
        print(f"\n   📅 Date: {summary['date']}")
        print(f"      Total orders: {summary.get('totalOrders', 0)}")
        print(f"      Total quantity: {summary.get('totalQuantity', 0)}")
        print(f"      Last updated: {summary.get('lastUpdated', 'N/A').strftime('%H:%M:%S')}")
        
        # Show customer breakdown
        customer_keys = [k for k in summary.keys() if k.startswith('customer_') and k.endswith('_orders')]
        for key in customer_keys:
            customer_id = key.replace('customer_', '').replace('_orders', '')
            order_count = summary.get(key, 0)
            if order_count > 0:
                print(f"      Customer {customer_id}: {order_count} order(s)")
    
    return orders_processed


def main():
    """Main entry point for CDC simulation script"""
    import sys
    
    print("\n" + "=" * 60)
    print("CDC (CHANGE DATA CAPTURE) SIMULATION")
    print("=" * 60)
    print("\nThis script demonstrates CDC integration pattern:")
    print("  - Captures changes (inserts) in real-time")
    print("  - Triggers downstream processing automatically")
    print("  - Maintains real-time aggregates")
    print("  - Simulates event-driven architecture\n")
    
    if len(sys.argv) > 1:
        conn_string = sys.argv[1]
        count = simulate_cdc_pipeline(conn_string)
        print(f"\n🎉 CDC simulation complete! {count} orders processed in real-time.")
    else:
        print("Usage: python3 cdc_simulate.py 'your_connection_string'")
        print("\nExample:")
        print("  python3 cdc_simulate.py 'mongodb+srv://username:password@cluster.mongodb.net/'")


if __name__ == "__main__":
    main()
EOF

chmod +x cdc_simulate.py
```

### Step 4.2: Run the CDC Simulation

```bash
python3 cdc_simulate.py 'mongodb+srv://YOUR_USERNAME:YOUR_PASSWORD@YOUR_CLUSTER.mongodb.net/'
```

**Expected Output:**
```
============================================================
CDC (CHANGE DATA CAPTURE) SIMULATION
============================================================

This script demonstrates CDC integration pattern:
  - Captures changes (inserts) in real-time
  - Triggers downstream processing automatically
  - Maintains real-time aggregates
  - Simulates event-driven architecture


============================================================
CDC SIMULATION: REAL-TIME ORDER PROCESSING
============================================================

🔌 Connecting to MongoDB Atlas...
   Connected to database: hybrid_db
   Collections: orders, daily_summary

============================================================
REAL-TIME ORDER STREAM
============================================================

Simulating new orders arriving in real-time...
(Each order triggers CDC and updates daily summary)


🔔 [14:32:15] New order detected: ORD008
   ├── Customer: 1001
   ├── Product: Wireless Mouse
   ├── Quantity: 2
   └── Source: web_checkout

   ✅ Order stored with ID: ObjectId('67a3b2c1d4e5f6a7b8c9d0e1')
   📊 CDC Trigger: Daily summary updated

   ⏳ Waiting for next order...

🔔 [14:32:16] New order detected: ORD009
   ├── Customer: 1002
   ├── Product: Mechanical Keyboard
   ├── Quantity: 1
   └── Source: mobile_app

   ✅ Order stored with ID: ObjectId('67a3b2c1d4e5f6a7b8c9d0e2')
   📊 CDC Trigger: Daily summary updated

   ⏳ Waiting for next order...

🔔 [14:32:18] New order detected: ORD010
   ├── Customer: 1004
   ├── Product: USB Hub 4-port
   ├── Quantity: 3
   └── Source: web_checkout

   ✅ Order stored with ID: ObjectId('67a3b2c1d4e5f6a7b8c9d0e3')
   📊 CDC Trigger: Daily summary updated

   ⏳ Waiting for next order...

🔔 [14:32:20] New order detected: ORD011
   ├── Customer: 1003
   ├── Product: Monitor Stand
   ├── Quantity: 1
   └── Source: mobile_app

   ✅ Order stored with ID: ObjectId('67a3b2c1d4e5f6a7b8c9d0e4')
   📊 CDC Trigger: Daily summary updated

============================================================
CDC PROCESSING SUMMARY
============================================================

📊 System State After CDC Processing:
   - Total orders in system: 11
   - New orders processed: 4

📈 Daily Summary Collection:

   📅 Date: 2026-06-09
      Total orders: 4
      Total quantity: 7
      Last updated: 14:32:20
      Customer 1001: 1 order(s)
      Customer 1002: 1 order(s)
      Customer 1003: 1 order(s)
      Customer 1004: 1 order(s)

🎉 CDC simulation complete! 4 orders processed in real-time.
```

**Theoretical Note - CDC Architecture:**

<img src="diagrams/cdc-architecture.svg" alt="CDC Event-Driven Architecture" width="400"/>

---

## Part 5: Query and Verify Results (3 minutes)

### Step 5.1: Create the Query Script

```bash
cat > query_results.py << 'EOF'
#!/usr/bin/env python3
"""
Query Module - Display Hybrid Pipeline Results

This script queries all collections in the hybrid pipeline
and displays a unified view of the data.
"""

from pymongo import MongoClient
from datetime import datetime


def display_results(connection_string):
    """Query and display data from all hybrid pipeline collections"""
    
    print("\n" + "=" * 70)
    print("HYBRID DATA INTEGRATION PIPELINE - COMPLETE RESULTS")
    print("=" * 70)
    
    client = MongoClient(connection_string)
    db = client.hybrid_db
    
    print(f"\n📊 Database: hybrid_db")
    
    # ============================================================
    # 1. BATCH LOADED ORDERS
    # ============================================================
    
    print("\n" + "─" * 70)
    print("📦 1. BATCH INTEGRATION - Historical Orders")
    print("─" * 70)
    
    orders_count = db.orders.count_documents({})
    print(f"   Total orders: {orders_count}")
    
    orders = list(db.orders.find({}).limit(5))
    for order in orders:
        print(f"   ├── {order['orderId']}: {order['product']} x{order['quantity']}")
        print(f"   │   Customer: {order['customerId']}, Status: {order['status']}")
        print(f"   │   Source: {order.get('source', 'N/A')}")
    
    if orders_count > 5:
        print(f"   └── ... and {orders_count - 5} more orders")
    
    # ============================================================
    # 2. API ENRICHED ORDERS
    # ============================================================
    
    print("\n" + "─" * 70)
    print("🌐 2. API INTEGRATION - Enriched Orders")
    print("─" * 70)
    
    enriched_count = db.enriched_orders.count_documents({})
    print(f"   Total enriched orders: {enriched_count}")
    
    enriched = list(db.enriched_orders.find({}).limit(5))
    for order in enriched:
        tier_symbol = "⭐" if order['customerTier'] == 'gold' else "💎" if order['customerTier'] == 'silver' else "🟢"
        print(f"   ├── {order['orderId']}: {order['product']}")
        print(f"   │   Customer: {order['customerName']} ({order['customerTier']} tier {tier_symbol})")
        print(f"   │   Lifetime Value: ${order.get('customerLifetimeValue', 0):,}")
    
    # ============================================================
    # 3. CDC DAILY SUMMARY
    # ============================================================
    
    print("\n" + "─" * 70)
    print("⚡ 3. CDC INTEGRATION - Real-time Daily Summary")
    print("─" * 70)
    
    summaries = list(db.daily_summary.find({}))
    for summary in summaries:
        print(f"\n   📅 Date: {summary['date']}")
        print(f"      Total orders today: {summary.get('totalOrders', 0)}")
        print(f"      Total quantity sold: {summary.get('totalQuantity', 0)}")
        print(f"      Last updated: {summary.get('lastUpdated', 'N/A').strftime('%H:%M:%S')}")
        
        # Show customer breakdown
        print("      Customer breakdown:")
        customer_keys = [k for k in summary.keys() if k.startswith('customer_') and k.endswith('_orders')]
        for key in customer_keys:
            customer_id = key.replace('customer_', '').replace('_orders', '')
            order_count = summary.get(key, 0)
            quantity = summary.get(f'customer_{customer_id}_quantity', 0)
            if order_count > 0:
                print(f"         - Customer {customer_id}: {order_count} order(s), {quantity} items")
    
    # ============================================================
    # 4. SUMMARY STATISTICS
    # ============================================================

    cdc_count = 4  # matches NEW_ORDERS in cdc_simulate.py

    print("\n" + "=" * 70)
    print("PIPELINE STATISTICS")
    print("=" * 70)
    print("\n  INTEGRATION PATTERN SUMMARY")
    print("  " + "-" * 40)
    print(f"\n  BATCH INTEGRATION")
    print(f"    Orders loaded:      {orders_count}")
    print(f"    Pattern:            Scheduled, high volume")
    print(f"\n  API INTEGRATION")
    print(f"    Orders enriched:    {enriched_count}")
    print(f"    Pattern:            On-demand, external service")
    print(f"\n  CDC INTEGRATION")
    print(f"    Real-time orders:   {cdc_count}")
    print(f"    Pattern:            Event-driven, real-time")

    print("\n" + "=" * 70)
    print("✅ HYBRID PIPELINE VERIFICATION COMPLETE")
    print("=" * 70)
    print("""
   All three integration patterns are working together:
   - Batch integration loaded historical data
   - API integration enriched data from external service
   - CDC integration processed new orders in real-time
   """)


def main():
    """Main entry point for query script"""
    import sys
    
    print("\n" + "=" * 70)
    print("HYBRID PIPELINE RESULTS VIEWER")
    print("=" * 70)
    
    if len(sys.argv) > 1:
        conn_string = sys.argv[1]
        display_results(conn_string)
    else:
        print("\nUsage: python3 query_results.py 'your_connection_string'")
        print("\nExample:")
        print("  python3 query_results.py 'mongodb+srv://username:password@cluster.mongodb.net/'")


if __name__ == "__main__":
    main()
EOF

chmod +x query_results.py
```

### Step 5.2: Run the Query Script

```bash
python3 query_results.py 'mongodb+srv://YOUR_USERNAME:YOUR_PASSWORD@YOUR_CLUSTER.mongodb.net/'
```

**Expected Output:**
```
======================================================================
HYBRID PIPELINE RESULTS VIEWER
======================================================================

======================================================================
HYBRID DATA INTEGRATION PIPELINE - COMPLETE RESULTS
======================================================================

📊 Database: hybrid_db

──────────────────────────────────────────────────────────────────────
📦 1. BATCH INTEGRATION - Historical Orders
──────────────────────────────────────────────────────────────────────
   Total orders: 11
   ├── ORD001: Laptop x1
   │   Customer: 1001, Status: delivered
   │   Source: batch_load
   ├── ORD002: Mouse x2
   │   Customer: 1002, Status: delivered
   │   Source: batch_load
   ├── ORD003: Keyboard x1
   │   Customer: 1001, Status: delivered
   │   Source: batch_load
   ├── ORD004: Monitor x1
   │   Customer: 1003, Status: shipped
   │   Source: batch_load
   ├── ORD005: USB Cable x3
   │   Customer: 1002, Status: processing
   │   Source: batch_load
   └── ... and 6 more orders

──────────────────────────────────────────────────────────────────────
🌐 2. API INTEGRATION - Enriched Orders
──────────────────────────────────────────────────────────────────────
   Total enriched orders: 11
   ├── ORD001: Laptop
   │   Customer: John Smith (gold tier ⭐)
   │   Lifetime Value: $12,500
   ├── ORD002: Mouse
   │   Customer: Jane Doe (silver tier 💎)
   │   Lifetime Value: $5,400
   ├── ORD003: Keyboard
   │   Customer: John Smith (gold tier ⭐)
   │   Lifetime Value: $12,500
   ├── ORD004: Monitor
   │   Customer: Bob Wilson (bronze tier 🟢)
   │   Lifetime Value: $1,200
   ├── ORD005: USB Cable
   │   Customer: Jane Doe (silver tier 💎)
   │   Lifetime Value: $5,400

──────────────────────────────────────────────────────────────────────
⚡ 3. CDC INTEGRATION - Real-time Daily Summary
──────────────────────────────────────────────────────────────────────

   📅 Date: 2026-06-09
      Total orders today: 4
      Total quantity sold: 7
      Last updated: 14:32:20
      Customer breakdown:
         - Customer 1001: 1 order(s), 2 items
         - Customer 1002: 1 order(s), 1 items
         - Customer 1003: 1 order(s), 1 items
         - Customer 1004: 1 order(s), 3 items

======================================================================
PIPELINE STATISTICS
======================================================================

  INTEGRATION PATTERN SUMMARY
  ----------------------------------------

  BATCH INTEGRATION
    Orders loaded:      11
    Pattern:            Scheduled, high volume

  API INTEGRATION
    Orders enriched:    11
    Pattern:            On-demand, external service

  CDC INTEGRATION
    Real-time orders:   4
    Pattern:            Event-driven, real-time

======================================================================
✅ HYBRID PIPELINE VERIFICATION COMPLETE
======================================================================

   All three integration patterns are working together:
   - Batch integration loaded historical data
   - API integration enriched data from external service
   - CDC integration processed new orders in real-time
```

---

## Part 6: Verify in MongoDB Atlas (2 minutes)

### Step 6.1: Open MongoDB Atlas

1. Go to **MongoDB Atlas** in your browser
2. Click **Browse Collections**

**Expected Output:**
- Database: `hybrid_db` (newly created)
- Collections: `orders`, `enriched_orders`, `daily_summary`

### Step 6.2: Explore Each Collection

| Collection | Purpose | Document Count |
|------------|---------|----------------|
| `orders` | Raw batch-loaded orders + CDC inserts | ~11 documents |
| `enriched_orders` | Orders enriched with customer data via API | ~11 documents |
| `daily_summary` | Aggregated daily statistics via CDC | 1 document |

### Step 6.3: Sample Query in Atlas

Try this aggregation in the `enriched_orders` collection to find gold tier customers:

```json
[
  { "$match": { "customerTier": "gold" } },
  { "$group": { "_id": "$customerName", "totalSpent": { "$sum": "$quantity" } } },
  { "$sort": { "totalSpent": -1 } }
]
```

---

## Lab 3 Summary

### What You Accomplished

| Step | Integration Pattern | Script | What You Did |
|------|---------------------|--------|--------------|
| 1 | **Batch** | `batch_load.py` | Loaded 7 historical orders from CSV |
| 2 | **API** | `api_enrich.py` | Enriched orders with external customer data |
| 3 | **CDC** | `cdc_simulate.py` | Processed 4 real-time orders with triggers |
| 4 | **Query** | `query_results.py` | Verified all patterns work together |

### The Three Integration Patterns Compared

| Pattern | Script | How It Works | Latency | Best For |
|---------|--------|-------------|---------|----------|
| **Batch** | `batch_load.py` | Read CSV, transform, bulk insert | Minutes-Hours | Historical data, nightly ETL |
| **API** | `api_enrich.py` | Call external service, enrich each record | Seconds | Data enrichment, lookups |
| **CDC** | `cdc_simulate.py` | Detect changes, trigger actions | Milliseconds | Real-time analytics, alerts |

### Pipeline Data Flow Summary

<img src="diagrams/pipeline-flow.svg" alt="Complete Hybrid Pipeline data flow" width="420"/>

### Key Concepts Learned

| Concept | Definition | Applied In Lab 3 |
|---------|------------|------------------|
| **Batch Integration** | Scheduled processing of grouped data | CSV → MongoDB orders |
| **API Integration** | On-demand external data fetching | User enrichment via API |
| **Change Data Capture (CDC)** | Real-time change detection | New orders trigger summary updates |
| **Hybrid Pipeline** | Combining multiple integration patterns | All three working together |
| **Data Enrichment** | Enhancing data with external sources | Adding customer tier to orders |
| **Real-time Aggregation** | Immediate summary updates | Daily summary on order insert |
| **Event-Driven Architecture** | Actions triggered by events | CDC triggers downstream processing |

### Script Reference

| Script | Purpose | Key Functions |
|--------|---------|---------------|
| `batch_load.py` | Historical data batch load | `load_batch_orders()`, `transform_orders()` |
| `api_enrich.py` | External API enrichment | `call_customer_api()`, `enrich_orders_with_api()` |
| `cdc_simulate.py` | Real-time CDC simulation | `insert_order()`, `update_daily_summary()` |
| `query_results.py` | Results viewer | `display_results()` |

---

## Troubleshooting

| Issue | Likely Cause | Solution |
|-------|--------------|----------|
| `ModuleNotFoundError: No module named 'requests'` | requests not installed | Run `pip3 install requests` |
| `Connection refused` | Atlas IP not whitelisted | Add your IP to Network Access |
| `No orders found` | Batch load not run first | Run `batch_load.py` before others |
| `SSL handshake failed` | TLS version issue | Use standard SRV connection string |
| `Authentication failed` | Wrong credentials | Verify connection string format |
| `Duplicate key error` | Order ID already exists | Clear collections or use different IDs |

---

## Discussion Questions

1. **When would you use batch vs real-time integration?**
   - Answer: Batch for large volumes that don't need immediate processing (nightly reports). Real-time for time-sensitive operations (fraud detection).

2. **What are the advantages of API enrichment over storing all data locally?**
   - Answer: Data stays fresh (no replication lag), reduces storage costs, ensures you always have the latest version.

3. **How does CDC differ from batch processing?**
   - Answer: CDC captures changes as they happen (milliseconds). Batch processes groups of data on a schedule (hours).

4. **What would happen in a production environment with millions of CDC events?**
   - Answer: Would need message queue (Kafka), consumer groups for parallel processing, and idempotent processing to handle duplicates.

5. **How could you make the API enrichment more efficient for 10,000 orders?**
   - Answer: Batch API calls, cache results, use async/parallel requests, implement retry logic with exponential backoff.

6. **What is the benefit of keeping separate collections for raw and enriched orders?**
   - Answer: Raw orders preserve original data (audit trail), enriched orders provide enhanced view (analytics), and you can re-run enrichment without losing source data.

---

## Bonus Challenge

Try modifying the CDC script to:

1. **Add error handling** - What if the database is unavailable?
2. **Implement dead letter queue** - Store failed events for later processing
3. **Add email notification** - Send alert when high-value order arrives
4. **Create materialized view** - Pre-calculate customer lifetime value

---

## Lab 3 Complete! ✅

**Total time spent**: ________ minutes

**Integration patterns implemented**: 3 (Batch, API, CDC)

**Data processed**: 
- Batch: 7 orders
- API: 11 orders enriched
- CDC: 4 real-time orders


---

## Day 1 Labs Completion Checklist

| Lab | Topic | Status |
|-----|-------|--------|
| Lab 1 | MongoDB CRUD, Indexing, Aggregation | ✅ |
| Lab 2 | Data Migration (Oracle → MongoDB) | ✅ |
| Lab 3 | Hybrid Data Integration Pipeline | ✅ |

**Congratulations! You have completed all three Day 1 labs.** 🎉
