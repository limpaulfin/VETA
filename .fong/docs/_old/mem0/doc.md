```
DOM saved to file. File Path: /home/fong/Projects/web-dom-capture-chrome-extension/captured_doms/dom_2025-09-14_14-55-45-528779.html

--- View Instructions ---
Quick guide for inspecting the captured DOM file:
- [RECOMMENDED] Hoặc dùng MCP "fong-long-file-reader" để đọc file dài
- Check file size: `wc -l "/home/fong/Projects/web-dom-capture-chrome-extension/captured_doms/dom_2025-09-14_14-55-45-528779.html"`
- For small files (<200 LOC), use `cat`. For larger files, use `less`, `sed` or `grep`.
- For full instructions, view the first 100 lines of this file: `head -n 100 "/home/fong/Projects/web-dom-capture-chrome-extension/captured_doms/dom_2025-09-14_14-55-45-528779.html"`

--- DOM Content Extraction (HTML → Text) ---
- [RECOMMENDED] Clean HTML to text: `lynx -dump -nolist "/home/fong/Projects/web-dom-capture-chrome-extension/captured_doms/dom_2025-09-14_14-55-45-528779.html"`
- HTML to Markdown: `html2text "/home/fong/Projects/web-dom-capture-chrome-extension/captured_doms/dom_2025-09-14_14-55-45-528779.html"`
- Extract body text only: `xmllint --html --xpath "string(//body)" "/home/fong/Projects/web-dom-capture-chrome-extension/captured_doms/dom_2025-09-14_14-55-45-528779.html" 2>/dev/null`
- Remove HTML tags (simple): `sed -e 's/<[^>]*>//g' "/home/fong/Projects/web-dom-capture-chrome-extension/captured_doms/dom_2025-09-14_14-55-45-528779.html"`
```

```
Dashboard
Get Started
Requests
Memories
Graph Memory
Users
API Keys
Webhooks
Memory Exports
Settings
Usage
Subscriptions
Forum
Status
Help / Support
Mem0.ai
Upgrade

techsupport-default-org
/

default-project

Get 6 months of Pro for free
Dashboard
Playground
Docs

T
Install Mem0 easily in your preferred stack
5 mins
ColabLaunch API Playground
Documentation
1
Get API Key
Copy your auto-generated API key from the dashboard.

api_key


m0-*******Z34l
2
Add memory
Send a POST request to add conversation history to memory

Bash
bash

curl --request POST \
  --url https://api.mem0.ai/v1/memories/ \
  --header 'Authorization: Token YOUR_API_KEY' \
  --header 'Content-Type: application/json' \
  --data '{
  "messages": [
    {
      "role": "user",
      "content": "Hi, I'm Alex. I'm a vegetarian and I'm allergic to nuts."
    },
    {
      "role": "assistant", 
      "content": "Hello Alex! I see that you're a vegetarian with a nut allergy."
    }
  ],
  "user_id": "alex",
  "version": "v2"
}'
3
Search memory
Send a POST request to search through user's memory

Bash
bash

curl --request POST \
  --url https://api.mem0.ai/v2/memories/search/ \
  --header 'Authorization: Token YOUR_API_KEY' \
  --header 'Content-Type: application/json' \
  --data '{
  "query": "What can I cook for dinner tonight?",
  "filters": {
    "OR": [
      { "user_id": "alex" }
    ]
  }
}'
4
Apply to Mem0 Startup Program
Building a startup? We believe great ideas shouldn't be limited by budget constraints. Join thousands of founders already building with us.

Get 6 months of Mem0 Pro for free. Apply now, get approved instantly, start building without limits.
Apply Now
Get Started | Mem0
```

