curl -v -X 'DELETE' "$api_url"/"$delete_uri"/"$name" \
-H 'Content-Type: application/data' \
-H "Authorization: APIToken $api_token" \
-d "{
  \"fail_if_referred\": true,
  \"name\": \"$name\",
  \"namespace\": \"$namespace\"
  }"