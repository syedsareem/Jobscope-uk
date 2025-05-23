# -----------------------------------------------------
# Adzuna API Job Listings Fetch Script
# Fetches 1000 UK job listings (20 pages x 50)
# Saves JSON file locally for upload to S3
# -----------------------------------------------------

import json
import requests
import datetime

# Adzuna API credentials
adzuna_app_id = '<YOUR_ADZUNA_APP_ID>'
adzuna_app_key = '<YOUR_ADZUNA_APP_KEY>'

#Container for all job results
all_results = []

# Loop over multiple pages (Adzuna supports pagination)
for page in range(1, 21):  # 20 pages * 50 results = 1000 listings approx
    print(f"Fetching page {page}...")
    url = f'https://api.adzuna.com/v1/api/jobs/gb/search/{page}'
    params = {
        'app_id': adzuna_app_id,
        'app_key': adzuna_app_key,
        'results_per_page': 50,
        'content-type': 'application/json'
    }

    response = requests.get(url, params=params)
    response.raise_for_status()  # Raise an error for bad responses
    page_data = response.json()

    # Append jobs from this page to the master list
    all_results.extend(page_data.get('results', []))

#Wrap the results with metadata (source + timestamp)
final_data = {
    'source': 'adzuna',
    'fetched_at': datetime.datetime.utcnow().isoformat(),
    'results': all_results
}

#Create filename based on today's date
today = datetime.date.today().isoformat()
filename = f'adzuna_gb_full_{today}.json'

#Save the data as a formatted JSON file
with open(filename, 'w', encoding='utf-8') as f:
    json.dump(final_data, f, indent=2)

print(f"\u2705 Saved {len(all_results)} jobs to {filename}")

# -----------------------------------------------------