```
Mem0 home pagedark logo


Search...
Ctrl K
Documentation
API Reference
Overview
Memory APIs
POST
Add Memories
POST
Search Memories (v2)
POST
Search Memories (v1 - Deprecated)
POST
Get Memories (v2)
GET
Get Memories (v1 - Deprecated)
GET
Memory History
GET
Get Memory
PUT
Update Memory
PUT
Batch Update Memories
DEL
Delete Memory
DEL
Batch Delete Memories
DEL
Delete Memories
POST
Create Memory Export
POST
Get Memory Export
POST
Feedback
Entities APIs
Organizations APIs
Project APIs
Webhook APIs
Your Dashboard
Documentation
OpenMemory
Examples
Integrations
API Reference
Changelog
Memory APIs
Add Memories
Add memories

POST
/
v1
/
memories
/

Try it
Authorizations
​
Authorization
stringheaderrequired
API key authentication. Prefix your Mem0 API key with 'Token '. Example: 'Token your_api_key'

Body
application/json
​
messages
object[]
An array of message objects representing the content of the memory. Each message object typically contains 'role' and 'content' fields, where 'role' indicates the sender either 'user' or 'assistant' and 'content' contains the actual message text. This structure allows for the representation of conversations or multi-part memories.

Show child attributes

​
agent_id
string | null
The unique identifier of the agent associated with this memory.

​
user_id
string | null
The unique identifier of the user associated with this memory.

​
app_id
string | null
The unique identifier of the application associated with this memory.

​
run_id
string | null
The unique identifier of the run associated with this memory.

​
metadata
object | null
Additional metadata associated with the memory, which can be used to store any additional information or context about the memory. Best practice for incorporating additional information is through metadata (e.g. location, time, ids, etc.). During retrieval, you can either use these metadata alongside the query to fetch relevant memories or retrieve memories based on the query first and then refine the results using metadata during post-processing.

​
includes
string | null
String to include the specific preferences in the memory.

Minimum length: 1
​
excludes
string | null
String to exclude the specific preferences in the memory.

Minimum length: 1
​
infer
booleandefault:true
Wether to infer the memories or directly store the messages.

​
output_format
string | nulldefault:v1.0
It two output formats: v1.0 (default) and v1.1. We recommend using v1.1 as v1.0 will be deprecated soon.

​
custom_categories
object | null
A list of categories with category name and it's description.

​
custom_instructions
string | null
Defines project-specific guidelines for handling and organizing memories. When set at the project level, they apply to all new memories in that project.

​
immutable
booleandefault:false
Whether the memory is immutable.

​
async_mode
booleandefault:false
Whether to add the memory completely asynchronously.

​
timestamp
integer | null
The timestamp of the memory. Format: Unix timestamp

​
expiration_date
string | null
The date and time when the memory will expire. Format: YYYY-MM-DD

​
org_id
string | null
The unique identifier of the organization associated with this memory.

​
project_id
string | null
The unique identifier of the project associated with this memory.

​
version
string | null
The version of the memory to use. The default version is v1, which is deprecated. We recommend using v2 for new applications.

Response

200

application/json
Successful memory creation

​
id
stringrequired
​
data
objectrequired
Show child attributes

​
event
enum<string>required
Available options: ADD, UPDATE, DELETE 
Was this page helpful?


Yes

No
Suggest edits
Raise issue
Previous
Search Memories (v2)
Search memories based on a query and filters.
Next
Ask a question...

discord
x
github
linkedin
Powered by Mintlify
Python


Copy

Ask AI
# To use the Python SDK, install the package:
# pip install mem0ai

from mem0 import MemoryClient

client = MemoryClient(api_key="your_api_key", org_id="your_org_id", project_id="your_project_id")

messages = [
    {"role": "user", "content": "<user-message>"},
    {"role": "assistant", "content": "<assistant-response>"}
]

client.add(messages, user_id="<user-id>", version="v2")

200

400

Copy

Ask AI
[
  {
    "id": "<string>",
    "data": {
      "memory": "<string>"
    },
    "event": "ADD"
  }
]
Add Memories - Mem0
``` ```
Mem0 home pagedark logo


Search...
Ctrl K
Documentation
API Reference
Overview
Memory APIs
POST
Add Memories
POST
Search Memories (v2)
POST
Search Memories (v1 - Deprecated)
POST
Get Memories (v2)
GET
Get Memories (v1 - Deprecated)
GET
Memory History
GET
Get Memory
PUT
Update Memory
PUT
Batch Update Memories
DEL
Delete Memory
DEL
Batch Delete Memories
DEL
Delete Memories
POST
Create Memory Export
POST
Get Memory Export
POST
Feedback
Entities APIs
Organizations APIs
Project APIs
Webhook APIs
Your Dashboard
Documentation
OpenMemory
Examples
Integrations
API Reference
Changelog
Memory APIs
Search Memories (v2)
Search memories based on a query and filters.

POST
/
v2
/
memories
/
search
/

Try it
The v2 search API is powerful and flexible, allowing for more precise memory retrieval. It supports complex logical operations (AND, OR, NOT) and comparison operators for advanced filtering capabilities. The comparison operators include:
in: Matches any of the values specified
gte: Greater than or equal to
lte: Less than or equal to
gt: Greater than
lt: Less than
ne: Not equal to
icontains: Case-insensitive containment check
*: Wildcard character that matches everything

Code

Output

Copy

Ask AI
related_memories = m.search(
    query="What are Alice's hobbies?",
    version="v2",
    filters={
        "OR": [
            {
              "user_id": "alice"
            },
            {
              "agent_id": {"in": ["travel-agent", "sports-agent"]}
            }
        ]
    },
)

Wildcard Example

Copy

Ask AI
# Using wildcard to match all run_ids for a specific user
all_memories = m.search(
    query="What are Alice's hobbies?",
    version="v2",
    filters={
        "AND": [
            {
                "user_id": "alice"
            },
            {
                "run_id": "*"
            }
        ]
    },
)

Categories Filter Examples

Copy

Ask AI
# Example 1: Using 'contains' for partial matching
finance_memories = m.search(
    query="What are my financial goals?",
    version="v2",
    filters={
        "AND": [
            { "user_id": "alice" },
            {
                "categories": {
                    "contains": "finance"
                }
            }
        ]
    },
)

# Example 2: Using 'in' for exact matching
personal_memories = m.search(
    query="What personal information do you have?",
    version="v2",
    filters={
        "AND": [
            { "user_id": "alice" },
            {
                "categories": {
                    "in": ["personal_information"]
                }
            }
        ]
    },
)
Authorizations
​
Authorization
stringheaderrequired
API key authentication. Prefix your Mem0 API key with 'Token '. Example: 'Token your_api_key'

Body
application/json
​
query
stringrequired
The query to search for in the memory.

​
filters
objectrequired
A dictionary of filters to apply to the search. Available fields are: user_id, agent_id, app_id, run_id, created_at, updated_at, categories, keywords. Supports logical operators (AND, OR) and comparison operators (in, gte, lte, gt, lt, ne, contains, icontains). For categories field, use 'contains' for partial matching (e.g., {"categories": {"contains": "finance"}}) or 'in' for exact matching (e.g., {"categories": {"in": ["personal_information"]}}).

Show child attributes

​
version
stringdefault:v2
The version of the memory to use. This should always be v2.

​
top_k
integerdefault:10
The number of top results to return.

​
fields
string[]
A list of field names to include in the response. If not provided, all fields will be returned.

​
rerank
booleandefault:false
Whether to rerank the memories.

​
keyword_search
booleandefault:false
Whether to search for memories based on keywords.

​
filter_memories
booleandefault:false
Whether to filter the memories.

​
threshold
numberdefault:0.3
The minimum similarity threshold for returned results.

​
org_id
string | null
The unique identifier of the organization associated with the memory.

​
project_id
string | null
The unique identifier of the project associated with the memory.

Response
200 - application/json
​
id
string<uuid>required
Unique identifier for the memory

​
memory
stringrequired
The content of the memory

​
user_id
stringrequired
The identifier of the user associated with this memory

​
created_at
string<date-time>required
The timestamp when the memory was created

​
updated_at
string<date-time>required
The timestamp when the memory was last updated

​
metadata
object | null
Additional metadata associated with the memory

​
categories
string[]
Categories associated with the memory

​
immutable
booleandefault:false
Whether the memory is immutable.

​
expiration_date
string<date-time> | null
The date and time when the memory will expire. Format: YYYY-MM-DD

Was this page helpful?


Yes

No
Suggest edits
Raise issue
Previous
Search Memories (v1 - Deprecated)
Perform a semantic search on memories.
Next
Ask a question...

discord
x
github
linkedin
Powered by Mintlify
Python


Copy

Ask AI
# To use the Python SDK, install the package:
# pip install mem0ai

from mem0 import MemoryClient
client = MemoryClient(api_key="your_api_key", org_id="your_org_id", project_id="your_project_id")

query = "What do you know about me?"
filters = {
   "OR":[
      {
         "user_id":"alex"
      },
      {
         "agent_id":{
            "in":[
               "travel-assistant",
               "customer-support"
            ]
         }
      }
   ]
}
client.search(query, version="v2", filters=filters)

200

Copy

Ask AI
[
  {
    "id": "3c90c3cc-0d44-4b50-8888-8dd25736052a",
    "memory": "<string>",
    "user_id": "<string>",
    "metadata": {},
    "categories": [
      "<string>"
    ],
    "immutable": false,
    "expiration_date": null,
    "created_at": "2023-11-07T05:31:56Z",
    "updated_at": "2023-11-07T05:31:56Z"
  }
]
Search Memories (v2) - Mem0
```  ```
Mem0 home pagedark logo


Search...
Ctrl K
Documentation
API Reference
Overview
Memory APIs
POST
Add Memories
POST
Search Memories (v2)
POST
Search Memories (v1 - Deprecated)
POST
Get Memories (v2)
GET
Get Memories (v1 - Deprecated)
GET
Memory History
GET
Get Memory
PUT
Update Memory
PUT
Batch Update Memories
DEL
Delete Memory
DEL
Batch Delete Memories
DEL
Delete Memories
POST
Create Memory Export
POST
Get Memory Export
POST
Feedback
Entities APIs
Organizations APIs
Project APIs
Webhook APIs
Your Dashboard
Documentation
OpenMemory
Examples
Integrations
API Reference
Changelog
Memory APIs
Get Memories (v2)
Get all memories

POST
/
v2
/
memories
/

Try it
The v2 get memories API is powerful and flexible, allowing for more precise memory listing without the need for a search query. It supports complex logical operations (AND, OR, NOT) and comparison operators for advanced filtering capabilities. The comparison operators include:
in: Matches any of the values specified
gte: Greater than or equal to
lte: Less than or equal to
gt: Greater than
lt: Less than
ne: Not equal to
icontains: Case-insensitive containment check
*: Wildcard character that matches everything

Code

Output

Copy

Ask AI
memories = m.get_all(
    filters={
        "AND": [
            {
                "user_id": "alex"
            },
            {
                "created_at": {"gte": "2024-07-01", "lte": "2024-07-31"}
            }
        ]
    },
    version="v2"
)

Wildcard Example

Copy

Ask AI
# Using wildcard to get all memories for a specific user across all run_ids
memories = m.get_all(
    filters={
        "AND": [
            {
                "user_id": "alex"
            },
            {
                "run_id": "*"
            }
        ]
    },
    version="v2"
)
Authorizations
​
Authorization
stringheaderrequired
API key authentication. Prefix your Mem0 API key with 'Token '. Example: 'Token your_api_key'

Query Parameters
​
filters
object
Filters to apply to the memories. Available fields are: user_id, agent_id, app_id, run_id, created_at, updated_at, categories, keywords. Supports logical operators (AND, OR) and comparison operators (in, gte, lte, gt, lt, ne, contains, icontains). For categories field, use 'contains' for partial matching (e.g., {"categories": {"contains": "finance"}}) or 'in' for exact matching (e.g., {"categories": {"in": ["personal_information"]}}).

Show child attributes

​
fields
string[]
A list of field names to include in the response. If not provided, all fields will be returned.

​
org_id
string
Filter memories by organization ID.

​
project_id
string
Filter memories by project ID.

​
page
integer
Page number for pagination. Default: 1

​
page_size
integer
Number of items per page. Default: 100

Response

200

application/json
​
id
stringrequired
​
memory
stringrequired
​
created_at
string<date-time>required
​
updated_at
string<date-time>required
​
owner
stringrequired
​
organization
stringrequired
​
immutable
booleandefault:false
Whether the memory is immutable.

​
expiration_date
string<date-time> | null
The date and time when the memory will expire. Format: YYYY-MM-DD

​
metadata
object
Was this page helpful?


Yes

No
Suggest edits
Raise issue
Previous
Get Memories (v1 - Deprecated)
Get all memories
Next
Ask a question...

discord
x
github
linkedin
Powered by Mintlify
Python


Copy

Ask AI
# To use the Python SDK, install the package:
# pip install mem0ai

from mem0 import MemoryClient
client = MemoryClient(api_key="your_api_key", org_id="your_org_id", project_id="your_project_id")

# Retrieve memories with filters
memories = client.get_all(
    filters={
        "AND": [
            {
                "user_id": "alex"
            },
            {
                "created_at": {
                    "gte": "2024-07-01",
                    "lte": "2024-07-31"
                }
            }
        ]
    },
    version="v2"
)

print(memories)

200

400

Copy

Ask AI
[
  {
    "id": "<string>",
    "memory": "<string>",
    "created_at": "2023-11-07T05:31:56Z",
    "updated_at": "2023-11-07T05:31:56Z",
    "owner": "<string>",
    "immutable": false,
    "expiration_date": null,
    "organization": "<string>",
    "metadata": {}
  }
]
Get Memories (v2) - Mem0
```

 ```
Mem0 home pagedark logo


Search...
Ctrl K
Documentation
API Reference
Overview
Memory APIs
POST
Add Memories
POST
Search Memories (v2)
POST
Search Memories (v1 - Deprecated)
POST
Get Memories (v2)
GET
Get Memories (v1 - Deprecated)
GET
Memory History
GET
Get Memory
PUT
Update Memory
PUT
Batch Update Memories
DEL
Delete Memory
DEL
Batch Delete Memories
DEL
Delete Memories
POST
Create Memory Export
POST
Get Memory Export
POST
Feedback
Entities APIs
Organizations APIs
Project APIs
Webhook APIs
Your Dashboard
Documentation
OpenMemory
Examples
Integrations
API Reference
Changelog
Memory APIs
Memory History
Retrieve the history of a memory.

GET
/
v1
/
memories
/
{memory_id}
/
history
/

Try it
Authorizations
​
Authorization
stringheaderrequired
API key authentication. Prefix your Mem0 API key with 'Token '. Example: 'Token your_api_key'

Path Parameters
​
memory_id
string<uuid>required
The unique identifier of the memory to retrieve

Response
200 - application/json
Successfully retrieved the memory history

​
id
string<uuid>required
Unique identifier for the history entry

​
memory_id
string<uuid>required
Unique identifier of the associated memory

​
input
object[]required
The conversation input that led to this memory change

Show child attributes

​
new_memory
stringrequired
The new or updated state of the memory

​
user_id
stringrequired
The identifier of the user associated with this memory

​
event
enum<string>required
The type of event that occurred

Available options: ADD, UPDATE, DELETE 
​
created_at
string<date-time>required
The timestamp when this history entry was created

​
updated_at
string<date-time>required
The timestamp when this history entry was last updated

​
old_memory
string | null
The previous state of the memory, if applicable

​
metadata
object | null
Additional metadata associated with the memory change

Was this page helpful?


Yes

No
Suggest edits
Raise issue
Previous
Get Memory
Get a memory.
Next
Ask a question...

discord
x
github
linkedin
Powered by Mintlify
Python


Copy

Ask AI
# To use the Python SDK, install the package:
# pip install mem0ai

from mem0 import MemoryClient
client = MemoryClient(api_key="your_api_key", org_id="your_org_id", project_id="your_project_id")

# Add some message to create history
messages = [{"role": "user", "content": "<user-message>"}]
client.add(messages, user_id="<user-id>")

# Add second message to update history
messages.append({"role": "user", "content": "<user-message>"})
client.add(messages, user_id="<user-id>")

# Get history of how memory changed over time
memory_id = "<memory-id-here>"
history = client.history(memory_id)

200

Copy

Ask AI
[
  {
    "id": "3c90c3cc-0d44-4b50-8888-8dd25736052a",
    "memory_id": "3c90c3cc-0d44-4b50-8888-8dd25736052a",
    "input": [
      {
        "role": "user",
        "content": "<string>"
      }
    ],
    "old_memory": "<string>",
    "new_memory": "<string>",
    "user_id": "<string>",
    "event": "ADD",
    "metadata": {},
    "created_at": "2023-11-07T05:31:56Z",
    "updated_at": "2023-11-07T05:31:56Z"
  }
]
Memory History - Mem0
```


 ```
Mem0 home pagedark logo


Search...
Ctrl K
Documentation
API Reference
Overview
Memory APIs
POST
Add Memories
POST
Search Memories (v2)
POST
Search Memories (v1 - Deprecated)
POST
Get Memories (v2)
GET
Get Memories (v1 - Deprecated)
GET
Memory History
GET
Get Memory
PUT
Update Memory
PUT
Batch Update Memories
DEL
Delete Memory
DEL
Batch Delete Memories
DEL
Delete Memories
POST
Create Memory Export
POST
Get Memory Export
POST
Feedback
Entities APIs
Organizations APIs
Project APIs
Webhook APIs
Your Dashboard
Documentation
OpenMemory
Examples
Integrations
API Reference
Changelog
Memory APIs
Get Memory
Get a memory.

GET
/
v1
/
memories
/
{memory_id}
/

Try it
Authorizations
​
Authorization
stringheaderrequired
API key authentication. Prefix your Mem0 API key with 'Token '. Example: 'Token your_api_key'

Path Parameters
​
memory_id
string<uuid>required
The unique identifier of the memory to retrieve

Response

200

application/json
Successfully retrieved the memory

​
id
string<uuid>
Unique identifier for the memory

​
memory
string
The content of the memory

​
user_id
string
Identifier of the user associated with this memory

​
agent_id
string | null
The agent ID associated with the memory, if any

​
app_id
string | null
The app ID associated with the memory, if any

​
run_id
string | null
The run ID associated with the memory, if any

​
hash
string
Hash of the memory content

​
metadata
object
Additional metadata associated with the memory

​
created_at
string<date-time>
Timestamp of when the memory was created

​
updated_at
string<date-time>
Timestamp of when the memory was last updated

Was this page helpful?


Yes

No
Suggest edits
Raise issue
Previous
Update Memory
Get or Update or delete a memory.
Next
Ask a question...

discord
x
github
linkedin
Powered by Mintlify
Python


Copy

Ask AI
# To use the Python SDK, install the package:
# pip install mem0ai

from mem0 import MemoryClient
client = MemoryClient(api_key="your_api_key", org_id="your_org_id", project_id="your_project_id")

memory = client.get(memory_id="<memory_id>")

200

404

Copy

Ask AI
{
  "id": "3c90c3cc-0d44-4b50-8888-8dd25736052a",
  "memory": "<string>",
  "user_id": "<string>",
  "agent_id": "<string>",
  "app_id": "<string>",
  "run_id": "<string>",
  "hash": "<string>",
  "metadata": {},
  "created_at": "2023-11-07T05:31:56Z",
  "updated_at": "2023-11-07T05:31:56Z"
}
Get Memory - Mem0
```


