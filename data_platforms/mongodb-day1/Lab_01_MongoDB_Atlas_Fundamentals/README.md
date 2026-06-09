# Lab 1: MongoDB Atlas - CRUD, Indexing & Aggregation

## Complete Student Lab Guide

---

## Lab Overview

| Aspect | Details |
|--------|---------|
| **Duration** | 20-25 minutes |
| **Objective** | Create a MongoDB Atlas cluster, perform CRUD operations, create indexes, and build aggregation pipelines |
| **Tools needed** | Web browser only |
| **Cost** | Free (no credit card required) |

---

## Prerequisites

- [ ] Email address (for Atlas account)
- [ ] Internet connection
- [ ] Web browser (Chrome/Firefox/Edge/Safari)

---

## Part 1: Create MongoDB Atlas Account & Cluster (5 minutes)

### Step 1.1: Sign Up for MongoDB Atlas

1. Go to [https://www.mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)

2. Click **"Try Free"** or **"Start Free"**

3. Enter your information:
   - Email address
   - Password
   - Or sign up with Google/GitHub

> ⚠️ **Important**: You can skip the credit card step. The free tier (M0) does not require payment information.

### Step 1.2: Create Your Free Cluster

1. After logging in, you'll see the **"Create a Cluster"** screen

2. Select the **FREE tier option (M0)** - Shared RAM, 512 MB storage

3. Choose your preferred cloud provider:
   - AWS (recommended)
   - GCP
   - Azure

4. Select a region close to your location

5. Name your cluster: `Lab1-Cluster`

6. Click **"Create Cluster"**

> ⏱️ **Wait time**: Cluster creation takes 3-5 minutes. You'll see a green "Active" status when ready.

### Step 1.3: Load Sample Dataset

1. Once your cluster is active, click **"Browse Collections"**

2. Click **"Load Sample Dataset"** button

3. Confirm the action

4. Wait 1-2 minutes for the data to load

> 📚 **What you're loading**: The `sample_mflix` database contains ~23,000+ movie documents from the Mflix movie database.

5. Verify you see the following databases:
   - `sample_mflix`
   - `sample_airbnb`
   - `sample_supplies`
   - Other sample databases

---

## Part 2: CRUD Operations (5 minutes)

### Step 2.1: INSERT - Add a New Document

1. Navigate to: `sample_mflix` → `movies` collection

2. Click **"Insert Document"**

3. Paste the following document:

```json
{
  "title": "Corporate Training 101",
  "year": 2026,
  "runtime": 90,
  "plot": "A team of professionals learns MongoDB basics in this exciting corporate adventure",
  "type": "movie",
  "genres": ["Educational", "Comedy"],
  "awards": {
    "wins": 0,
    "nominations": 0
  },
  "rated": "PG"
}
```

4. Click **"Insert"**

**✅ Expected outcome**: Success message and your new document appears in the collection.

---

### Step 2.2: READ - Find Documents with Filter

1. In the `movies` collection, locate the **filter/query bar**

2. Type or paste this filter:

```json
{"year": {"$gt": 2010}}
```

3. Click the **"Find"** button (or press **Enter**)

**✅ Expected outcome**: Only movies released after 2010 (year > 2010) are displayed.

> 💡 **Note**: `$gt` means "greater than". Year 2010 is NOT included. Use `$gte` (greater than or equal) to include 2010.

**Challenge**: Try this filter instead:
```json
{"year": {"$gte": 2010, "$lte": 2020}}
```

---

### Step 2.3: UPDATE - Modify a Document

1. Navigate to: `sample_mflix` → `comments` collection

2. Find any comment (scroll through the list)

3. Click the **"Edit"** button (pencil icon) next to a comment

4. Update the `name` field to: `"Atlas Training User"`

5. Click **"Update"**

**✅ Expected outcome**: The comment now shows the updated name.

> 💡 **Alternative using filter**: You can also update by:
> - Clicking **"Filter"** and finding a specific comment by `_id`
> - Using the update modal to modify fields

---

### Step 2.4: DELETE - Remove a Document

1. Navigate to: `sample_mflix` → `comments` collection

2. Find a test comment (preferably one you inserted earlier)

3. Click the **trash icon** 🗑️ next to the document

4. Confirm deletion

**✅ Expected outcome**: The document is removed from the collection.

> ⚠️ **Warning**: Deleted documents cannot be recovered. In production, consider soft deletes (adding a `isDeleted` flag) instead of permanent deletion.

---

## Part 3: Indexing & Performance (5 minutes)

### Step 3.1: Create an Index

Indexes improve query performance by allowing MongoDB to find documents without scanning the entire collection.

1. Navigate to: `sample_mflix` → `movies` collection

2. Click the **"Indexes"** tab

3. Click **"Create Index"**

4. Configure the index:

| Field | Value |
|-------|-------|
| **Field name** | `year` |
| **Order** | `1` (Ascending) |
| **Index name** | `idx_year` (or leave auto-generated) |

5. Click **"Create Index"**

**✅ Expected outcome**: You see `year_1` or `idx_year` in the indexes list.

---

### Step 3.2: Verify Index Usage with explain()

Now we'll verify that MongoDB is using our index.

**Option A: Using Atlas UI**

1. In the `movies` collection, click the **"Aggregations"** tab

2. Click the **"Explain"** button (instead of "Run")

3. Enter this filter in the query bar:
   ```json
   {"year": 1999}
   ```

4. Review the explain plan

**Option B: Using the Explain button on Documents tab**

1. In the `movies` collection (Documents tab), type filter: `{"year": 1999}`

2. Click the **"Explain"** button next to the Find button

3. Review the results

**What to look for in the Explain output:**

| Field | Good Value | Bad Value | Meaning |
|-------|------------|-----------|---------|
| **Stage** | `IXSCAN` | `COLLSCAN` | Index scan vs. Collection scan |
| **Documents examined** | 515 | ~21,000 | Documents scanned to find results |
| **Index keys examined** | 515 | 0 | Index entries examined |
| **Execution time** | <50ms | >200ms | Query speed |

**Interpretation of your results:**

```
✅ 515 documents returned
✅ 515 documents examined (NOT 21,000+)
✅ 515 index keys examined
✅ 12 ms execution time

Conclusion: The index on "year" is working correctly!
```

---

## Part 4: Aggregation Pipeline (5 minutes)

Aggregation pipelines process documents through multiple stages to transform and analyze data.

### Step 4.1: Build the Pipeline

**Option A: Using Text Mode (Recommended - Faster)**

1. Navigate to: `sample_mflix` → `movies` collection → **"Aggregations"** tab

2. Click the **`</> TEXT`** toggle

3. Delete any existing code and paste the following pipeline:

```json
[
  {
    "$match": {
      "year": { "$gte": 2010, "$lte": 2020 }
    }
  },
  {
    "$group": {
      "_id": "$year",
      "movieCount": { "$sum": 1 }
    }
  },
  {
    "$sort": {
      "movieCount": -1
    }
  },
  {
    "$limit": 5
  }
]
```

4. Click **"Run"**

**Option B: Using Stage Builder**

1. Click **`{} STAGES`** toggle
2. Click **"+ Add Stage"** (at bottom of pipeline panel) - repeat 4 times
3. Configure each stage:

| Stage | Operator | Expression |
|-------|----------|------------|
| Stage 1 | `$match` | `{"year": {"$gte": 2010, "$lte": 2020}}` |
| Stage 2 | `$group` | `{"_id": "$year", "movieCount": {"$sum": 1}}` |
| Stage 3 | `$sort` | `{"movieCount": -1}` |
| Stage 4 | `$limit` | `5` |

4. Click **"Run"**

---

### Step 4.2: Understand the Pipeline Stages

| Stage | Purpose | How it works |
|-------|---------|--------------|
| **`$match`** | Filter documents | Keeps only movies from 2010-2020 |
| **`$group`** | Group by year | Counts movies per year |
| **`$sort`** | Sort results | Orders by count (descending) |
| **`$limit`** | Limit output | Shows only top 5 years |

---

### Step 4.3: Expected Results

Your output should look similar to:

```json
{ "_id": 2012, "movieCount": 847 }
{ "_id": 2013, "movieCount": 812 }
{ "_id": 2010, "movieCount": 789 }
{ "_id": 2011, "movieCount": 765 }
{ "_id": 2014, "movieCount": 743 }
```

**Interpretation**: Most movies in the sample dataset were released between 2010-2014.

---

### Step 4.4: Challenge - Modify the Pipeline

Try these variations:

**Challenge 1: Find top 3 years with highest movie counts**

Change the `$limit` from `5` to `3` and re-run.

**Challenge 2: Find movies with high IMDB ratings**

```json
[
  { "$match": { "imdb.rating": { "$gte": 8.5 } } },
  { "$sort": { "imdb.rating": -1 } },
  { "$limit": 5 },
  { "$project": { "title": 1, "year": 1, "imdb.rating": 1 } }
]
```

**Challenge 3: Count movies by genre**

```json
[
  { "$unwind": "$genres" },
  { "$group": { "_id": "$genres", "movieCount": { "$sum": 1 } } },
  { "$sort": { "movieCount": -1 } },
  { "$limit": 5 }
]
```

---

## Part 5: Lab Completion Checklist

Verify you have completed all tasks:

| Task | Completed |
|------|-----------|
| ✅ Atlas account created (no credit card) | ☐ |
| ✅ M0 free cluster created and active | ☐ |
| ✅ Sample dataset loaded (`sample_mflix`) | ☐ |
| ✅ INSERT: Added new movie document | ☐ |
| ✅ READ: Filtered movies with `$gt` operator | ☐ |
| ✅ UPDATE: Modified a comment's name | ☐ |
| ✅ DELETE: Removed a test comment | ☐ |
| ✅ INDEX: Created index on `year` field | ☐ |
| ✅ EXPLAIN: Verified index usage (`IXSCAN`) | ☐ |
| ✅ AGGREGATION: Ran pipeline with 4 stages | ☐ |

---

## Common Issues & Troubleshooting

| Issue | Likely Cause | Solution |
|-------|--------------|----------|
| Filter returns no results | Misspelled field name | Check exact spelling: `year` not `yea` or `Year` |
| Filter not working | Didn't click Find | Click **Find** button or press **Enter** |
| Index not showing IXSCAN | Wrong field name | Verify index was created on `year` field |
| Aggregation returns timeout | M0 memory limit | Add `$match` early to filter data |
| Can't find Insert button | Wrong collection | Ensure you're in `sample_mflix.movies` |
| "Load Sample Dataset" missing | UI changed | Look under cluster "..." menu |
| Year 2010 not showing in `$gt` query | `$gt` excludes value | Use `$gte` for "greater than or equal" |

---

## Key Takeaways for Students

### What You Learned

1. **CRUD Operations**: How to Create, Read, Update, and Delete documents

2. **Indexing**: How indexes dramatically improve query performance (10x faster in our example)

3. **Explain Plan**: How to verify MongoDB is using indexes correctly

4. **Aggregation Pipeline**: How to chain stages (`$match` → `$group` → `$sort` → `$limit`) to analyze data

### Real-World Applications

| Skill | Production Use Case |
|-------|---------------------|
| **CRUD** | Daily application operations (user signups, product updates) |
| **Indexing** | Making search queries fast on millions of documents |
| **Explain** | Debugging slow queries in production |
| **Aggregation** | Generating reports, dashboards, analytics |

---

## Next Steps

After completing Lab 1:

1. **Save your pipeline** (if you want to reuse it):
   - Click the pipeline name "Untitled"
   - Rename to `Movies by Year 2010-2020`
   - Click **Save**

2. **Explore other collections**: Try the same operations on `comments`, `theaters`, or `users`

3. **Move to Lab 2**: Data Migration simulation

---

## Lab 1 Complete! ✅


_____________________________________