curl -X 'DELETE' "$api_url"/"$delete_uri"/"$interface_name" \
-H 'Content-Type: application/json' \
-H "Authorization: APIToken $api_token" \
-d "{
  \"fail_if_referred\": true,
  \"name\": \"$interface_name\",
  \"namespace\": \"$namespace\"
  }"