```
Mem0 home pagedark logo


Search...
Ctrl K
Documentation
API Reference
Overview
Memory APIs
POST
Add Memories
POST
Search Memories (v2)
POST
Search Memories (v1 - Deprecated)
POST
Get Memories (v2)
GET
Get Memories (v1 - Deprecated)
GET
Memory History
GET
Get Memory
PUT
Update Memory
PUT
Batch Update Memories
DEL
Delete Memory
DEL
Batch Delete Memories
DEL
Delete Memories
POST
Create Memory Export
POST
Get Memory Export
POST
Feedback
Entities APIs
Organizations APIs
Project APIs
Webhook APIs
Your Dashboard
Documentation
OpenMemory
Examples
Integrations
API Reference
Changelog
Memory APIs
Update Memory
Get or Update or delete a memory.

PUT
/
v1
/
memories
/
{memory_id}
/

Try it
Authorizations
​
Authorization
stringheaderrequired
API key authentication. Prefix your Mem0 API key with 'Token '. Example: 'Token your_api_key'

Path Parameters
​
memory_id
string<uuid>required
The unique identifier of the memory to retrieve

Body
application/json
​
text
string
The updated text content of the memory

​
metadata
object
Additional metadata associated with the memory

Response
200 - application/json
Successfully updated memory

​
id
string<uuid>
The unique identifier of the updated memory

​
text
string
The updated text content of the memory

​
user_id
string | null
The user ID associated with the memory, if any

​
agent_id
string | null
The agent ID associated with the memory, if any

​
app_id
string | null
The app ID associated with the memory, if any

​
run_id
string | null
The run ID associated with the memory, if any

​
hash
string
Hash of the memory content

​
metadata
object
Additional metadata associated with the memory

​
created_at
string<date-time>
Timestamp of when the memory was created

​
updated_at
string<date-time>
Timestamp of when the memory was last updated

Was this page helpful?


Yes

No
Suggest edits
Raise issue
Previous
Batch Update Memories
Batch update multiple memories (up to 1000) in a single API call.
Next
Ask a question...

discord
x
github
linkedin
Powered by Mintlify
Python


Copy

Ask AI
# To use the Python SDK, install the package:
# pip install mem0ai

from mem0 import MemoryClient
client = MemoryClient(api_key="your_api_key", org_id="your_org_id", project_id="your_project_id")

# Update a memory
memory_id = "<memory_id>"
client.update(
    memory_id=memory_id,
    text="Your updated memory message here",
    metadata={"category": "example"}
)

200

Copy

Ask AI
{
  "id": "3c90c3cc-0d44-4b50-8888-8dd25736052a",
  "text": "<string>",
  "user_id": "<string>",
  "agent_id": "<string>",
  "app_id": "<string>",
  "run_id": "<string>",
  "hash": "<string>",
  "metadata": {},
  "created_at": "2023-11-07T05:31:56Z",
  "updated_at": "2023-11-07T05:31:56Z"
}
Update Memory - Mem0
```


 ```
Mem0 home pagedark logo


Search...
Ctrl K
Documentation
API Reference
Overview
Memory APIs
POST
Add Memories
POST
Search Memories (v2)
POST
Search Memories (v1 - Deprecated)
POST
Get Memories (v2)
GET
Get Memories (v1 - Deprecated)
GET
Memory History
GET
Get Memory
PUT
Update Memory
PUT
Batch Update Memories
DEL
Delete Memory
DEL
Batch Delete Memories
DEL
Delete Memories
POST
Create Memory Export
POST
Get Memory Export
POST
Feedback
Entities APIs
Organizations APIs
Project APIs
Webhook APIs
Your Dashboard
Documentation
OpenMemory
Examples
Integrations
API Reference
Changelog
Memory APIs
Batch Update Memories
Batch update multiple memories (up to 1000) in a single API call.

PUT
/
v1
/
batch
/

Try it
Authorizations
​
Authorization
stringheaderrequired
API key authentication. Prefix your Mem0 API key with 'Token '. Example: 'Token your_api_key'

Body
application/json
​
memories
object[]required
Maximum length: 1000
Show child attributes

Response

200

application/json
Successfully updated memories

​
message
string
Example:
"Successfully updated 2 memories"

Was this page helpful?


Yes

No
Suggest edits
Raise issue
Previous
Delete Memory
Get or Update or delete a memory.
Next
Ask a question...

discord
x
github
linkedin
Powered by Mintlify
Python


Copy

Ask AI
# To use the Python SDK, install the package:
# pip install mem0ai

from mem0 import MemoryClient
client = MemoryClient(api_key="your_api_key", org_id="your_org_id", project_id="your_project_id")

update_memories = [
    {
        "memory_id": "285ed74b-6e05-4043-b16b-3abd5b533496",
        "text": "Watches football"
    },
    {
        "memory_id": "2c9bd859-d1b7-4d33-a6b8-94e0147c4f07",
        "text": "Likes to travel"
    }
]

response = client.batch_update(update_memories)
print(response)

200

400

Copy

Ask AI
{
  "message": "Successfully updated 2 memories"
}
Batch Update Memories - Mem0
``` ```
Mem0 home pagedark logo


Search...
Ctrl K
Documentation
API Reference
Overview
Memory APIs
POST
Add Memories
POST
Search Memories (v2)
POST
Search Memories (v1 - Deprecated)
POST
Get Memories (v2)
GET
Get Memories (v1 - Deprecated)
GET
Memory History
GET
Get Memory
PUT
Update Memory
PUT
Batch Update Memories
DEL
Delete Memory
DEL
Batch Delete Memories
DEL
Delete Memories
POST
Create Memory Export
POST
Get Memory Export
POST
Feedback
Entities APIs
Organizations APIs
Project APIs
Webhook APIs
Your Dashboard
Documentation
OpenMemory
Examples
Integrations
API Reference
Changelog
Memory APIs
Delete Memory
Get or Update or delete a memory.

DELETE
/
v1
/
memories
/
{memory_id}
/

Try it
Authorizations
​
Authorization
stringheaderrequired
API key authentication. Prefix your Mem0 API key with 'Token '. Example: 'Token your_api_key'

Path Parameters
​
memory_id
string<uuid>required
The unique identifier of the memory to retrieve

Response
204 - application/json
Successful deletion of memory

​
message
string
Example:
"Memory deleted successfully!"

Was this page helpful?


Yes

No
Suggest edits
Raise issue
Previous
Batch Delete Memories
Batch delete multiple memories (up to 1000) in a single API call.
Next
Ask a question...

discord
x
github
linkedin
Powered by Mintlify
Python


Copy

Ask AI
# To use the Python SDK, install the package:
# pip install mem0ai

from mem0 import MemoryClient
client = MemoryClient(api_key="your_api_key", org_id="your_org_id", project_id="your_project_id")

memory_id = "<memory_id>"
client.delete(memory_id=memory_id)

204

Copy

Ask AI
{
  "message": "Memory deleted successfully!"
}
Delete Memory - Mem0
```


 ```
Mem0 home pagedark logo


Search...
Ctrl K
Documentation
API Reference
Overview
Memory APIs
POST
Add Memories
POST
Search Memories (v2)
POST
Search Memories (v1 - Deprecated)
POST
Get Memories (v2)
GET
Get Memories (v1 - Deprecated)
GET
Memory History
GET
Get Memory
PUT
Update Memory
PUT
Batch Update Memories
DEL
Delete Memory
DEL
Batch Delete Memories
DEL
Delete Memories
POST
Create Memory Export
POST
Get Memory Export
POST
Feedback
Entities APIs
Organizations APIs
Project APIs
Webhook APIs
Your Dashboard
Documentation
OpenMemory
Examples
Integrations
API Reference
Changelog
Memory APIs
Batch Delete Memories
Batch delete multiple memories (up to 1000) in a single API call.

DELETE
/
v1
/
batch
/

Try it
Authorizations
​
Authorization
stringheaderrequired
API key authentication. Prefix your Mem0 API key with 'Token '. Example: 'Token your_api_key'

Body
application/json
​
memory_ids
string<uuid>[]required
Array of memory IDs to delete

Maximum length: 1000
Response

200

application/json
Successfully deleted memories

​
message
string
Example:
"Successfully deleted 2 memories"

Was this page helpful?


Yes

No
Suggest edits
Raise issue
Previous
Delete Memories
Delete memories
Next
Ask a question...

discord
x
github
linkedin
Powered by Mintlify
Python


Copy

Ask AI
# To use the Python SDK, install the package:
# pip install mem0ai

from mem0 import MemoryClient
client = MemoryClient(api_key="your_api_key", org_id="your_org_id", project_id="your_project_id")

delete_memories = [
    {"memory_id": "285ed74b-6e05-4043-b16b-3abd5b533496"},
    {"memory_id": "2c9bd859-d1b7-4d33-a6b8-94e0147c4f07"}
]

response = client.batch_delete(delete_memories)
print(response)

200

400

Copy

Ask AI
{
  "message": "Successfully deleted 2 memories"
}
Batch Delete Memories - Mem0
```


```
Mem0 home pagedark logo


Search...
Ctrl K
Documentation
API Reference
Overview
Memory APIs
POST
Add Memories
POST
Search Memories (v2)
POST
Search Memories (v1 - Deprecated)
POST
Get Memories (v2)
GET
Get Memories (v1 - Deprecated)
GET
Memory History
GET
Get Memory
PUT
Update Memory
PUT
Batch Update Memories
DEL
Delete Memory
DEL
Batch Delete Memories
DEL
Delete Memories
POST
Create Memory Export
POST
Get Memory Export
POST
Feedback
Entities APIs
Organizations APIs
Project APIs
Webhook APIs
Your Dashboard
Documentation
OpenMemory
Examples
Integrations
API Reference
Changelog
Memory APIs
Delete Memories
Delete memories

DELETE
/
v1
/
memories
/

Try it
Authorizations
​
Authorization
stringheaderrequired
API key authentication. Prefix your Mem0 API key with 'Token '. Example: 'Token your_api_key'

Query Parameters
​
user_id
string
Filter memories by user ID

​
agent_id
string
Filter memories by agent ID

​
app_id
string
Filter memories by app ID

​
run_id
string
Filter memories by run ID

​
metadata
object
Filter memories by metadata (JSON string)

​
org_id
string
Filter memories by organization ID.

​
project_id
string
Filter memories by project ID.

Response
204 - application/json
Successful deletion of memories

​
message
string
Example:
"Memories deleted successfully!"

Was this page helpful?


Yes

No
Suggest edits
Raise issue
Previous
Create Memory Export
Create a structured export of memories based on a provided schema.
Next
Ask a question...

discord
x
github
linkedin
Powered by Mintlify
Python


Copy

Ask AI
# To use the Python SDK, install the package:
# pip install mem0ai

from mem0 import MemoryClient
client = MemoryClient(api_key="your_api_key", org_id="your_org_id", project_id="your_project_id")

# Delete all memories for a specific user
client.delete_all(user_id="<user_id>")

204

Copy

Ask AI
{
  "message": "Memories deleted successfully!"
}
Delete Memories - Mem0
```